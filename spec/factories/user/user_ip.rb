FactoryBot.define do
  factory :userIps, class: 'Esp::UserIp' do
    ipfrom { Faker::Internet.ip_v4_address }
    ipto { Faker::Internet.ip_v4_address }
  end

  factory :userIps_latam, class: 'Latam::UserIp' do
    ipfrom { Faker::Internet.ip_v4_address }
    ipto { Faker::Internet.ip_v4_address }
  end

  factory :userIps_mex, class: 'Mex::UserIp' do
    ipfrom { Faker::Internet.ip_v4_address }
    ipto { Faker::Internet.ip_v4_address }
  end
end
