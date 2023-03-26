FactoryBot.define do
  factory :grupo_servicio_latam, class: 'Latam::GrupoServicio' do
    id { 63 }
    name { 'premium' }
    subid { 7 }
    order { 10 }
  end
end
