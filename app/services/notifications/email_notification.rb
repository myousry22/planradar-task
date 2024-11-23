module Notifications
  class EmailNotification < BaseNotification
    def send(ticket, mail_time)
      user = ticket.user
      Rails.logger.info("Attempting to send email to #{user.email} about ticket #{ticket.id}")
      UserMailer.due_date_reminder(user, ticket).deliver_later(wait_until: mail_time)
      Rails.logger.info("Email sent to #{user.email}")
    end
  end
end
