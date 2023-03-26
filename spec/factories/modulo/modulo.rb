FactoryBot.define do
  factory :modulo, class: 'Esp::Modulo' do
    nombre { Faker::Lorem.word }
    seccionweb { Faker::Number.number(2) }
  end

  factory :modulo_mex, class: 'Mex::Modulo' do
    nombre { Faker::Lorem.word }
    seccionweb { Faker::Number.number(2) }
  end

  factory :modulo_latam, class: 'Latam::Modulo' do
    nombre { Faker::Lorem.word }
    seccionweb { Faker::Number.number(2) }
  end
end
