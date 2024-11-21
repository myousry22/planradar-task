class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :assigned_user_id, null: false
      t.date :due_date
      t.integer :status_id, null: false, default: 0
      t.integer :progress, null: false, default: 0

      t.timestamps
    end

    add_foreign_key :tickets, :users, column: :assigned_user_id
    add_index :tickets, [:assigned_user_id, :due_date]

  end
end
