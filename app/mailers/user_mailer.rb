class UserMailer < ApplicationMailer
  default from: 'no-reply@planradar.com'

  def due_date_reminder(user, ticket)
    @user = user
    @due_date = ticket.due_date
    @ticket_title = ticket.title

    mail(to: @user.email, subject: "Reminder: Due Date for Ticket #{@ticket_title}")
  end
end
