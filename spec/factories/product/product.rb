FactoryBot.define do
  factory :product, class: 'Esp::Product' do
    descripcion { Faker::Lorem.word }
  end
end

