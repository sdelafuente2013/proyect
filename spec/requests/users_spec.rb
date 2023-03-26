require 'rails_helper'

describe 'Users Api', type: :request do
  let(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }
  let(:modulo) { create(:modulo) }

  before (:each) do
    stub_requests
  end

  describe 'GET /users' do
    it 'returns list of users' do
      users

      get '/esp/users'

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(10)
    end
  end

  describe 'GET /users/:id' do
    context 'when the user exists' do
      it 'returns the detail of the user' do
        get "/esp/users/#{user_id}"

        expect(response).to have_http_status(200)
        expect(json['resource']).to eq(user_id)
      end
    end

    context 'when the user that not exist' do
      let(:user_id) { 2 }

      it 'returns status code 404' do
        get "/esp/users/#{user_id}"

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get "/esp/users/#{user_id}", params: { locale: 'en' }

        expect(response.body).to match(/Couldn't find Esp::User/)
      end
    end
  end

  describe 'GET /users' do
    context 'when search by username' do
      it 'returns the detail of the user' do
        username = users.first.username

        get "/esp/users", params: { username: username }

        expect(response).to have_http_status(200)
        expect(json['total']).to eq(1)
      end
    end

    context 'when search by fecha_alta_start' do
      it 'returns users created after that date' do
        fecha_alta_start = '08-06-2018'
        create(:user, fechaalta: fecha_alta_start)
        create(:user, fechaalta: '01-01-2018')

        get "/esp/users", params: { fecha_alta_start: fecha_alta_start }

        expect(json['total']).to eq(1)
      end
    end

    context 'when search by fecha_revision_start' do
      it 'returns users revised after that date' do
        fecha_revision_start = '2018-06-08'
        create_user_with_fecharevision(fecha_revision_start)
        create_user_with_fecharevision('2018-01-01')

        get "/esp/users", params: { fecha_revision_start: fecha_revision_start }

        expect(json['total']).to eq(1)
      end

      it 'returns users revised after that date' do
        fecha_revision_start = '01-05-2017'
        create(:user, fecharevision: fecha_revision_start)
        create(:user, fecharevision: '01-01-2018')

        get "/esp/users", params: { fecha_revision_start: fecha_revision_start }

        expect(json['total']).to eq(2)
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:user) { create(:user) }
    let(:user_id) { user.id }
    let(:valid_attributes) {
      {
        email: 'new_email@host.com',
        comercial: false,
        grupo: false,
        privacidad: true,
        independent_offices: true
      }
    }

    context 'when the user exists' do
      before { put "/esp/users/#{user_id}", params: valid_attributes }

      it 'updates the user with the new email and lopd params' do
        expect(json['object']['email']).to eq('new_email@host.com')
        expect(json['object']['grupo']).to eq(false)
        expect(json['object']['comercial']).to eq(false)
        expect(json['object']['privacidad']).to eq(true)
        expect(json['object']['independent_offices']).to eq(true)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates the user with the new user ips' do
        user_ips = search_user_ips(user)
        params = {
          userIps_attributes: {
            id: user_ips['0'][:id],
            ipfrom: "255.255.0.0",
            ipto: "255.255.0.0"
          }
        }

        put "/esp/users/#{user_id}", params: params
        user.reload

        expect(user.get_lopd_user.email).to eq('new_email@host.com')
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user does not exist' do
      it 'responds with 404 if user does not exist' do
        user_id = 2

        put "/esp/users/#{user_id}", params: valid_attributes

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /users/:id' do
    let!(:user) { create(:user) }
    let(:user_id) {  user.id  }
    let!(:backoffice_user) { create(:backoffice_user) }

    context 'when specific a userip to deleted' do

      it 'returns status code 200' do
        add_another_user_ips(user)
        all_user_ips = search_user_ips(user)

        put "/esp/users/#{user_id}", params:{ userIps_attributes: all_user_ips['0']['_destroy'] = 1 }
        user.reload

        expect(response).to have_http_status(200)
      end
    end

    context 'when delete user completed with backoffice user id' do
      it 'returns status code 204' do
        delete "/esp/users/#{user_id}?current_user_id=#{backoffice_user.id}"
        expect(response).to have_http_status(204)
      end
    end

    context 'when delete user completed withot backoffice user id' do
      it 'returns status code 204' do
        delete "/esp/users/#{user_id}"
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /user' do
    let(:user_params) { generate_user_params(email: 'user_email@tirant.com') } 

    subject { post '/esp/users',params: user_params, as: :json }
    
    before do |example| 
      subject unless example.metadata[:skip_subject]
    end

    context 'with perso account' do
      let(:user_params) { generate_user_params(email: 'user_email@tirant.com', add_perso_account: true) } 
      
      it 'can be created with a personalization account' do
        expect(Esp::UserSubscription.by_email( 'user_email@tirant.com' ).first).not_to be_nil
      end
    end
    
    context 'without perso account' do 
      
      it 'can be created without a personalization account' do
        expect(Esp::UserSubscription.by_email( 'user_email@tirant.com' ).first).to be_nil
      end
    end

    context 'when the request is valid' do
      it 'creates a user', skip_subject: true do
        access_type = create(:access_type)
        user_type_group = create(:user_type_group)
        subsystem = create(:subsystem)
        access_type_tablet = create(:access_type_tablet)
        subjects = create_list(:subject, 3)
        modulos = create_list(:modulo, 3)
        valid_attributes = {
          username: 'everett',
          password: 'SdU5I3YbMtLjWuU',
          email: 'fabian@baumbach.net',
          maxconexiones: 5,
          independent_offices: true,
          tipoaccesoid: access_type.id,
          tipousuariogrupoid: user_type_group.id,
          subid: subsystem.id,
          tipoaccesotabletid: access_type_tablet.id,
          userIps_attributes: user_ips,
          subject_ids: [subjects.first.id, subjects.last.id],
          modulo_ids: [modulos.first.id, modulos.last.id],
          userCloudlibraries_attributes: user_cloudlibraries,
          comercial: false,
          grupo: true,
          privacidad: true
        }

        post '/esp/users', params: valid_attributes

        expect(response).to have_http_status(201)
        expect(json['object']['email']).to eq('fabian@baumbach.net')
        expect(json['object']['userIps'].size).to eq(2)
        expect(json['object']['subjects'].size).to eq(2)
        expect(json['object']['userCloudlibraries'].size).to eq(1)
        expect(json['object']['comercial']).to eq(false)
        expect(json['object']['grupo']).to eq(true)
        expect(json['object']['privacidad']).to eq(true)
        expect(json['object']['independent_offices']).to eq(true)

        get "/esp/users/%s" % json['object']['id']

        expect(response).to have_http_status(200)
        expect(json['object']['subjects'].size).to eq(2)
      end
    end

    describe 'when the email option is ON' do
      let(:user_params) { generate_user_params(has_to_send_welcome_email: true) }
    
      it 'enques welcome email job with data', skip_subject: true do
         expect{subject}.to have_enqueued_job(User::SendFullDataJob)
      end

    end

    describe 'when the email option is OFF' do
      it 'does not enques welcome email service with data', skip_subject: true do
        expect{subject} .not_to have_performed_job(User::SendFullDataJob)
      end
      
    end

    describe 'when the username already exists' do
      let!(:user) { create(:user) }
      let(:user_params) { generate_user_params(username: user.username) }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to include('Username ya está en uso')
      end
    end

    context 'when the email is invalid' do
      let(:user_params) { { email: 'invaid_email@host', locale: 'en', add_perso_account: true } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to include('Email is invalid')
      end
    end

    context 'when the request is invalid' do
      let(:user_params) { { locale: 'en' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to include('Validation failed: Access type must exist')
      end
    end
  end

  it 'enables tablet access for its UserSubscription when it sets its tablet access' do
    allow_tablet_access = 2
    access_not_enabled = create(:access_type_tablet, id: 1)
    create(:access_type_tablet, id: allow_tablet_access)
    create(:subsystem, id: 0)
    user = create(:user, access_type_tablet: access_not_enabled)
    subscription = create(:user_subscription, user: user, acceso_tablet: false)
    enable_tablet_access = {
      access_type_tablet: allow_tablet_access
    }

    put "/esp/users/#{user.id}", params: enable_tablet_access

    user_subscriptions = Esp::UserSubscription.find(subscription.id)
    expect(user_subscriptions.acceso_tablet).to eq(true)
  end

  def add_another_user_ips(user)
    create(:userIps, :user => user)
  end

  def search_user_ips(user)
    result = {}
    user.userIps.each_with_index do
      |user_ip, index| result[index.to_s] = { 'ipfrom': user_ip.ipfrom, 'ipto': user_ip.ipto, 'id': user_ip.id }
    end

    result
  end

  def generate_user_params(email:nil,username:nil,add_perso_account:false,has_to_send_welcome_email:false)
    access_type = create(:access_type)
    user_type_group = create(:user_type_group)
    subsystem = create(:subsystem)
    access_type_tablet = create(:access_type_tablet)
    number = Esp::User.all.count

    {
      'tipoaccesoid' => access_type.id,
      'tipousuariogrupoid' => user_type_group.id,
      'subid' => subsystem.id,
      'tipoaccesotabletid' => access_type_tablet.id,
      'password' => Faker::Internet.password(8),
      'maxconexiones' => 5,
      'username' => username ||"TestUser#{number}",
      'email' => email || Faker::Internet.email,
      'add_perso_account' => add_perso_account,
      'has_to_send_welcome_email'=> has_to_send_welcome_email
    }
  end

  def user_ips
    {
      '0': { 'ipfrom': '255.255.0.0', 'ipto': '255.255.0.0' },
      '1': { 'ipfrom': '255.255.0.0', 'ipto': '255.255.0.0' },
      '101': { 'ipfrom': '', 'ipto': '' },
      '102': { 'ipfrom': '', 'ipto': '' }
    }
  end

  def user_cloudlibraries
    {
      '0': { 'cloud_user': 'tonetti', 'cloud_password': 'sorianodepus', 'moduloid': modulo.id }
    }
  end

  def create_or_return_modulo_consultoria
    @modulo ||= create(:modulo, :id => 4)
  end

  def stub_requests
    stub_request(:any, "%s" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
    stub_request(:any, "%s/crea_usuario.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
    stub_request(:any, "%s/modifica_usuario.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
    stub_request(:any, "%s/borra_usuario.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
    @group_request = stub_request(:any, "%s/crea_grupo.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
    stub_request(:any, "%s/modifica_grupo.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
    stub_request(:any, "%s/borra_grupo.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
    stub_request(:any, "%s/grupo_mueve_a_grupos.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
    stub_request(:any, "%s/esp/backoffice_despachos" % ENV['XT_GD_API_BASE_URI']).with(query: hash_including({}))
    stub_request(:get, "%s/esp/user_personalizations" % ENV['XT_CLOUDLIBRARY_API_BASE_URI']).with(query: hash_including({}))
    allow(OfficesClient::BackofficeDespacho).to receive(:updateall).and_return(0)
  end

  def create_user_with_fecharevision(a_date)
    allow_any_instance_of(Time).to receive(:strftime).and_return(a_date)
    create(:user)
    allow_any_instance_of(Time).to receive(:strftime).and_call_original
  end

  describe 'Users Api Latam', type: :request do
    let!(:user) { create(:user_latam) }
    let(:user_id) {  user.id  }
    let!(:backoffice_user) { create(:backoffice_user) }

    before (:each) do
      stub_request_cloudlibrary
    end

    describe 'DELETE /users/:id' do

      context 'when delete user completed with backoffice user id' do
        it {
            expect { delete "/latam/users/#{user_id}?current_user_id=#{backoffice_user.id}"}.to change { Latam::User.count }.by(-1)
        }
      end

    end

    def stub_request_cloudlibrary
      stub_request(:get, "%s/latam/user_personalizations" % ENV['XT_CLOUDLIBRARY_API_BASE_URI']).with(query: hash_including({}))
    end
  end
end
