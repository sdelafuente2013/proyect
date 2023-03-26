namespace :after_party do
  desc 'Deployment task: insert_sofia_service'
  task insert_sofia_service:  :environment do
    puts "Running deploy task 'insert_sofia_service'"
    create_modulo_esp()
    create_modulo_mex()

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end

  def create_modulo_esp()
    puts "Creating Modulo Sofia"

    sofia_modulo = Esp::Modulo.find_or_create_by(nombre: 'Sofia')
    
    Esp::ModuloSubsystem.find_or_create_by(moduloid: sofia_modulo.id, subid: 0, orden: 240).save!
    Esp::ModuloSubsystem.find_or_create_by(moduloid: sofia_modulo.id, subid: 1, orden: 240).save!
    Esp::ModuloSubsystem.find_or_create_by(moduloid: sofia_modulo.id, subid: 2, orden: 240).save!
    Esp::ModuloSubsystem.find_or_create_by(moduloid: sofia_modulo.id, subid: 3, orden: 240).save!
    Esp::ModuloSubsystem.find_or_create_by(moduloid: sofia_modulo.id, subid: 4, orden: 240).save!

  end

  def create_modulo_mex()
    puts "Creating Modulo Sofia Mex"

    sofia_modulo_mex = Mex::Modulo.find_or_create_by(nombre: 'Sofia')

    Mex::ModuloSubsystem.find_or_create_by(moduloid: sofia_modulo_mex.id, subid: 0, orden: 240).save!

  end

end