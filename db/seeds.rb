# Clear existing records to avoid duplication
Ticket.destroy_all
User.destroy_all


# Create Users
users = []
5.times do |i|
  users << User.create!(
    name: "User #{i + 1}",
    email: "user#{i + 1}@example.com",
    send_due_date_reminder: [true, false].sample,
    due_date_reminder_interval: rand(0..30),
    due_date_reminder_time: Time.now.beginning_of_hour + rand(0..23).hours,
    time_zone: "Vienna"
  )
end

current_user = User.create!(
  name: "User 15",
  email: "user115@example.com",
  send_due_date_reminder: true,
  due_date_reminder_interval: 0,
  due_date_reminder_time: Time.now + 10.minutes,
  time_zone: "Vienna" )

puts "Created #{users.count} users."

# Create Tickets for each User
users.each do |user|
  rand(1..5).times do |i|
    Ticket.create!(
      title: "Ticket #{i + 1} for #{user.name}",
      description: "Description for ticket #{i + 1} of user #{user.name}",
      assigned_user_id: user.id,
      due_date: Date.today + rand(0..10),
      status_id: rand(0..3),
      progress: rand(0..100)
    )
  end
end



current_ticket =  Ticket.create!(
  title: "Ticket 15",
  description: "Description for ticket 15 of user #{current_user}",
  assigned_user_id: current_user.id,
  due_date: Date.today,
  status_id: rand(0..3),
  progress: rand(0..100)
)

puts "Created #{Ticket.count} tickets."
