namespace :services do
  desc "Inserts the new servie Baremo in Chile App"
  task :insert_baremo => :environment do
    Latam::Service.new(clave: 'baremo',
                       subid: 7,
                       orden: 110,
                       grupoid: 61).save!
  end

end
