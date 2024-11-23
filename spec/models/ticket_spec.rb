require 'rails_helper'

RSpec.describe Ticket, type: :model do
  # Model Validations test
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:assigned_user_id) }
  it { should validate_presence_of(:status_id) }
  it { should validate_presence_of(:progress) }

  describe 'due_date_validity' do
    it 'should add an error if the due_date is in the past' do
      ticket = Ticket.new(due_date: Date.yesterday)
      ticket.valid?
      expect(ticket.errors[:due_date]).to include("can't be in the past")
    end

    it 'should not add an error if the due_date is today or in the future' do
      ticket = Ticket.new(due_date: Date.today)
      ticket.valid?
      expect(ticket.errors[:due_date]).to be_empty
    end
  end

  # Model Associations test
  it { should belong_to(:user).with_foreign_key('assigned_user_id') }

  # Model Methods test
  describe '#reminder_time_for_user' do
    let(:user) { create(:user, send_due_date_reminder: true, due_date_reminder_interval: 1, due_date_reminder_time: Time.new(2024, 11, 23, 9, 0, 0)) }
    let(:ticket) { create(:ticket, due_date: Date.tomorrow, assigned_user_id: user.id) }

    it 'calculates reminder time correctly for user' do
      reminder_time = ticket.reminder_time_for_user(user)

      expected_time = (ticket.due_date - user.due_date_reminder_interval.days).in_time_zone(user.time_zone).change(
        hour: user.due_date_reminder_time.hour,
        min: user.due_date_reminder_time.min
      )

      expect(reminder_time).to eq(expected_time)
    end

    it 'returns nil if due_date is nil' do
      ticket.due_date = nil
      expect(ticket.reminder_time_for_user(user)).to be_nil
    end

    it 'returns nil if reminders are not enabled for user' do
      user.send_due_date_reminder = false
      expect(ticket.reminder_time_for_user(user)).to be_nil
    end
  end
end
