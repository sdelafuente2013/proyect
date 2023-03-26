FactoryBot.define do
  factory :user_subscription_with_fake_password, class: "Esp::UserSubscription" do
    id { SecureRandom.random_number(100000000) }
    password { Esp::User::FAKE_SECRET }
    perusuid { Faker::Internet.email }
  end
  %w[esp latam mex].each do |tolgeo|
    factory_name =
      if tolgeo == "esp"
        :user_subscription
      else
        "user_subscription_#{tolgeo}".to_sym
      end

    factory factory_name, class: "#{tolgeo.capitalize}::UserSubscription" do
      perusuid { Faker::Internet.email }
      password_salt { "mitesorosecreto" }
      password { 'mypassword' }

      association :user, factory: "user_#{tolgeo}".to_sym

      before :create do |user_subscription|
        if user_subscription.user &&
             (user_subscription.subid.blank? || user_subscription.subid.zero?)
          user_subscription.subsystem = user_subscription.user.subsystem
        end
      end
    end
  end
end
