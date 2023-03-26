FactoryBot.define do
  factory :ambit, class: 'Esp::Ambit' do
    nombre { Faker::Lorem.word }
    orden { Faker::Number.number(2) }
  end
end