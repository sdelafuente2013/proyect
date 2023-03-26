# frozen_string_literal: true

namespace :after_party do
  desc 'Deployment task: rename_contadores_subsystem_name'
  task rename_contadores_subsystem_name: :environment do
    puts "Running deploy task 'rename_contadores_subsystem_name'"

    conmex = Mex::Subsystem.find_by(id: 1)
    conmex.update(name: 'Tirant Contadores')

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
