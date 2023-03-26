require 'rails_helper'

describe 'User Session Tokens Api', type: :request do

  before(:each) do
    @user_session_token_esp = create(:user_session_token_esp)
  end
  
  describe 'GET /user_session_tokens/:id' do
    it 'returns the user session token filter' do
      get "/esp/user_session_tokens/#{@user_session_token_esp.id}"

      expect(response).to have_http_status(200)
      expect(json['object']['id']).to eq(@user_session_token_esp.id.to_s)
      expect(json['object']['filters']).to eq(@user_session_token_esp.filters)
    end
  end

  describe 'POST /user_session_tokens/:id' do
    context 'when the request is valid' do
      it 'creates a user session token' do
        
        valid_attributes = {
          :filters => {'stringvalue' => 'mazo', 
                       'arrayvalue' => [1,2,3], 
                       'hashvalue' => {'0' => {'name' => 'option1', 
                                               'values' =>[1414,4141,454]}, 
                                       '1' => {'name' => 
                                              'option2', 'values' => [14,43]}
                                      }}}

        post  '/esp/user_session_tokens', params: valid_attributes

        expect(response).to have_http_status(201)
        
        get "/esp/user_session_tokens/%s" % json['object']['id']

        expect(response).to have_http_status(200)

      end
    end
    context 'when filters param is nil' do
      it 'creates a user session token with empty filters' do
        
        valid_attributes = {
          :filters => nil}

        post  '/esp/user_session_tokens', params: valid_attributes

        expect(response).to have_http_status(201)
        
        get "/esp/user_session_tokens/%s" % json['object']['id']
        
        expect(response).to have_http_status(200)
        
        expect(json["object"]["filters"]).to eq({})
      end
    end
  end

  describe 'PUT /user_session_tokens/:id' do
    context 'when the request is valid' do
      it 'updates the user session token with new params' do
        valid_attributes = { filters: {'stringvalue' => 'mola', 'kk' => 'mola'} }

        put "/esp/user_session_tokens/#{@user_session_token_esp.id}", params: valid_attributes

        expect(response).to have_http_status(200)
        expect(json['object']['filters']).to eq({'stringvalue' => 'mola', 'kk' => 'mola'})
      end
    end
  end

end

