
require 'rails_helper'

RSpec.describe SendDueDateReminderWorker do
  let(:worker) { described_class.new }
  let(:vienna_timezone) { 'Vienna' }

  describe '#perform' do
    def future_time
      Time.zone.now.tomorrow.change(hour: 14, min: 30)
    end

    around do |example|
      Time.use_zone(vienna_timezone) { example.run }
    end

    let(:current_time) { future_time }

    before do
      allow(Time).to receive(:now).and_return(current_time)
      allow(NotificationSenderService).to receive(:new).and_return(double(call: true))
    end

    context 'when there are users with due date reminders' do
      let!(:user_with_reminder) do
        create(:user,
          due_date_reminder_interval: 0,
          send_due_date_reminder: true,
          due_date_reminder_time: current_time.utc
        )
      end

      let!(:ticket) do
        create(:ticket,
          user: user_with_reminder,
          due_date: current_time.to_date
        )
      end

      let!(:user_without_reminder) do
        create(:user,
          send_due_date_reminder: false,
          due_date_reminder_time: current_time.utc
        )
      end

      let!(:user_different_hour) do
        create(:user,
          send_due_date_reminder: true,
          due_date_reminder_interval: 0,
          due_date_reminder_time: (current_time + 1.hour).utc
        )
      end

      it 'processes reminders for eligible users' do
        expect(NotificationSenderService).to receive(:new).with({
          type: 'email',
          ticket: ticket,
          notification_time: anything
        })

        worker.perform
      end

      it 'does not process reminders for users with reminders disabled' do
        worker.perform

        expect(NotificationSenderService).not_to have_received(:new).with(
          hash_including(ticket: user_without_reminder.tickets.first)
        )
      end

      it 'does not process reminders for users with different reminder hours' do
        worker.perform

        expect(NotificationSenderService).not_to have_received(:new).with(
          hash_including(ticket: user_different_hour.tickets.first)
        )
      end
    end

    context 'timezone handling' do
      let(:reminder_time_vienna) { current_time }
      let(:user_vienna) do
        create(:user,
          send_due_date_reminder: true,
          due_date_reminder_interval: 0,
          due_date_reminder_time: reminder_time_vienna.utc
        )
      end

      before do
        create(:ticket,
          user: user_vienna,
          due_date: reminder_time_vienna.to_date
        )
      end

      it 'correctly handles Vienna timezone conversions' do

        expect(user_vienna.due_date_reminder_time.in_time_zone(vienna_timezone).hour)
          .to eq reminder_time_vienna.hour

        worker.perform

        expect(NotificationSenderService).to have_received(:new).once
      end

      context 'when crossing UTC boundaries' do
        let(:reminder_time_vienna) { current_time }

        it 'handles timezone conversions correctly during UTC boundary crossing' do
          # UTC time will be the previous day
          expect(user_vienna.due_date_reminder_time.utc.day)
            .not_to eq reminder_time_vienna.day

          # But Vienna time should match
          expect(user_vienna.due_date_reminder_time.in_time_zone(vienna_timezone).hour)
            .to eq reminder_time_vienna.hour

          worker.perform

          expect(NotificationSenderService).to have_received(:new).once
        end
      end
    end
  end


  describe '#process_user_reminders' do
    let(:current_time) { Time.zone.now.tomorrow.change(hour: 14, min: 30) }
    let(:user) { create(:user, due_date_reminder_interval: 0, send_due_date_reminder: true, due_date_reminder_time: current_time.utc) }
    let(:user_invalid) { create(:user) }
    let!(:ticket) { create(:ticket, user: user, due_date: current_time.to_date) }
    let(:notification_service) { instance_double(NotificationSenderService, call: true) }

    around do |example|
      Time.use_zone(vienna_timezone) { example.run }
    end

    before do
      allow(Time).to receive(:now).and_return(current_time)
      allow(ticket).to receive(:reminder_time_for_user).and_return(current_time)
    end

    it 'sends notification when reminder time matches current hour' do
      expect(NotificationSenderService).to receive(:new)
        .with(
          hash_including(
            type: 'email',
            ticket: ticket,
            notification_time: current_time
          )
        )
        .and_return(notification_service)

      worker.send(:process_user_reminders, user)
    end

    it 'skips notification when reminder time is nil' do
      allow(ticket).to receive(:reminder_time_for_user).and_return(nil)

      expect(NotificationSenderService).not_to receive(:new)

      worker.send(:process_user_reminders, user_invalid)
    end

    it 'skips notification when reminder time is different hour' do
      different_hour = current_time + 1.hour
      allow(ticket).to receive(:reminder_time_for_user).and_return(different_hour)

      expect(NotificationSenderService).not_to receive(:new)

      worker.send(:process_user_reminders, user_invalid)
    end

    it 'skips notification when reminder time is different date' do
      different_date = current_time + 1.day
      allow(ticket).to receive(:reminder_time_for_user).and_return(different_date)

      expect(NotificationSenderService).not_to receive(:new)

      worker.send(:process_user_reminders, user_invalid)
    end
  end

end
