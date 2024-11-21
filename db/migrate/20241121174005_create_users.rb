class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :send_due_date_reminder, default: false, null: false
      t.integer :due_date_reminder_interval, limit: 1, default: 0, null: false
      t.time :due_date_reminder_time, null: true
      t.string :time_zone, default: "Europe/Vienna", null: false

      t.timestamps
    end

    add_index :users, [:send_due_date_reminder, :due_date_reminder_time]
  end
end
