FactoryBot.define do
  factory :backoffice_user_tolgeo, class: 'Esp::BackofficeUserTolgeo' do
    backoffice_user
    tolgeo

    factory :backoffice_user_tolgeo_with_associations, class: 'Esp::BackofficeUserTolgeo' do
      after(:create) do |backoffice_user_tolgeo, evaluator|
        create(:backoffice_user_subsystem, backoffice_user_tolgeo: backoffice_user_tolgeo)
      end
    end
  end
end
