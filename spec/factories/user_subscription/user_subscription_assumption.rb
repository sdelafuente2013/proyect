FactoryBot.define do

  factory :user_subcription_assumption_esp, class: 'Esp::UserSubscriptionAssumption' do
    title { Faker::Lorem.characters(20) }
    summary { Faker::Lorem.characters(40) }
    user_subscription_id { Faker::Number.between(1, 100000) }
    user_subscription_case_id { Faker::Number.between(1, 100000) }
    filters { {} }
  end
  
end
