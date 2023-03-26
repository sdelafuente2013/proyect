namespace :services do
  desc "Inserts the new service Biblioteca Actualidad"
  task :insert_biblioteca_actualidad => :environment do
    begin
      t0 = Time.current
      biblioteca_actualidad_modulo = create_modulo()
      create_services(biblioteca_actualidad_modulo)
      modulo_to_premium_users(biblioteca_actualidad_modulo)
    ensure
      t1 = Time.current
      puts "Finished in #{t1 - t0}"
    end
  end

  def create_modulo()
    puts "Creating Modulo"

    biblioteca_actualidad_modulo = Esp::Modulo.find_or_create_by(nombre: 'Biblioteca Actualidad')

    Esp::ModuloSubsystem.find_or_create_by(moduloid: biblioteca_actualidad_modulo.id, subid: 0, orden: 240).save!
    Esp::ModuloSubsystem.find_or_create_by(moduloid:biblioteca_actualidad_modulo.id, subid: 1, orden: 240).save!
    Esp::ModuloSubsystem.find_or_create_by(moduloid:biblioteca_actualidad_modulo.id, subid: 2, orden: 240).save!
    Esp::ModuloSubsystem.find_or_create_by(moduloid:biblioteca_actualidad_modulo.id, subid: 3, orden: 240).save!

    Esp::ModuloPremiumSubsystem.find_or_create_by(moduloid: biblioteca_actualidad_modulo.id, subid: 0).save!
    Esp::ModuloPremiumSubsystem.find_or_create_by(moduloid:biblioteca_actualidad_modulo.id, subid: 1).save!
    Esp::ModuloPremiumSubsystem.find_or_create_by(moduloid:biblioteca_actualidad_modulo.id, subid: 2).save!
    Esp::ModuloPremiumSubsystem.find_or_create_by(moduloid:biblioteca_actualidad_modulo.id, subid: 3).save!

    biblioteca_actualidad_modulo
  end

  def create_services(biblioteca_actualidad_modulo)

    puts "Creating Services"

    Esp::Service.find_or_create_by(clave: 'biblioteca_actualidad',
                                   modulo: biblioteca_actualidad_modulo,
                                   subid: 0,
                                   orden: 240,
                                   grupoid: 13)

    Esp::Service.find_or_create_by(clave: 'biblioteca_actualidad',
                                   modulo: biblioteca_actualidad_modulo,
                                   subid: 1,
                                   orden: 240,
                                   grupoid: 14)

    Esp::Service.find_or_create_by(clave: 'biblioteca_actualidad',
                                   modulo: biblioteca_actualidad_modulo,
                                   subid: 2,
                                   orden: 240,
                                   grupoid: 15)

    Esp::Service.find_or_create_by(clave: 'biblioteca_actualidad',
                                   modulo: biblioteca_actualidad_modulo,
                                   subid: 3,
                                   orden: 240,
                                   grupoid: 16,
                                   athome: 1)
  end

  def modulo_to_premium_users(biblioteca_actualidad_modulo)


    Esp::User.skip_callback(:update, :after, :update_foro)
    Esp::User.skip_callback(:update, :before, :set_has_consultoria_before)
    Esp::User.skip_callback(:save, :before, :fill_permission)
    Esp::User.skip_callback(:save, :before, :fill_modification_dates)
    Esp::User.skip_callback(:save, :after, :update_lopd)
    Esp::User.skip_callback(:save, :after, :update_acceso_tablet)

    Esp::User.transaction do

      [Esp::Subsystem::TIRANTONLINE, Esp::Subsystem::NOTARIOS, Esp::Subsystem::ASESORES, Esp::Subsystem::TPH].each do |subsystem|
        premium_services = Esp::Subsystem.find(subsystem).modulo_premium_subsystems.pluck(:moduloid) - [biblioteca_actualidad_modulo.id]

        premium_users = Esp::User.where('subid = ?', subsystem).joins(:modulos).where("usuario_modulo.moduloid in (#{premium_services.join(',')})").group(:id).having('count(usuario_modulo.usuarioid) = ?',premium_services.size)

        puts "Inserting Modulo in #{subsystem}"
        premium_users.each do |user|
          t0 = Time.current
          user.modulos << biblioteca_actualidad_modulo
          user.save!(validate: false)
          t1 = Time.current
          puts "Usuario actualizado in #{t1 - t0}"
        end
      end

    end
  end

end
