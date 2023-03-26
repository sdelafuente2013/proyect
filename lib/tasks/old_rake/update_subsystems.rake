task :update_subsystems => :environment do
  if ENV['RAILS_ENV'].nil?
    puts "Aborted: RAILS_ENV must be set before executing task"
  else
    perform_update(ENV['RAILS_ENV'])
  end
end

def perform_update(env)

  # p "Updating ESP subsystems for #{env}"

  # Esp::Subsystem.update(0, url: "https://www.tirantonline.com", path: 'tol')
  # Esp::Subsystem.update(1, url: "https://notariado.tirant.com", path: 'tnr')
  # Esp::Subsystem.update(2, url: "https://www.tirantasesores.com", path: 'tase')
  # Esp::Subsystem.update(3, url: "https://propiedadhorizontal.tirant.com", path: 'tph')
  # Esp::Subsystem.update(4, url: "https://analytics.tirant.com", path: 'analytics')
  # Esp::Subsystem.update(5, url: "https://icab.tirantonline.com", path: 'icab')
  # Esp::Subsystem.update(6, url: "https://cyl.tirantonline.com", path: 'cyl')


  p "Updating LATAM subsystems for #{env}"
  Latam::Subsystem.update(0, url: 'https://latam.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(1, url: 'https://www.tirantonline.com',path: 'tol')
  Latam::Subsystem.update(2, url: 'https://www.tirantonline.com.mx', path: 'tolmex')
  Latam::Subsystem.update(3, url: 'https://www.tirantonline.com.ar', path: 'latam')
  Latam::Subsystem.update(4, url: 'https://elsalvador.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(5, url: 'https://www.tirantonline.com.co', path: 'latam')
  Latam::Subsystem.update(6, url: 'https://palestra.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(7, url: 'https://www.tirantonline.cl', path: 'latam')
  Latam::Subsystem.update(8, url: 'https://www.tirantonline.com.br', path: 'latam')
  Latam::Subsystem.update(9, url: 'https://panama.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(10, url: 'https://venezuela.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(11, url: 'https://bolivia.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(12, url: 'https://costarica.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(13, url: 'https://ecuador.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(14, url: 'https://guatemala.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(15, url: 'https://honduras.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(16, url: 'https://jamaica.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(17, url: 'https://paraguay.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(18, url: 'https://dominicana.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(19, url: 'https://trinidadtobago.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(20, url: 'https://uruguay.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(21, url: 'https://portugal.tirantonline.com', path: 'latam')
  Latam::Subsystem.update(24, url: 'https://nicaragua.tirantonline.com', path: 'latam')

  p "Updating MEX subsystems for #{env}"
  Mex::Subsystem.update(0, url: 'https://www.tirantonline.com.mx', path: 'tolmex')

  p "Done!"
end
