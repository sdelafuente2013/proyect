FactoryBot.define do
  factory :backoffice_user, class: 'Esp::BackofficeUser' do
    tolgeo_default
    email { Faker::Internet.email }
    password_digest { BCrypt::Password.create(Faker::Internet.password(8)) }
    last_login { Date.today }
    created_at { Faker::Date.backward(3) }
    updated_at { Faker::Date.backward(2) }
    active { true }
    admin { false }

    factory :backoffice_user_with_associations, class: 'Esp::BackofficeUser' do
      after(:create) do |backoffice_user, evaluator|
        create(:backoffice_user_tolgeo_with_associations, backoffice_user: backoffice_user)
        create(:backoffice_user_role, backoffice_user: backoffice_user)
      end
    end
  end

end

