require 'rails_helper'

describe 'Users Cloudlibrary Api', type: :request do
  let!(:users) { create_list(:user, 10) }
  let!(:modulo) { create(:modulo) }
  let!(:users_cloudlibrary) { users.map{|user| create(:user_cloudlibrary, :user => user, :modulo => modulo) } }
  let(:user_id) { users_cloudlibrary.first.id }

  describe 'GET /user_cloudlibraries' do
    context 'without params' do
      it 'returns list of users' do
        get '/esp/user_cloudlibraries'

        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(10)
      end
    end

    context 'with usuarioid' do
      it 'returns list of users' do
        get '/esp/user_cloudlibraries', params: {usuarioid: users.first.id}

        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(1)
      end
    end

    context 'with moduloid' do
      it 'returns list of users' do
        get '/esp/user_cloudlibraries', params: {moduloid: modulo.id}

        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(10)
      end
    end

    context 'with usuarioid and moduloid' do
      it 'returns list of users' do
        get '/esp/user_cloudlibraries', params: {moduloid: modulo.id, usuarioid: users.first.id}

        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(1)
      end
    end
  end

  describe 'GET /user_cloudlibraries/:id' do
    context 'when the user exists' do
      it 'returns the detail of the user' do
        get "/esp/user_cloudlibraries/#{user_id}"

        expect(response).to have_http_status(200)
        expect(json['resource']).to eq(user_id)
      end
    end

    context 'when the user that not exist' do
      let(:user_id) { 2 }

      it 'returns status code 404' do
        get "/esp/user_cloudlibraries/#{user_id}"

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get "/esp/user_cloudlibraries/#{user_id}"

        expect(response.body).to match(/Couldn't find Esp::User/)
      end
    end
  end

  describe 'POST /user_cloudlibraries' do
    context 'when the request is valid' do
      it 'creates a user cloudlibrary' do

        new_modulo = create(:modulo)
        new_user = create(:user)

        valid_attributes = {
          usuarioid: new_user.id,
          moduloid: new_modulo.id,
          cloud_user: "tonetti",
          cloud_password: "sorianodepus"
        }

        post '/esp/user_cloudlibraries', params: valid_attributes

        expect(response).to have_http_status(201)
        expect(json['object']['usuarioid']).to eq(new_user.id)
        expect(json['object']['moduloid']).to eq(new_modulo.id)
        expect(json['object']['cloud_user']).to eq('tonetti')
        expect(json['object']['cloud_password']).to eq('sorianodepus')

        get "/esp/user_cloudlibraries/%s" % json['object']['id']

        expect(response).to have_http_status(200)
      end
    end

    context 'when the user and modulo already exists' do

      it 'creates a user cloudlibrary' do

        valid_attributes = {
            usuarioid: users_cloudlibrary.first.usuarioid,
            moduloid: users_cloudlibrary.first.moduloid,
            cloud_user: "tonetti",
            cloud_password: "sorianodepus",
            locale: 'en'
          }

        post '/esp/user_cloudlibraries', params: valid_attributes

        expect(response).to have_http_status(422)
        expect(response.body).to include('Moduloid has already been taken')

      end

    end

  end

  describe 'DELETE /user_cloudlibraries/:id' do
    let!(:user_to_delete) { create(:user_cloudlibrary) }

    context 'when delete user cloudlibrary' do
      it 'returns status code 204' do
        delete "/esp/user_cloudlibraries/#{user_to_delete.id}"

        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'PUT /user_cloudlibraries/:id' do
    it 'update with different user' do
      new_user = create(:user)
      valid_attributes = { usuarioid: new_user.id }
      put "/esp/user_cloudlibraries/#{user_id}", params: valid_attributes

      expect(response).to have_http_status(200)

      put "/esp/user_cloudlibraries/#{user_id}"
      expect(response).to have_http_status(200)

      expect(json['object']['usuarioid']).to eq(new_user.id)

    end
  end

end
