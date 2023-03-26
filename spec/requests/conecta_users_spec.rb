require 'rails_helper'

describe 'Conecta User' do
  before(:each) do
    stub_requests
  end

  context 'POST /:tolgeo/conecta_users' do
    before(:each) do
      create_requirements
    end

    it 'creates a new conecta user' do
      params = {
        email: 'conecta@user.com',
        password: '12345678',
        datelimit: datelimit_in_milliseconds.to_s,
        nombre: 'Conecta',
        apellidos: 'User',
        direccion: 'Some direction',
        telefono: '987654321',
        nif: '12345678a'
      }

      post '/esp/conecta_users', params: params

      created_user = json['object']
      expect(created_user['tipousuariogrupoid']).to eq(24)
      expect_conecta_user_is_equal_to(created_user)

      user = Objects.tolgeo_model_class('esp', 'user').find(created_user['id'])
      expect(user.lopd_ambito.nombre).to eq('conecta')

    end

    it 'creates a new conecta user with lopd params' do

      lopd_params = { privacidad: true, comercial: false, grupo:true }

      params = {
        email: 'conecta@user.com',
        password: '12345678',
        datelimit: datelimit_in_milliseconds.to_s,
        nombre: 'Conecta',
        apellidos: 'User',
        direccion: 'Some direction',
        telefono: '987654321',
        nif: '12345678a',
        privacidad: lopd_params['privacidad'],
        grupo: lopd_params['grupo'],
        comercial: lopd_params['comercial']
      }

      post '/esp/conecta_users', params: params

      created_user = json['object']
      expect_conecta_user_is_equal_to(created_user)
      expect(created_user['foroid']).not_to be_nil
      expect_conecta_user_lopd_params_are(created_user, lopd_params)
    end

    it 'when creates a new user, creates a subscription too' do
      email = 'conecta@user.com'
      params = {
        email: email,
        password: '12345678',
        datelimit: datelimit_in_milliseconds.to_s,
        nombre: 'Conecta',
        apellidos: 'User',
        direccion: 'Some direction',
        telefono: '987654321',
        nif: '12345678a'
      }

      post '/esp/conecta_users', params: params

      subscription = Objects.tolgeo_model_class('esp', 'user_subscription').find_by_perusuid(email)
      expect(subscription.perusuid).to eq(email)
    end

    it 'when creates a new user with lopd params, creates a subscription too with those flags' do
      email = 'conecta@user.com'
      lopd_params = { privacidad: true, comercial: false, grupo:true }
      params = {
        email: email,
        password: '12345678',
        datelimit: datelimit_in_milliseconds.to_s,
        nombre: 'Conecta',
        apellidos: 'User',
        direccion: 'Some direction',
        telefono: '987654321',
        nif: '12345678a',
        privacidad: lopd_params['privacidad'],
        grupo: lopd_params['grupo'],
        comercial: lopd_params['comercial']
      }

      post '/esp/conecta_users', params: params

      subscription = Objects.tolgeo_model_class('esp', 'user_subscription').find_by_perusuid(email)
      expect(subscription.perusuid).to eq(email)
      expect_conecta_user_lopd_params_are(subscription, lopd_params)
    end


    it 'when creates a new user what exists' do
      email = 'conecta@user.com'
      params = {
        email: email,
        password: '12345678',
        datelimit: datelimit_in_milliseconds.to_s,
        nombre: 'Conecta',
        apellidos: 'User',
        direccion: 'Some direction',
        telefono: '987654321',
        nif: '12345678a'
      }

      post '/esp/conecta_users', params: params
      created_user = json['object']
      subscription = Objects.tolgeo_model_class('esp', 'user_subscription').find_by_perusuid(email)
      expect(subscription.perusuid).to eq(email)

      post '/esp/conecta_users', params: params
      created_user_2 = json['object']

      expect(created_user.reject{|it| it["fecharevision"]}).to eq(created_user_2.reject{|it| it["fecharevision"]})

    end

    it 'adds datelimit to an existing user' do
      user = create(:user)
      params = {
        email: user.email,
        password: user.password,
        datelimit: datelimit_in_milliseconds.to_s,
        nombre: user.nombre,
        apellidos: user.apellidos,
        direccion: user.direccion,
        telefono: user.telefono,
        nif: user.nif
      }

      post '/esp/conecta_users', params: params

      expect(json['object']['datelimit']).to eq(datelimit)
    end
  end

  context 'DELETE /:tolgeo/conecta_users/:id' do
    it 'disables a Conecta user' do
      no_connections = 0
      user = create(:user, { 'datelimit' => datelimit_in_milliseconds.to_s, 'maxconexiones' => 5 })

      delete '/esp/conecta_users/' + user.id.to_s

      disabled_user = json['object']
      expect(disabled_user['maxconexiones']).to eq(no_connections)
    end
  end

  context 'PUT /:tolgeo/conecta_users/:id' do
    it 'updates the attributes' do
      user = create(:user_accepts_privacidad)
      @another_subsystem = Esp::Subsystem.where(:id => 0).first || create(:subsystem, name: 'Another Subsystem', id: 0)
      user_subscription = create(:user_subscription, :user => user)
      new_maxconexiones = 10
      new_datelimit = datelimit_in_milliseconds.to_s
      new_password = 'new_password'
      new_attributes = {
        'password' => new_password,
        'datelimit' => new_datelimit,
        'maxconexiones' => new_maxconexiones,
        'grupo' => false,
        'comercial' => false
      }

      put '/esp/conecta_users/' + user.id.to_s, params: new_attributes

      updated_user = json['object']
      expect(updated_user['password']).to eq(new_password)
      expect(updated_user['datelimit']).to eq(datelimit)
      expect(updated_user['maxconexiones']).to eq(new_maxconexiones)
      expect(updated_user['grupo']).to eq(false)
      expect(updated_user['comercial']).to eq(false)
    end
  end

  context 'GET /:tolgeo/conecta_users/:id' do
    it 'retrieves a conecta user by id' do
      user = create(:user)

      get '/esp/conecta_users/' + user.id.to_s

      retrieved_user = json['object']
      expect(retrieved_user['username']).to eq(user.username)
    end

    it 'retrieves a conecta user by username' do
      user = create(:user)

      get '/esp/conecta_users/', params: { 'username' => user.username }

      retrieved_user = json['object']
      expect(retrieved_user['id']).to eq(user.id)
    end
  end

  def expect_conecta_user_is_equal_to(created_user)
    expect(created_user['subsystem']).to eq(conecta_user['subsystem'])
    expect(created_user['username']).to eq(conecta_user['username'])
    expect(created_user['user_type_group']).to eq(conecta_user['user_type_group'])
    expect(created_user['access_type_tablet']).to eq(conecta_user['access_type_tablet'])
    expect(created_user['subjects']).to eq(conecta_user['subjects'])
    expect(created_user['modulos']).to eq(conecta_user['modulos'])
    expect(created_user['products']).to eq(conecta_user['products'])
    expect(created_user['comentario']).to eq(conecta_user['comentario'])
    expect(created_user['access_type']).to eq(conecta_user['access_type'])
    expect(created_user['permisos']).to eq(permits)
    expect(created_user['datelimit']).to eq(datelimit)
  end

  def expect_conecta_user_lopd_params_are(created_user, lopd_params)
    expect(created_user['privacidad']).to eq(created_user['privacidad'])
    expect(created_user['grupo']).to eq(created_user['grupo'])
    expect(created_user['comercial']).to eq(created_user['comercial'])
  end

  def permits
    '00011100001110000111000011100001110'
  end

  def conecta_user
    {
      "actualizaciones" => false,
      "apellidos" => "User",
      "comentario" => "12345678a Some direction 987654321",
      "cp" => nil,
      "datelimit" => datelimit,
      "direccion" => "Some direction",
      "dominios" => nil,
      "email" => "conecta@user.com",
      "fax" => nil,
      "fechaalta" => nil,
      "fecharevision" => nil,
      "grupoid" => nil,
      "id" => 1,
      "imagen" => nil,
      "iscolectivo" => false,
      "isdemo" => false,
      "maxconexiones" => 5,
      "modulos" => [{ "id" => 5, "nombre" => "ut", "seccionweb" => 26, "key" => nil }],
      "nif" => "12345678a",
      "nombre" => "Conecta",
      "pais" => nil,
      "password" => "12345678",
      "permisos" => permits,
      "persona_contacto" => nil,
      "poblacion" => nil,
      "referer" => nil,
      "subid" => 0,
      "subjects" => [{"id"=>23, "nombre"=>"in", "tema"=>"molestias", "permisos_decimal"=>36, "permisos_binario"=>"96"}],
      "telefono" => "987654321",
      "tipoaccesoid" => 1,
      "tipoaccesotabletid" => 2,
      "tipousuariogrupoid" => 24,
      "total_sessions" => 0,
      "url_origen" => nil,
      "userIps" => [],
      "username" => "conecta@user.com",
      "products" => [{"id" => 21, "descripcion" => "qui", "activo" => true}]
    }
  end

  def datelimit_in_milliseconds
    1234567890000
  end

  def datelimit
    sec = (datelimit_in_milliseconds.to_f / 1000).to_s
    date = Time.strptime(sec, '%s')
    Time.strptime(sec, '%s').getutc.strftime('%a %b %d %H:%M:%S UTC %Y')
  end

  def stub_requests
    allow_any_instance_of(Esp::Foro).to receive(:update).and_return(Esp::Foro.new)
    allow_any_instance_of(Esp::Foro).to receive(:create).and_return(Esp::Foro.new)
  end

  def create_requirements
    create(:subsystem, id: 0)
    create(:user_type_group, id: 24)
    create(:access_type, id: 1)
    create(:access_type_tablet, id: 2)
    create(:subject, {"id" => 23, "nombre" => "in", "tema" => "molestias", "permisos_decimal" => 36, "permisos_binario" => "96"})
    create(:modulo, {"id" => 5, "nombre" => "ut", "seccionweb" => 26})
    create(:product, {"id" => 21, "descripcion" => "qui", "activo" => true})
  end
end
