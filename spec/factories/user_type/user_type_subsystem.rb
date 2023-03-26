FactoryBot.define do
  factory :user_type_subsystem, class: 'Esp::UserTypeSubsystem' do
    user_type_group
    subsystem
  end
end
