FactoryBot.define do 
  factory :document_type, class: 'Esp::DocumentType' do
    tipoid { SecureRandom.random_number(100000000) }
    nombre { Faker::Lorem.word }
  end
end
