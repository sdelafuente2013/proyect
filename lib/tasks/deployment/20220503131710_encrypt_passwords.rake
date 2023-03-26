require 'rake'

namespace :after_party do
  desc 'Deployment task: encrypt_passwords'
  task encrypt_passwords: :environment do
    puts "Running deploy task 'encrypt_passwords'"

    Rake::Task.clear
    Rails.application.load_tasks

    Rake::Task['user_subscriptions:update_password'].execute
    Rake::Task['user_presubscriptions:update_password'].execute

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
