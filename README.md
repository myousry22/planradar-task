# README

The system run a cron job every hour in the day at the beginning of each hour and fetch the Users that have 'time_reminder' at within this hour then fetch the each user's tickets that have due_date in same day to send the reminders according to time combination calculated with the user configurations.


Things you may want to cover:

* Ruby version "3.2.2"

* Rails version "7.1.0"

* System dependencies 
  - Docker

* Configurations and setup
  - run 'docker-compose build'
  - run 'docker-compose up'

* Database creation
  - docker-compose exec app rails db:create
  - docker-compose exec app rails db:migrate
  - docker-compose exec app rails db:seed

* How to run the test suite
  - docker-compose exec -e RAILS_ENV=test app bundle exec rspec spec

* Services (job queues, cache servers, search engines, etc.)
  - Sidekiq for handling background tasks
  - redis for Sidekiq queues handling

* Patterns 
    - Strategy pattern to handle the future scaling of the notification service like adding sms notification 



How to run the app and how the app work? 
 1- >> * Configurations and setup
 2- >> * Database creation and seeds
 3- run tests >> * How to run the test suite
 4- Cron job will run every beginning of each hour ex(1 / 2 / 3 / 4 ..etc)
 5- you check the sidekiq dashboard to check the status of SendNotificationWorker job and the mailer job through running http://127.0.0.1:3000/sidekiq/
 6- you can run the worker in rails c to check the logic by running the following 
   -  docker-compose exec app rails c 
   -  SendDueDateReminderWorker.new.perform
   - then check sidekiq dashboard / http://127.0.0.1:3000/sidekiq/scheduled to find the mailer job in the queue.
   - the mailer job work with deliver_in specified time (calculated time by user and ticket settings)

