FactoryBot.define do
  factory :commercial_contact, class: 'Esp::CommercialContact' do
    nombre { Faker::Name.first_name }
    apellidos { Faker::Name.last_name }
    email { Faker::Internet.email }
    telefono { Faker::PhoneNumber.phone_number }
    codigo_postal {Faker::Address.zip}
    fecha_alta { Faker::Date.backward(14) }
    origen {"Popup Demo"}
    lopd_privacidad { true }
    subsystem
    user
  end

end
