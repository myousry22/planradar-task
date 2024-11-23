FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    send_due_date_reminder { [true, false].sample }
    due_date_reminder_interval { rand(1..30) }
    time_zone { 'Vienna' }
    due_date_reminder_time { send_due_date_reminder ? Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) : nil }
  end
end
