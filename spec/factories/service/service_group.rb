FactoryBot.define do
  factory :service_group_latam, class: 'Latam::ServiceGroup' do
    name { Faker::Lorem.word }
    order { 100 }
  end
end
