FactoryBot.define do
  factory :document_alert, class: 'Esp::DocumentAlert' do

    app_id { 'tol' }
    document_id { Faker::Number.number }
    document_tolgeo { 'esp' }
    alert_date { Faker::Date.backward(14) }
    association :alertable, factory: :alert_user
    alertable_type {'Esp::AlertUser'}

    factory :boc_document_alert do
      app_id { 'boc' }
    end

    factory :user_subscription_alert do
      association :alertable, factory: :user_subscription
      alertable_type {'Esp::UserSubscription'}
    end

  end

  factory :document_alert_mex, class: 'Mex::DocumentAlert' do

    app_id { 'tolmex' }
    document_id { Faker::Number.number }
    document_tolgeo { 'mex' }
    alert_date { Faker::Date.backward(14) }
    association :alertable, factory: :alert_user_mex
    alertable_type {'Mex::AlertUser'}

    factory :user_subscription_alert_mex do
      association :alertable, factory: :user_subscription_mex
      alertable_type {'Mex::UserSubscription'}
    end

  end

  factory :document_alert_latam, class: 'Latam::DocumentAlert' do

    app_id { 'latam' }
    document_id { Faker::Number.number }
    document_tolgeo { 'latam' }
    alert_date { Faker::Date.backward(14) }
    association :alertable, factory: :alert_user_latam
    alertable_type {'Latam::AlertUser'}

    factory :user_subscription_alert_latam do
      association :alertable, factory: :user_subscription_latam
      alertable_type {'Latam::UserSubscription'}
    end

  end
end
