namespace :modulo_premium_subsystems do
  desc 'creates modulo_premium_subsystems for Chile'
  task update: :environment do
    print 'Updating modulo_premium_subsystems...'

    subid_chile = 7
    modulo_despachos = Latam::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM

    Latam::ModuloPremiumSubsystem.find_or_create_by!(
      subid: subid_chile,
      moduloid: modulo_despachos
    )

    puts 'Ok'
    puts "Done!"
  end
end
