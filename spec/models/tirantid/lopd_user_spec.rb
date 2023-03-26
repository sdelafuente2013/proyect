require 'rails_helper'

describe 'LOPD User' do
  it 'can be created' do
    app =  Tirantid::LopdApp.new(nombre: 'AnyName')
    app.save
    ambit = Tirantid::LopdAmbito.new(id: 1100110, nombre: 'AnyName', lopd_app_id: app.id)
    ambit
    user = Tirantid::LopdUser.new(lopd_ambito: ambit, usuario: 'someuser')

    result = user.save

    expect(user.errors.size).to be_zero
    expect(result).to be_truthy
  end
end
