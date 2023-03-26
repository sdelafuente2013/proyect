FactoryBot.define do
  factory :user_subscription_calendar_mex, class: 'Mex::UserSubscriptionCalendar' do
    name { Faker::Lorem.characters(40) }
    user_subscription_id { Faker::Number.between(1, 100000) }
    type { "data" }
    url { Faker::Lorem.characters(40) }
    events { [] }
    color { "#3788d8" }
  end
end
