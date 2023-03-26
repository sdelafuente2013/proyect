FactoryBot.define do
  factory :deleted_user, class: 'Esp::DeletedUser' do
    password { Faker::Internet.password(8) }
    sequence(:username) { |n| "#{n}#{Faker::Internet.user_name}" }
    subsystem { create(:subsystem) }
    backoffice_user_id { Faker::Number.between(1, 100000) }
    backoffice_user_name { Faker::Internet.email }
    userid { Faker::Number.between(1, 100000) }
    fechaalta { Faker::Date.backward(30) }
    fechaborrado { Faker::Date.backward(1) }

    after(:create) do |deleted_user|
      deleted_user.update_columns(fechaborrado: Esp::DeletedUser.minimum(:fechaborrado) - 1.hour)
    end
  end
end