FactoryBot.define do
  factory :role, class: 'Esp::Role' do
    description { Faker::Number.number(12) } # using random numbers for uniqueness
  end
end
