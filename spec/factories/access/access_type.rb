FactoryBot.define do
  factory :access_type, class: 'Esp::AccessType' do
    descripcion { Faker::Lorem.word }
  end

  factory :access_type_latam, class: 'Latam::AccessType' do
    descripcion { Faker::Lorem.word }
  end

  factory :access_type_mex, class: 'Mex::AccessType' do
    descripcion { Faker::Lorem.word }
  end
end