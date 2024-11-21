class User < ApplicationRecord
  has_many :tickets, foreign_key: 'assigned_user_id'

  def due_date_reminders_enabled?
    self.send_due_date_reminder
  end
end
