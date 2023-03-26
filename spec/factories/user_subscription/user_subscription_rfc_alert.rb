FactoryBot.define do
  factory :user_subscription_rfc_alert_mex, class: 'Mex::UserSubscriptionRfcAlert' do
    name { Faker::Lorem.characters(40) }
    user_subscription_id { Faker::Number.between(1, 100000) }
    rfc { Faker::Lorem.characters(40) }
  end
end
