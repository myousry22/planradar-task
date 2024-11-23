FactoryBot.define do
  factory :ticket do
    title { 'Test Ticket' }
    description { 'This is a test ticket.' }
    status_id { 1 }
    progress { 0 }
    due_date { Date.tomorrow }
  end
end
