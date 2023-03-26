# frozen_string_literal: true

namespace :after_party do
  desc "Deployment task: delete_tasas_judiciales"
  task delete_tasas_judiciales: :environment do
    puts "Running deploy task 'delete_tasas_judiciales'"

    Esp::Service.search(clave: "calculadoratasas").each do |service|
      service.destroy! unless service.nil?
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
