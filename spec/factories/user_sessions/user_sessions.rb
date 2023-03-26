FactoryBot.define do

  factory :user_session_esp, class: 'Esp::UserSession' do
    userId { Faker::Number.between(1, 100000) }
    maxInactiveInterval { 30 }
    invalidated { Faker::Boolean.boolean }
    ultimoAcceso { (Time.now.to_f * 1000.0).to_i }
  end

end
