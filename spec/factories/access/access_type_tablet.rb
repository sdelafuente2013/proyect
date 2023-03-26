FactoryBot.define do
  factory :access_type_tablet, class: 'Esp::AccessTypeTablet' do
    descripcion { Faker::Lorem.word }
  end

  factory :access_type_tablet_latam, class: 'Latam::AccessTypeTablet' do
    id { (Latam::AccessTypeTablet.first.try(:id) || 0)+1 }
    descripcion { Faker::Lorem.word }
  end

  factory :access_type_tablet_mex, class: 'Mex::AccessTypeTablet' do
    id { (Mex::AccessTypeTablet.first.try(:id) || 0)+1 }
    descripcion { Faker::Lorem.word }
  end
end