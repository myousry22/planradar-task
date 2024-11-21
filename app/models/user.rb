class User < ApplicationRecord


  # Model Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :send_due_date_reminder, inclusion: { in: [true, false] }
  validates :due_date_reminder_interval, presence: true
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name), message: "%{value} is not a valid time zone" }
  validates :due_date_reminder_time, presence: true, if: :send_due_date_reminder?

  # Model Associations
  has_many :tickets, foreign_key: 'assigned_user_id'

  def due_date_reminders_enabled?
    self.send_due_date_reminder
  end
end
