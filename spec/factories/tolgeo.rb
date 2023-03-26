FactoryBot.define do
  factory :tolgeo, aliases: [:tolgeo_default], class: 'Esp::Tolgeo' do
    name { Faker::Number.number(12) } # using random numbers for uniqueness
    description { Faker::Lorem.word }
  end
end
