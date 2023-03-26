FactoryBot.define do
  factory :backoffice_user_subsystem, class: 'Esp::BackofficeUserSubsystem' do
    backoffice_user_tolgeo
    subsystem_id { Faker::Number.between(1, 10000) }
  end
end
