require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(
  name: 'Send due date reminders - every 2 minutes',  # Change the name for clarity
  cron: '0 * * * *',  # Every 2 minutes
  class: 'SendDueDateReminderWorker'
)
