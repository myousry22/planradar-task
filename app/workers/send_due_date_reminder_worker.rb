class SendDueDateReminderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    start_of_hour = Time.now.in_time_zone('Vienna').beginning_of_hour
    end_of_hour = Time.now.in_time_zone('Vienna').end_of_hour


    start_of_hour_utc = start_of_hour.utc
    end_of_hour_utc = end_of_hour.utc


    users_with_reminders =User.joins(:tickets)
                              .where(send_due_date_reminder: true)
                              .where("due_date_reminder_time BETWEEN ? AND ?", start_of_hour_utc, end_of_hour_utc)
                              .where.not(tickets: { due_date: nil })



    users_with_reminders.each do |user|
      process_user_reminders(user)
    end
  end


  private
  def process_user_reminders(user)
    current_time = Time.now.in_time_zone('Vienna')
    user.tickets.each do |ticket|
      reminder_time = ticket.reminder_time_for_user(user)
      next unless reminder_time && reminder_time.to_date == current_time.to_date && reminder_time.hour == current_time.hour
      notification_params = {
        type: 'email',
        ticket: ticket,
        notification_time: reminder_time
      }
      notification_sender = NotificationSenderService.new(notification_params)
      notification_sender.call
    end
  end

end
