FactoryBot.define do
  factory :access_error, class: 'Esp::AccessError' do
    username { Faker::Lorem.word }
    tipo_error_acceso_id { Faker::Number.number(1) }
    tipo_peticion { Faker::Lorem.word }
  end
end
