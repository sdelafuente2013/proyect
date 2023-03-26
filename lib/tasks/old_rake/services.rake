namespace :services do
  desc 'creates Gestión Despachos Plus service for Chile'
  task update: :environment do
    print 'Updating services...'

    subid_chile = 7
    modulo_despachos = Latam::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM
    grupo_premium = 63

    unless Latam::Service.find_by(subid: subid_chile, moduloid: modulo_despachos, grupoid: grupo_premium)
      Latam::Service.create!(
        clave: 'gdespachosplus',
        subid: subid_chile,
        moduloid: modulo_despachos,
        grupoid: grupo_premium,
        orden: 110
      )
    end

    puts 'Ok'
    puts "Done!"
  end
end
