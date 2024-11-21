require 'sidekiq/cron/job'


Sidekiq::Cron::Job.create(
  name: 'Send due date reminders - every hour',
  cron: '0 * * * *',
  class: 'SendDueDateReminderWorker'
)
