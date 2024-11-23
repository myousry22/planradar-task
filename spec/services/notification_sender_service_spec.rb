require 'rails_helper'

RSpec.describe NotificationSenderService do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:ticket) { create(:ticket, user: user) }
  let(:mail_time) { 1.day.from_now }

  describe '#call' do
    context 'when the notification type is email' do
      it 'sends an email notification' do

        notification_service = instance_double("Notifications::EmailNotification")
        allow(Notifications::EmailNotification).to receive(:new).and_return(notification_service)
        allow(notification_service).to receive(:send)

        service = NotificationSenderService.new({ticket: ticket, type: 'email', notification_time: mail_time})
        service.call

        expect(notification_service).to have_received(:send).with(ticket, mail_time)
      end
    end

    context 'when the notification type is unsupported' do
      it 'raises an error' do
        service = NotificationSenderService.new({ticket: ticket, type: 'push', notification_time: mail_time})

        expect { service.call }.to raise_error("Unsupported notification type")
      end
    end
  end
end
