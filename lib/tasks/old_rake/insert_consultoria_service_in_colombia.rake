namespace :services do
  desc "Inserts the new servicee Consultoria in Colombia App"
  task :insert_consultoria_colombia => :environment do
    Latam::Service.new(clave: 'consultoria',
                       subid: 5,
                       orden: 5,
                       grupoid: 47).save!
  end

end
