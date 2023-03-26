FactoryBot.define do
  factory :gm_usuario, class: 'Esp::GmUsuario' do
    usuarioid { create(:user).id}
    gmid { Faker::Number.between(1, 100) }
  end
end
