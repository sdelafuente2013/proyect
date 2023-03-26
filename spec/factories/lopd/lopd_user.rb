# frozen_string_literal: true

FactoryBot.define do
  factory :lopd_user, class: "Tirantid::LopdUser" do
    usuario { "Usuario#{Random.rand(1..1_000_000)}" }
    comercial { true }
    grupo { true }
    privacidad { true }
    fecha_aceptacion { Time.current }
    email { "correo@tiranrt.mail" }
    nombre { "tirant" }
    apellidos { "loblanch" }
    direccion { "artes graficas 16, valencia" }
    telefono { "666777881" }
    telefono2 { "666777882" }
    fax { "666777883" }
    notas { "notas" }
    importacion { false }
    created_at { Time.current }
    updated_at { Time.current }
    lopd_ambito { create(:lopd_ambito) }
  end
end
