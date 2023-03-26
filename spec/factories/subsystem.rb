  FactoryBot.define do
  factory :subsystem, class: 'Esp::Subsystem' do
    name { Faker::Lorem.word }
    id { SecureRandom.random_number(100000000) }
  end

  factory :subsystem_latam, class: 'Latam::Subsystem' do
    name { Faker::Lorem.word }
    id { SecureRandom.random_number(100000000) }
  end

  factory :subsystem_mex, class: 'Mex::Subsystem' do
    name { Faker::Lorem.word }
    id { SecureRandom.random_number(100000000) }
  end
end
