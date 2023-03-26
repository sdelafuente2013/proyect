FactoryBot.define do
  factory :servicio_latam_biblioteca, class: 'Latam::Service' do
    clave { 'bibliotecavirtual' }
    subid { 7 }
    orden { 10 }
    hide { 0 }
    grupoid {63}
  end
  
  factory :servicio_latam_gestion, class: 'Latam::Service' do
    clave { Faker::Lorem.word }
    orden { 100 }
    athome { false }
    hide { false }
  end
  
end


