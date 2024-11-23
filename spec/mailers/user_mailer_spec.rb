require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'due_date_reminder' do
    let(:user) { create(:user, email: 'user@example.com') }
    let(:ticket) { create(:ticket, title: 'Test Ticket', due_date: Date.tomorrow, assigned_user_id: user.id) }

    subject(:mail) { UserMailer.due_date_reminder(user, ticket) }

    it 'sends an email to the user' do
      expect(mail.to).to eq([user.email])
    end

    it 'has the correct subject' do
      expect(mail.subject).to eq("Reminder: Due Date for Ticket #{ticket.title}")
    end

    it 'includes the ticket title in the body' do
      expect(mail.body.encoded).to include(ticket.title)
    end

    it 'includes the due date in the body' do
      expect(mail.body.encoded).to include(ticket.due_date.to_s)
    end

    it 'has the correct sender email' do
      expect(mail.from).to eq(['no-reply@planradar.com'])
    end
  end
end
