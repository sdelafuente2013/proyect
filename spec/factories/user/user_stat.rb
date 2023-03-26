FactoryBot.define do
  factory :user_stat, class: 'Esp::UserStat' do
    user
    fecha { Faker::Date.backward(30) }
    sesiones { Faker::Number.number(2) }
    documentos { Faker::Number.number(2) }
  end
end
