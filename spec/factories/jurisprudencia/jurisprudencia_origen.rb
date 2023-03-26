FactoryBot.define do
  factory :jurisprudencia_origen_esp, class: 'Esp::JurisprudenciaOrigen' do
    origen { Faker::Lorem.word  }
    orden { 0 }
    padre_id { nil }
  end
end
