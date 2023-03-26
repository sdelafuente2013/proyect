namespace :seeder do

  # Validates RAILS_ENV has been set
  task :check_env => :environment do
    print "Checking environment is set: "
    if ENV['RAILS_ENV'].nil?
      raise "Aborted: RAILS_ENV must be set before executing task"
    end
    print "OK\n"
  end


  desc 'Creates standard tolgeo records in the database'
  task :tolgeos => [:environment, :check_env] do
    print "Creating tolgeos: "
    data = [
      { id: 1, name: 'esp', description: 'España' },
      { id: 2, name: 'latam', description: 'Latinoamérica' },
      { id: 3, name: 'mex', description: 'México' },
    ]
    data.each do |attrs|
      Esp::Tolgeo.create!(attrs)
      print "."
    end
    print "OK\n"
  end


  desc 'Adds missing BackofficeUserTolgeos to all BackofficeUsers'
  task :backoffice_user_tolgeos => [:environment, :check_env] do
    print "Adding missing BackofficeUserTolgeos:\n"
    tolgeo_ids = Esp::Tolgeo.pluck(:id)
    user_ids = Esp::BackofficeUser.pluck(:id)
    user_ids.each do |user_id|
      print "  Checking user #{user_id}\n"
      user_tolgeos = Esp::BackofficeUserTolgeo.where('backoffice_user_id = ?', user_id).pluck(:tolgeo_id)
      missing_tolgeos = tolgeo_ids - user_tolgeos
      missing_tolgeos.each do |missing_tolgeo|
        Esp::BackofficeUserTolgeo.create!({ backoffice_user_id: user_id, tolgeo_id: missing_tolgeo })
        print "  - Added missing tolgeo: #{missing_tolgeo}\n"
      end
      print "  - Done\n"
    end
    print "OK\n"
  end

  desc 'Sets password for all backoffice users'
  task :backoffice_user_passwords, [ :new_password ] => [:environment, :check_env] do |task, args|
    print "Generating password digests for Backoficce Users..."
    raise "Failed: password_digest column not found" unless Esp::BackofficeUser.column_names.include?('password_digest')
    new_password = args[:new_password]
    raise "Missing parameter :new_password" if new_password.blank?
    Esp::BackofficeUser.update_all password_digest: Esp::BackofficeUser.new({password: new_password}).password_digest
    print "OK\n"
  end


  desc 'Creates standard role records in the database'
  task :roles => [:environment, :check_env] do
    print "Creating roles: "
    data = [
      { id: 1, description: 'Gestión de grupos' },
      { id: 2, description: 'Gestión de cuentas de personalización' },
      { id: 3, description: 'Gestión de errores de acceso' },
      { id: 4, description: 'Gestión de nube de lectura' },
      { id: 5, description: 'Gestión de despachos' },
      { id: 6, description: 'Gestión de estadísticas de usuarios' },
      { id: 7, description: 'Gestión de usuarios' },
      { id: 8, description: 'Gestión de contactos comerciales' },
      { id: 107, description: 'Visualización de usuarios' },
      { id: 108, description: 'Visualización de contactos comerciales' },
    ]
    data.each do |attrs|
      Esp::Role.find_or_create_by!(id:attrs[:id]) { |role|
        role.attributes = attrs
      }
      print "."
    end
    print "OK\n"
    puts Esp::Role.all.map{|r| "#{r.id}:#{r.description}" }.join("\n")
  end

end
