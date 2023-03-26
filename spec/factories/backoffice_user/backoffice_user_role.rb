FactoryBot.define do
  factory :backoffice_user_role, class: 'Esp::BackofficeUserRole' do
    backoffice_user
    role
  end
end
