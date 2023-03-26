require 'rails_helper'

describe 'User Subscription Api', type: :request do
  describe 'DELETE /user_subscription_logins' do
    before do
      @user = create(:user)
      sessionAttributes = { 'subscriptionid' => 1,
                            'perusuid' => '2',
                            'perusername' => 'sorianodepus',
                            'perusupwd' => 'molamazo',
                            'perusuusuario' => {},
                            'paquete' => 'soriano',
                            'optionsPerSubscription' => true }

      @user_session = create(:user_session_esp, invalidated: false, userId: @user.id.to_s,
                                                sessionAttributes: sessionAttributes)
    end

    context 'then remove user_subscription attributes from session' do
      it 'do login for a user susbcription' do
        delete '/esp/user_subscription_logins/%s' % @user_session.id.to_s
        expect(response).to have_http_status(:no_content)

        @user_session.reload
        @user_session.class::ATTRS_USER_SUBSCRIPTION.each do |attribute|
          expect(@user_session['sessionAttributes'].key?(attribute)).to be_falsey
        end

        expect(@user_session['sessionAttributes']['paquete']).to eq('soriano')
      end
    end
  end

  describe 'POST /user_subscription_logins' do
    let(:subscription_password) { 'mypassword' }

    before do
      stub_foro_requests

      @access_type_tablet = Esp::AccessTypeTablet.where(id: 1).first || create(
        :access_type_tablet, id: 1
      )
      @access_type_tablet_2 = Esp::AccessTypeTablet.where(id: 2).first || create(
        :access_type_tablet, id: 2
      )
      @subsystem = Esp::Subsystem.where(id: 0).first || create(:subsystem,
                                                               name: 'Another Subsystem', id: 0)
      @user = create(:user, subid: @subsystem.id, tipoaccesotabletid: 1)
      @user_2 = create(:user, subid: @subsystem.id, tipoaccesotabletid: 2)
      @subscription = create(:user_subscription, usuarioid: @user.id, acceso_tablet: false,
                                                 password: subscription_password)
      @subscription_without_user = create(:user_subscription, usuarioid: nil, subid: @subsystem.id)
      @user_session = create(:user_session_esp, invalidated: false, userId: @user.id)
      @user_session_invalid = create(:user_session_esp, invalidated: true, userId: @user.id)
      @user_session_2 = create(:user_session_esp, invalidated: false, userId: @user_2.id)

      @valid_attributes = {
        perusuid: @subscription.perusuid,
        password: subscription_password,
        subid: @subsystem.id,
        sessionid: @user_session.id.to_s
      }
      @md5_password = Digest::MD5.hexdigest(subscription_password)
    end

    context 'when the request is valid' do
      it 'do login for a user susbcription' do
        post '/esp/user_subscription_logins', params: @valid_attributes

        expect(response).to have_http_status(:created)
        expect(json['object']['perusuid']).to eq(@subscription.perusuid)
        expect(json['object']['acceso_tablet']).to eq(false)
        expect(json['object']['password']).to eq(nil)

        @user_session.reload
        expect(@user_session['sessionAttributes']['subscriptionid']).to eq(@subscription.id)
        expect(@user_session['sessionAttributes']['perusuid']).to eq(@subscription.perusuid)
        expect(@user_session['sessionAttributes']['perusername']).to eq(@subscription.username)
        expect(@user_session['sessionAttributes']['perusuusuario']).to eq({ 'id' => @user.id,
                                                                            'username' => @user.username })
        expect(@user_session['sessionAttributes']['optionsPerSubscription']).to eq(true)
      end
    end

    context 'when the password is in md5' do
      it 'do login for a user susbcription using md5' do
        post '/esp/user_subscription_logins',
             params: @valid_attributes.merge(password: @md5_password)

        expect(response).to have_http_status(:created)
      end
    end

    context 'when the password is invalid' do
      it 'returns status code :unauthorized a failure message' do
        post '/esp/user_subscription_logins', params: @valid_attributes.merge(password: '141')

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Usuario o password incorrecto')
      end
    end

    context 'when the username is invalid' do
      it 'returns status code :unauthorized a failure message' do
        post '/esp/user_subscription_logins',
             params: @valid_attributes.merge(perusuid: 'pepito')

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Usuario o password incorrecto')
      end
    end

    context 'when the subid is invalid' do
      it 'returns status code :unauthorized a failure message' do
        post '/esp/user_subscription_logins', params: @valid_attributes.merge(subid: 100)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Usuario o password incorrecto')
      end
    end

    context 'when the session not exists' do
      it 'returns status code :unauthorized a failure message' do
        post '/esp/user_subscription_logins',
             params: @valid_attributes.merge(sessionid: '14141414')

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Document(s) not found. When calling Esp::UserSession.find')
      end
    end

    context 'when the params is empty' do
      it 'returns status code :unauthorized a failure message' do
        post '/esp/user_subscription_logins', params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Document.find expects the parameters to be 1')
      end
    end

    context 'when the session is invalid' do
      it 'returns status code :unprocessable_entity a failure message' do
        post '/esp/user_subscription_logins',
             params: @valid_attributes.merge(sessionid: @user_session_invalid.id.to_s)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('La session es invalida')
      end
    end

    context 'when the user session is different from user_subscription user' do
      it 'do login for a user susbcription and assign new user permissions' do
        post '/esp/user_subscription_logins',
             params: @valid_attributes.merge(sessionid: @user_session_2.id.to_s)

        expect(response).to have_http_status(:created)

        expect(json['object']['perusuid']).to eq(@subscription.perusuid)
        expect(json['object']['usuarioid']).to eq(@user_2.id)
        expect(json['object']['acceso_tablet']).to eq(true)
        expect(json['object']['password']).to eq(nil)
      end
    end
  end

  def stub_foro_requests
    allow(Esp::Foro).to receive(:new)
  end
end
