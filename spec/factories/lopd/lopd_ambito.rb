FactoryBot.define do
    factory :lopd_ambito, class: 'Tirantid::LopdAmbito' do
      nombre { "LopdAmbito#{Random.rand(1..1000000)}" }
      created_at { Time.current }
      updated_at { Time.current }
      lopd_app { create(:lopd_app) }
    end
end
