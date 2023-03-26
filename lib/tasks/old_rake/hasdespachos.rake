namespace :hasdespachos do
  desc "Updates has_despachos in Subsystems for Spain, Latam and Mexico"
  task update: :environment do
    print 'Updating Spain subids...'
    Esp::Subsystem.where(has_despachos: false).update_all(has_despachos: true)
    puts 'Ok'
    print 'Updating Mexico subids...'
    Mex::Subsystem.where(has_despachos: false).update_all(has_despachos: true)
    puts 'Ok'
    print 'Updating Latam subsystems...'
    Latam::Subsystem.where(name: 'Colombia').where(has_despachos: false).update_all(has_despachos: true)
    Latam::Subsystem.where(name: 'Chile').where(has_despachos: false).update_all(has_despachos: true)
    puts 'Ok'
    puts "Done!"
  end
end
