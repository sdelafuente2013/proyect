require 'rails_helper'

describe 'AccessTokens Api', type: :request do

  let!(:user_tol) { create(:user) }
  let!(:access_tokens_from_tol) { create(:access_token, :user_id => user_tol.id, :app_from => "tol", :app_to => "cloud" ) }

  let(:valid_attributes) {
    {user_id: user_tol.id,
     app_from: "tol",
     app_to: 'cloud'
    }
  }

  let(:invalid_attributes) {
    {app_from: "tol",
     app_to: 'cloud',
     locale: 'en'
    }
  }

  describe 'GET /access_tokens/:id' do

    context 'when the token exists' do

      before do
        get "/esp/access_tokens/#{access_tokens_from_tol.id}"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the detail of the user' do
        expect(json['resource']).to eq(access_tokens_from_tol.id.to_s)
        expect(json['object']["user_id"]).to eq(user_tol.id)
      end
    end

    context 'when the token that not exist' do

      it 'returns status code 404' do
        get "/esp/access_tokens/molamazo"

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get "/esp/access_tokens/molamazo"
        expect(json["message"]).to include("Document(s) not found")
      end
    end
  end

  describe 'POST /access_tokens' do

    context 'with valid params' do
      it 'creates a access_token' do

        post '/esp/access_tokens', params: valid_attributes

        expect(response).to have_http_status(201)
        expect(json['object']['user_id']).to eq(user_tol.id)
        expect(json['object']['id']).to_not be_nil
        expect(json['object']['id'].is_a?(String)).to eq(true)
        expect(json['object']['created_at']).to_not be_nil
      end
    end

    context 'with valid params with email' do
      it 'creates a access_token' do
        @email = "tony@tirant.es"
        post '/esp/access_tokens', params: valid_attributes.merge(:email => @email)

        expect(response).to have_http_status(201)
        expect(json['object']['user_id']).to eq(user_tol.id)
        expect(json['object']['id']).to_not be_nil
        expect(json['object']['id'].is_a?(String)).to eq(true)
        expect(json['object']['email']).to eq(@email)
        expect(json['object']['created_at']).to_not be_nil
      end
    end

    context 'with invalid params' do
      before do
        post '/esp/access_tokens', params: invalid_attributes
      end

      it 'creates a access_token' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation message' do
         expect(json["message"]).to include("User can't be blank")
      end
    end

  end

  describe 'DELETE /access_tokens/:id' do

    context 'when the token exists' do

      before do
        @token_to_delete = create(:access_token, :user_id => user_tol.id, :app_from => "tol", :app_to => "cloud" )
        delete "/esp/access_tokens/#{@token_to_delete.id}"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(204)
      end

      it 'and the object is deleted' do
        expect(Esp::AccessToken.where(:id => @token_to_delete.id).first).to be_nil
      end

    end

    context 'when the token not exists' do

      before do
        delete "/esp/access_tokens/molamazo"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(204)
      end

    end

    context 'when the token that not exist' do

      it 'returns status code 404' do
        get "/esp/access_tokens/molamazo"

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get "/esp/access_tokens/molamazo"
        expect(json["message"]).to include("Document(s) not found")
      end
    end
  end

end
