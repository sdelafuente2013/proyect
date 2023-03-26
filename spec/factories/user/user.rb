FactoryBot.define do
  factory :user, class: 'Esp::User', aliases: %i(user_esp) do
    sequence(:username) { |n| "#{n}#{Faker::Internet.user_name}" }
    password { Faker::Internet.password(8) }
    email { Faker::Internet.email }
    maxconexiones { Faker::Number.between(1, 10) }
    access_type { create(:access_type) }
    user_type_group { create(:user_type_group) }
    subsystem { create(:subsystem) }
    access_type_tablet { create(:access_type_tablet) }
    comercial { Faker::Boolean.boolean }
    grupo { Faker::Boolean.boolean }
    privacidad { Faker::Boolean.boolean }

    factory :user_accepts_privacidad do
      privacidad {true}
    end

    factory :user_not_accepts_privacidad do
      privacidad {false}
    end

    factory :user_accepts_comercial do
      comercial {true}
    end

    factory :user_not_accepts_comercial do
      comercial {false}
    end

    factory :user_accepts_grupo do
      grupo {true}
    end

    factory :user_not_accepts_grupo do
      grupo {false}
    end

    after(:create) do |user|
     create(:userIps, :user => user)
    end

    trait :with_subscriptions do
      user_subscriptions { create_list(:user_subscription, 5) }
    end

    trait :with_presubscriptions do
      user_presubscriptions { create_list(:user_presubscription, 5) }
    end

  end

  factory :user_latam, class: 'Latam::User' do
    sequence(:username) { |n| "#{n}#{Faker::Internet.user_name}" }
    password { Faker::Internet.password(8) }
    email { Faker::Internet.email }
    maxconexiones { Faker::Number.between(1, 10) }
    access_type { create(:access_type_latam) }
    user_type_group { create(:user_type_group_latam) }
    subsystem { create(:subsystem_latam) }
    comercial { Faker::Boolean.boolean }
    grupo { Faker::Boolean.boolean }
    privacidad { Faker::Boolean.boolean }

    before :create do |user|
      user.access_type_tablet =
        Latam::AccessTypeTablet.find_by(id: 3) || create(:access_type_tablet_latam, id: 3)
    end

    after(:create) do |user|
      create(:userIps_latam, :user => user)
    end

    trait :with_subscriptions do
      user_subscriptions { create_list(:user_subscription_latam, 5) }
    end

    trait :with_presubscriptions do
      user_presubscriptions { create_list(:user_presubscription_latam, 5) }
    end
  end

  factory :user_mex, class: 'Mex::User' do
    sequence(:username) { |n| "#{n}#{Faker::Internet.user_name}" }
    password { Faker::Internet.password(8) }
    email { Faker::Internet.email }
    maxconexiones { Faker::Number.number(1) }
    access_type { create(:access_type_mex) }
    user_type_group { create(:user_type_group_mex) }
    subsystem { create(:subsystem_mex) }
    access_type_tablet { create(:access_type_tablet_mex) }
    comercial { Faker::Boolean.boolean }
    grupo { Faker::Boolean.boolean }
    privacidad { Faker::Boolean.boolean }

    after(:create) do |user|
     create(:userIps_mex, :user => user)
    end

    trait :with_subscriptions do
      user_subscriptions { create_list(:user_subscription_mex, 5) }
    end

    trait :with_presubscriptions do
      user_presubscriptions { create_list(:user_presubscription_mex, 5) }
    end
  end
end