FactoryBot.define do
  factory :product_jurisdiccion_esp, class: 'Esp::ProductJurisdiccionJurisprudencia' do
    productoid { create(:product).id }
    jurisdiccionid { create(:jurisprudencia_jurisdiccion_esp).id }
  end
end
