# frozen_string_literal: true

namespace :after_party do
  desc "Deployment task: new_subsystem_contaduria"
  task new_subsystem_contaduria: :environment do
    puts "Running deploy task 'new_subsystem_contaduria'"

    Mex::Subsystem
      .find_or_create_by(id: 1, name: "Contadores", url: "https://contadores.tirant.com",
                         path: "tolmex", has_despachos: false, show_demo: false,
                         show_alta_personalizacion: false).save!

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
