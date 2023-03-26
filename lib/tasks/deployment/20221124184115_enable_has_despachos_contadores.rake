namespace :after_party do
  desc 'Deployment task: enable_has_despachos_contadores'
  task enable_has_despachos_contadores: :environment do
    puts "Running deploy task 'enable_has_despachos_contadores'"

    Mex::Subsystem.where(id: 1).update(has_despachos: 1)

    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end