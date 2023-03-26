FactoryBot.define do
  factory :product_origen_esp, class: 'Esp::ProductOrigenJurisprudencia' do
    productoid { create(:product).id }
    origenid { create(:jurisprudencia_origen_esp).id }
  end
end
