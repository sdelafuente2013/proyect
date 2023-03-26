require 'rails_helper'

describe 'User Subscription Assumption', type: :request do

  let!(:subsystem) { Esp::Subsystem.where(:id => 0).first || create(:subsystem, name: 'Another Subsystem', id: 0)}
  
  before(:each) do
    stub_foro_requests
    Esp::UserSubscriptionAssumption.destroy_all
    Esp::UserSessionToken.destroy_all
    @user = create(:user)
    @subscription = create(:user_subscription, usuarioid: @user.id)
    @subscription2 = create(:user_subscription, usuarioid: @user.id)
    @case =  create(:esp_user_subscription_case,  user_subscription_id: @subscription.id)
    @case2 =  create(:esp_user_subscription_case,  user_subscription_id: @subscription.id)
    @user_assumption = create(:user_subcription_assumption_esp, user_subscription_id: @subscription.id, user_subscription_case_id: @case.id, title: "buscando sorianos de pus")
    @user_assumption2 = create(:user_subcription_assumption_esp, user_subscription_id: @subscription.id, user_subscription_case_id: @case2.id, title: "no mas sorianos please")
    @user_session_token_esp = create(:user_session_token_esp)
  end
  
  describe 'GET /user_subscription_assumptions' do
    it 'returns the assumption list of a user' do
      get '/esp/user_subscription_assumptions', params: {user_subscription_id: @subscription.id}

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(2)
      
    end
    
    it 'when subscription without assumptions then is zero results' do
      get '/esp/user_subscription_assumptions', params: {user_subscription_id: @subscription2.id}

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(0)
    end
    
    it 'filter with @case2' do
      get '/esp/user_subscription_assumptions', params: {user_subscription_id: @subscription.id, user_subscription_case_id: @case2.id.to_s}

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(1)
      expect(json['objects'][0]['id']).to eq(@user_assumption2.id.to_s)
    end
    
    it 'filter by name' do
      get '/esp/user_subscription_assumptions', params: {user_subscription_id: @subscription.id, title: "buscando"}

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(1)
      
      get '/esp/user_subscription_assumptions', params: {user_subscription_id: @subscription.id, title: "sorianos"}

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(2)
      
    end
    
  end
  
  describe 'GET /user_subscription_assumptions/:id' do
    it 'returns the user session token filter' do
      get "/esp/user_subscription_assumptions/#{@user_assumption.id}", params: {user_subscription_id: @subscription.id}

      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /user_subscription_assumptions/:id' do
    context 'when the request is valid' do
      it 'creates a user session token' do
        
        valid_attributes = {
          :title => "analizando sorianos",
          :user_subscription_id => @subscription.id,
          :user_subscription_case_id => @case.id,
          :filters => {'stringvalue' => 'mazo', 
                       'arrayvalue' => [1,2,3], 
                       'hashvalue' => {'0' => {'name' => 'option1', 
                                               'values' =>[1414,4141,454]}, 
                                       '1' => {'name' => 
                                              'option2', 'values' => [14,43]}
                                      }}}

        post  '/esp/user_subscription_assumptions', params: valid_attributes

        expect(response).to have_http_status(201)
        
        get "/esp/user_subscription_assumptions/%s" % json['object']['id'], params: {user_subscription_id: @subscription.id}

        expect(response).to have_http_status(200)

      end
    end
    
    context 'when the request has a session_token' do
      it 'creates a user session token' do
        
        valid_attributes = {
          :title => "analizando sorianos",
          :user_subscription_id => @subscription.id,
          :user_subscription_case_id => @case.id,
          :token_id => @user_session_token_esp.id,
          :filters => {'stringvalue' => 'mazo', 
                       'arrayvalue' => [1,2,3], 
                       'hashvalue' => {'0' => {'name' => 'option1', 
                                               'values' =>[1414,4141,454]}, 
                                       '1' => {'name' => 
                                              'option2', 'values' => [14,43]}
                                      }}}

        post  '/esp/user_subscription_assumptions', params: valid_attributes

        expect(response).to have_http_status(201)

        @user_session_token_esp.filters.keys.each do |token_filter|
          expect( response.parsed_body["object"]["filters"].keys.include?(token_filter)).to be_truthy
        end
        get "/esp/user_subscription_assumptions/%s" % json['object']['id'], params: {user_subscription_id: @subscription.id}

        expect(response).to have_http_status(200)

      end
    end
  end

  describe 'PUT /user_subscription_assumptions/:id' do
    context 'when the request is valid' do
      it 'updates the user session token with new params' do
        valid_attributes = { filters: {'stringvalue' => 'mola', 'kk' => 'mola'} }

        put "/esp/user_subscription_assumptions/#{@user_assumption.id}", params: valid_attributes

        expect(response).to have_http_status(200)
        expect(json['object']['filters']).to eq({'stringvalue' => 'mola', 'kk' => 'mola'})
      end
    end
  end
  
  describe 'DELETE /user_subscription_assumptions/:id' do
    context 'when the request is valid' do
      it 'updates the user session token with new params' do
        @user_assumption_2 = create(:user_subcription_assumption_esp, user_subscription_id: @subscription.id, user_subscription_case_id: @case.id)
        delete "/esp/user_subscription_assumptions/#{@user_assumption_2.id}"
        
        expect(response).to have_http_status(:no_content)
         
        get "/esp/user_subscription_assumptions/%s" % @user_assumption_2.id.to_s, params: {user_subscription_id: @subscription.id}
        
        expect(response).to have_http_status(:not_found)
        
      end
    end
  end
  
  def stub_foro_requests
    allow(Esp::Foro).to receive(:new)
  end

end

