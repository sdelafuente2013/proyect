namespace :modulos do
  desc 'Updates modulos subsystems for Latam'
  task update: :environment do
    print 'Updating modulos subsystems for Latam...'

    modulo_despachos = Latam::Modulo.find_by(id: Latam::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM)
    unless modulo_despachos
      puts 'ERROR: Gestión Despachos module not found for Latam'
      return
    end
    colombia_subsystem = Latam::Subsystem.find_by(name: 'Colombia')
    unless colombia_subsystem
      puts 'ERROR: Colombia subsystem not found for Latam'
      return
    end
    chile_subsystem = Latam::Subsystem.find_by(name: 'Chile')
    unless chile_subsystem
      puts 'ERROR: Chile subsystem not found for Latam'
      return
    end

    unless Latam::ModuloSubsystem.find_by(modulo: modulo_despachos, subsystem: colombia_subsystem)
      Latam::ModuloSubsystem.create!(modulo: modulo_despachos, subsystem: colombia_subsystem, orden: 90)
    end
    unless Latam::ModuloSubsystem.find_by(modulo: modulo_despachos, subsystem: chile_subsystem)
      Latam::ModuloSubsystem.create!(modulo: modulo_despachos, subsystem: chile_subsystem, orden: 90)
    end

    puts 'Ok'
    puts "Done!"
  end
end
