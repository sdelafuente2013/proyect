FactoryBot.define do
  factory :jurisprudencia_jurisdiccion_esp, class: 'Esp::JurisprudenciaJurisdiccion' do
    jurisdicdesc { Faker::Lorem.word }
    orden { 0 }
  end
end
