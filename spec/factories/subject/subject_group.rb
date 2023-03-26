FactoryBot.define do
  factory :subject_group, class: 'Esp::SubjectGroup' do
    descripcion { Faker::Lorem.word }
  end
end
