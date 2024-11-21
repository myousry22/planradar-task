# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_11_21_175537) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tickets", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.integer "assigned_user_id", null: false
    t.date "due_date", null: false
    t.integer "status_id", default: 0, null: false
    t.integer "progress", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_user_id", "title"], name: "index_tickets_on_assigned_user_id_and_title", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "send_due_date_reminder", default: false, null: false
    t.integer "due_date_reminder_interval", limit: 2, default: 0, null: false
    t.time "due_date_reminder_time"
    t.string "time_zone", default: "Europe/Vienna", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "tickets", "users", column: "assigned_user_id"
end
