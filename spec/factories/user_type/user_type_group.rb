FactoryBot.define do
  factory :user_type_group, class: 'Esp::UserTypeGroup' do
    descripcion { Faker::Lorem.word }
    id { SecureRandom.random_number(100000000) }
  end

  factory :user_type_group_mex, class: 'Mex::UserTypeGroup' do
    descripcion { Faker::Lorem.word }
    id { SecureRandom.random_number(100000000) }
  end

  factory :user_type_group_latam, class: 'Latam::UserTypeGroup' do
    descripcion { Faker::Lorem.word }
    id { SecureRandom.random_number(100000000) }
  end
end
