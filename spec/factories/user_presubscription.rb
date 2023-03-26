FactoryBot.define do
  factory :user_presubscription, class: 'Esp::UserPresubscription' do
    password { Faker::Internet.password(8) }
    perusuid { Faker::Internet.email }
    creation_date { Faker::Date.backward(3) }
    usuarioid { create(:user).id }
  end
end
