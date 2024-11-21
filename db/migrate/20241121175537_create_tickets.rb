class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :assigned_user_id, null: false
      t.date :due_date, null: false
      t.integer :status_id, null: false, default: 0
      t.integer :progress, null: false, default: 0

      t.timestamps
    end

    add_foreign_key :tickets, :users, column: :assigned_user_id
    add_index :tickets, [:assigned_user_id, :title], unique: true, name: 'index_tickets_on_assigned_user_id_and_title'

  end
end
