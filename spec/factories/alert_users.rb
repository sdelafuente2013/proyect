FactoryBot.define do
  factory :alert_user, class: 'Esp::AlertUser' do
    app_id { 'tol' }
    email { Faker::Internet.email }

  end

  factory :alert_user_mex, class: 'Mex::AlertUser' do
    app_id { 'tolmex' }
    email { Faker::Internet.email }

  end

  factory :alert_user_latam, class: 'Latam::AlertUser' do
    app_id { 'latam' }
    email { Faker::Internet.email }

  end
end
