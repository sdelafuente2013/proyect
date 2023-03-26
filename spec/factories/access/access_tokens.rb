FactoryBot.define do
  factory :access_token, class: 'Esp::AccessToken' do
    user_id { Faker::Number.number }
    email { Faker::Internet.email }
    app_from { "tol" }
    app_to {"cloud"}
  end
end
