# frozen_string_literal: true

FactoryBot.define do
  factory :user_directory_esp, class: 'Esp::UserDirectory' do
    childcount { 0 }
    description { Faker::Lorem.word }
    parentdirectoryid { nil }
    type { 0 }
    user_subscription
  end
end
