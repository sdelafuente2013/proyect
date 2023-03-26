namespace :services do
  desc "Inserts the new service Diccionario Juridico"
  task :insert_diccionario => :environment do

    currencies_tol = Esp::Service.find_by(clave: 'currencies', subid: 0, orden: 150, athome: 0, hide: 0, grupoid: 1)
    currencies_tol.update(orden: 40, grupoid: 5)

    currencies_tase = Esp::Service.find_by(clave: 'currencies', subid: 2, orden: 150, athome: 0, hide: 0, grupoid: 3)
    currencies_tase.update(orden: 35, grupoid: 7)

    currencies_notarios = Esp::Service.find_by(clave: 'currencies', subid: 1, orden: 150, athome: 0, hide: 0, grupoid: 2)
    currencies_notarios.update(orden: 35, grupoid: 6)

    Esp::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 0, orden: 145, athome: 0, hide: 0, grupoid: 1).save!
    Esp::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 1, orden: 150, athome: 0, hide: 0, grupoid: 2).save!
    Esp::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 2, orden: 150, athome: 0, hide: 0, grupoid: 3).save!
    Esp::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 3, orden: 50, athome: 1, hide: 0, grupoid: 4).save!

    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 0, orden: 225, athome: 0, hide: 0, grupoid: 3).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 3, orden: 225, athome: 0, hide: 0, grupoid: 27).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 4, orden: 225, athome: 0, hide: 0, grupoid: 35).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 5, orden: 225, athome: 0, hide: 0, grupoid: 43).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 6, orden: 225, athome: 0, hide: 0, grupoid: 51).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 7, orden: 225, athome: 0, hide: 0, grupoid: 59).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 9, orden: 225, athome: 0, hide: 0, grupoid: 75).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 10, orden: 225, athome: 0, hide: 0, grupoid: 83).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 11, orden: 225, athome: 0, hide: 0, grupoid: 91).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 12, orden: 225, athome: 0, hide: 0, grupoid: 99).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 13, orden: 225, athome: 0, hide: 0, grupoid: 107).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 14, orden: 225, athome: 0, hide: 0, grupoid: 115).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 15, orden: 225, athome: 0, hide: 0, grupoid: 123).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 17, orden: 225, athome: 0, hide: 0, grupoid: 139).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 18, orden: 225, athome: 0, hide: 0, grupoid: 147).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 20, orden: 225, athome: 0, hide: 0, grupoid: 163).save!
    Latam::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 24, orden: 225, athome: 0, hide: 0, grupoid: 179).save!

    Mex::Service.find_or_create_by(clave: 'diccionariojuridico', subid: 0, orden: 250, athome: 0, hide: 0, grupoid: 5).save!
  end

end
