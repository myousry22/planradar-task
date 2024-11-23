require 'rails_helper'

module Notifications
  RSpec.describe EmailNotification do
    let(:user) { create(:user, email: 'test@example.com') }
    let(:ticket) { create(:ticket, user: user) }
    let(:mail_time) { 1.day.from_now }

    describe '#send' do
      it 'sends an email to the user with the correct ticket' do
        allow(UserMailer).to receive_message_chain(:due_date_reminder, :deliver_later)

        notification = EmailNotification.new
        notification.send(ticket, mail_time)

        expect(UserMailer).to have_received(:due_date_reminder).with(user, ticket)
        expect(UserMailer.due_date_reminder(user, ticket)).to have_received(:deliver_later).with(wait_until: mail_time)
      end
    end
  end
end
