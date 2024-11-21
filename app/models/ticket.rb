class Ticket < ApplicationRecord


  # Model Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :assigned_user_id, presence: true
  validates :due_date, presence: true
  validates :status_id, presence: true
  validates :progress, presence: true
  validates :title, uniqueness: { scope: :assigned_user_id, message: "  there is another ticket with same title assigned to this user" }
  validate :due_date_validity

  
  # Model Associations
  belongs_to :user, foreign_key: 'assigned_user_id'





  def reminder_time_for_user(user)
    return unless due_date && user.due_date_reminders_enabled?

    reminder_time = due_date - user.due_date_reminder_interval.days
    reminder_time.in_time_zone(user.time_zone).change(
      hour: user.due_date_reminder_time.hour,
      min: user.due_date_reminder_time.min
    )
  end

  private
  def due_date_validity
    if due_date < Date.today
      errors.add(:due_date, "can't be in the past")
    end
  end

end
