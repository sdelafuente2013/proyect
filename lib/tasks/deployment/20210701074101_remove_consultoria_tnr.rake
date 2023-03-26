namespace :after_party do
  desc 'Deployment task: remove_consultoria_tnr'
  task remove_consultoria_tnr: :environment do
    puts "Running deploy task 'remove_consultoria_tnr'"

    # Put your task implementation HERE.
    service = Esp::Service.search(subid: 1, clave: "consultoria").first
    service.destroy! unless service.nil?

    modulo_subsystem = Esp::ModuloSubsystem.find([1,4])
    modulo_subsystem.destroy! unless modulo_subsystem.nil?

    Esp::User.search(subid: 1, modulo_id: 4).each do |user|
      user.user_modulos.detect{ |us| us.moduloid == 4 }.destroy!
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end