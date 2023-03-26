FactoryBot.define do
  factory :user_cloudlibrary, class: 'Esp::UserCloudlibrary' do
    user
    modulo
    cloud_user { 'soriano' }
    cloud_password { 'sorianodepus' }
  end
end
