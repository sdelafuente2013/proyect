FactoryBot.define do
  factory :pais_es, class: 'Esp::Pais' do
    sequence(:codigo) { |n| n }
    codigo_iso { 'esp' }
    nombre { 'España' }
    codigo_iso_2digits { 'es' }
    association :subsystem, factory: :subsystem
  end

  factory :pais_latam, class: 'Latam::Pais', parent: :pais_es do
    codigo_iso { 'col' }
    nombre { 'Colombia' }
    codigo_iso_2digits { 'co' }
    association :subsystem, factory: :subsystem_latam
  end
end
