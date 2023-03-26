FactoryBot.define do
  factory :subject, class: 'Esp::Subject' do
    id { SecureRandom.random_number(100000000) }
    nombre { Faker::Lorem.word }
    tema { Faker::Lorem.word }
    permisos_decimal { Faker::Number.number(2) }
    permisos_binario { Faker::Number.number(2) }
  end
end
