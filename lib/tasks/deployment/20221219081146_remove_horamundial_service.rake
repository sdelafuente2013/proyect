# frozen_string_literal: true

namespace :after_party do
  desc 'Deployment task: remove_horamundial_service'
  task remove_horamundial_service: :environment do
    puts "Running deploy task 'remove_horamundial_service'"
    Latam::Service.by_clave('horamundial').each do |service|
      service.destroy!
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
