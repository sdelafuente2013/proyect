require 'rails_helper'

describe 'User Subscription Search', type: :request do
 
  before(:each) do
    Latam::UserSubscriptionSearch.destroy_all
    subsystem = create(:subsystem_latam)
    @user = create(:user_latam, subsystem: subsystem)
    @subscription = create(:user_subscription_latam, usuarioid: @user.id, subsystem: subsystem)
    @subscription2 = create(:user_subscription_latam, usuarioid: @user.id, subsystem: subsystem)
    @case =  create(:latam_user_subscription_case,  user_subscription_id: @subscription.id)
    @case2 =  create(:latam_user_subscription_case,  user_subscription_id: @subscription.id)
    @user_search = create(:user_subscription_search, user_subscription_id: @subscription.id, user_subscription_case_id: @case.id, summary: "Busqueda Sentencia")
    @user_search2 = create(:user_subscription_search_2, user_subscription_id: @subscription.id, user_subscription_case_id: @case2.id, summary: "Busqueda Informe Reservado")
  end
  
  describe 'GET /user_subscription_searches' do
    it 'returns the saved search list of a user' do
      get '/latam/user_subscription_searches', params: {user_subscription_id: @subscription.id}

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(2)
      
    end
    
    it 'when subscription without searches then is zero results' do
      get '/latam/user_subscription_searches', params: {user_subscription_id: @subscription2.id}

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(0)
    end
    
    it 'filter with @case2' do
      get '/latam/user_subscription_searches', params: {user_subscription_id: @subscription.id, user_subscription_case_id: @case2.id.to_s}
      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(1)
      expect(json['objects'][0]['id']).to eq(@user_search2.id.to_s)
    end
    
    it 'filter by summary' do
      get '/latam/user_subscription_searches', params: {user_subscription_id: @subscription.id, summary: "Auto"}
      
      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(0)

      get '/latam/user_subscription_searches', params: {user_subscription_id: @subscription.id, summary: "Sentencia"}

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(1)
      
      get '/latam/user_subscription_searches', params: {user_subscription_id: @subscription.id, summary: "Busqueda"}

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(2)
      
    end
    
  end
  
  describe 'GET /user_subscription_searches/:id' do
    it 'returns the user subscription search filter' do
      get "/latam/user_subscription_searches/#{@user_search.id}", params: {user_subscription_id: @subscription.id}

      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /user_subscription_searches/' do
    context 'when the request is valid' do
      it 'creates a user subscription search' do
        valid_attributes = {
          :summary => "Nuevas sentencias ",
          :user_subscription_id => @subscription.id,
          :user_subscription_case_id => @case.id,
          :is_alertable => true,
          :period => "semanal",
          :filters => { 'search_tokens' =>  ["delito de lesiones"] ,
                        'search_type' =>  'jurisprudencia' ,
                        'query_field' =>  'all' ,
                        'query_format' =>  'substring ' ,
                        'filters' => [{'name'=>'tiporesolucion_latam', 'values'=>['Sentencia'], 'operator'=>'OR'}, {'name'=>'origen_latam', 'values'=>['Tribunal Constitucional'], 'operator'=>'OR'}],
                        'sort' => 'score desc'
                      }
        }

        post  '/latam/user_subscription_searches', params: valid_attributes

        expect(response).to have_http_status(201)
        
        get "/latam/user_subscription_searches/%s" % json['object']['id'], params: {user_subscription_id: @subscription.id}

        expect(response).to have_http_status(200)

      end
    end

    context 'when the request is invalid (without summary)' do
      it 'does not create a user subscription search' do
        Latam::UserSubscriptionSearch.destroy_all
        invalid_attributes = {
          :user_subscription_id => @subscription.id,
          :user_subscription_case_id => @case.id,
          :filters => { 'search_tokens' =>  ["delito de lesiones"] ,
                        'search_type' =>  'jurisprudencia' ,
                        'query_field' =>  'all' ,
                        'query_format' =>  'substring ' ,
                        'filters' => [],
                        'sort' => 'score desc'
                      }
        }

        post  '/latam/user_subscription_searches', params: invalid_attributes

        expect(response).to have_http_status(422)
        
        get '/latam/user_subscription_searches', params: {user_subscription_id: @subscription.id}

        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(0)

      end
    end
  end

  describe 'DELETE /latam/user_subscription_searches:id' do
    context 'when the request is valid' do
      it 'removes the search from user subscription' do
        @user_search = create(:user_subscription_search, user_subscription_id: @subscription.id, user_subscription_case_id: @case.id, summary: "Busqueda Sentencia")
        delete "/latam/user_subscription_searches/#{@user_search.id}"
        
        expect(response).to have_http_status(:no_content)
         
        get "/latam/user_subscription_searches/%s" % @user_search.id.to_s, params: {user_subscription_id: @subscription.id}
        
        expect(response).to have_http_status(:not_found)
        
      end
    end
  end
end

