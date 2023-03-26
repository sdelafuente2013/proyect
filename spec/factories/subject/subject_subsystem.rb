FactoryBot.define do
  factory :subject_subsystem, class: 'Esp::SubjectSubsystem' do
    subject
    subsystem
  end
end
