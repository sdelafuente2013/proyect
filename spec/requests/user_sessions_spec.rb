require 'rails_helper'

describe 'User Sessions Api', type: :request do

  before(:each) do
    @user = create(:user)
    @user_session = create(:user_session_esp, :invalidated => false, :userId => @user.id.to_s)
    @permissions = {"id" => @user.id,
                   "modulos" => @user.modulo_ids,
                   "subjects" => @user.subject_ids,
                   "products" => @user.product_ids,
                   "usuario_premium" => @user.is_premium?,
                   "permissions" => @user.permisos,
                   "jurisprudencia_origenes" => @user.jurisprudencia_origenes,
                   "jurisprudencia_jurisdicciones" => @user.jurisprudencia_jurisdicciones,
                   "number_type_docs" => -1,
                   }
  end

  describe 'GET /user_sessions' do
    it 'returns the user session object' do
      get "/esp/user_sessions/#{@user_session.id}"

      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /user_sessions/:id' do
    it 'updates user_sessions' do

      get "/esp/user_sessions/#{@user_session.id}"
      ultimo_acceso_before = json['object']['ultimoAcceso']

      valid_attributes = {}

      put "/esp/user_sessions/#{@user_session.id}", params: valid_attributes
      expect(response).to have_http_status(200)
      expect(json['object']['ultimoAcceso']).to_not eq(ultimo_acceso_before)
      expect(json['object']['sessionAttributes']['permissions']).to eq(@permissions)
    end
  end

  describe 'DELETE /user_sessions/:id' do
    context 'when specific a user_session to delete' do
      it 'returns status code 204' do

        delete "/esp/user_sessions/#{@user_session.id}"
        @user_session.reload
        expect(@user_session.invalidated).to eq(true)
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'POST /user_sessions' do

    it 'create user_sessions' do

      valid_attributes = {userId: @user.id.to_s}


      post '/esp/user_sessions', params: valid_attributes

      expect(response).to have_http_status(201)

      get "/esp/user_sessions/%s" % json['object']['id']

      expect(response).to have_http_status(200)
      expect(json['object']['invalidated']).to be_falsey
      expect(json['object']['userId']).to  eq(@user.id.to_s)
      expect(json['object']['sessionAttributes']['subid']).to  eq(@user.subid)
      expect(json['object']['sessionAttributes']['permissions']).to eq(@permissions)

    end

    it 'create user_sessions with default maxInactiveInterval' do
      valid_attributes = {userId: @user.id.to_s}
      post '/esp/user_sessions', params: valid_attributes
      expect(json['object']['maxInactiveInterval']).to eq Settings.user_session.max_inactive_interval
    end


    context 'with modified maxInactiveInterval in Settings' do
      before do
        Settings.user_session.max_inactive_interval=999
      end

      it 'create user_session with this maxInactiveInterval value' do
        valid_attributes = {userId: @user.id.to_s}
        post '/esp/user_sessions', params: valid_attributes

        expect(json['object']['maxInactiveInterval']).to eq 999
      end

    end

    context 'with SESSION_MAX_INACTIVE_INTERVAL in env' do
      before do
        ENV['SESSION_MAX_INACTIVE_INTERVAL']= '666'
      end

      it 'create user_session with this maxInactiveInterval value' do
        valid_attributes = {userId: @user.id.to_s}
        post '/esp/user_sessions', params: valid_attributes

        expect(json['object']['maxInactiveInterval']).to eq 666
      end

    end

  end

end
