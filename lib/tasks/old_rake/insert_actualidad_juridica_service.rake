namespace :services do
  desc "Inserts the new service Actualidad Juridica"
  task :insert_actualidad => :environment do
    
    Esp::Service.find_or_create_by(clave: 'actualidadjuridica', subid: 0, orden: 3, athome: 0, hide: 0, grupoid: 5).save!
    Esp::Service.find_or_create_by(clave: 'actualidadjuridica', subid: 1, orden: 3, athome: 0, hide: 0, grupoid: 6).save!
    Esp::Service.find_or_create_by(clave: 'actualidadjuridica', subid: 2, orden: 3, athome: 0, hide: 0, grupoid: 7).save!
    Esp::Service.find_or_create_by(clave: 'actualidadjuridica', subid: 3, orden: 40, athome: 1, hide: 0, grupoid: 4).save!

    Latam::Service.find_or_create_by(clave: 'actualidadjuridica', subid: 5, orden: 75, athome: 0, hide: 0, grupoid: 41).save!
    Latam::Service.find_or_create_by(clave: 'actualidadjuridica', subid: 7, orden: 75, athome: 0, hide: 0, grupoid: 57).save!

    Mex::Service.find_or_create_by(clave: 'actualidadjuridica', subid: 0, orden: 40, athome: 0, hide: 0, grupoid: 3).save!
  end

end
