require 'rails_helper'

describe 'UserSubscriptionCases Api', type: :request do

  let!(:user_subscription_cases) { create_list(:esp_user_subscription_case,2) }
  let!(:user_subscription_cases2) { create_list(:esp_user_subscription_case, 1, :namecase => 'tonyvsdani') }
  let!(:user_subscription_cases3) { create_list(:esp_user_subscription_case, 1, :namecase => 'prueba', :user_subscription_id => 1) }
  let(:user_subscription_cases_id) { user_subscription_cases.first.id }
  before(:each) do
    stub_foro_requests
  end
  describe 'GET /user_subscription_cases' do

    context 'returns user_subscription_case without params' do

      before(:context) do
        Esp::UserSubscriptionCase.destroy_all()
      end

      it 'returns all items paginated' do
        get '/esp/user_subscription_cases'
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(4)
        expect(json['total']).to eq(4)
      end

    end

    context 'when i search by namecase tonyvsdani' do

      before(:context) do
        Esp::UserSubscriptionCase.destroy_all()
      end

      it 'returns all items paginated' do
        get '/esp/user_subscription_cases', params: { namecase: 'tonyvsdani' }
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(1)
        expect(json['total']).to eq(1)
      end

    end
  end

  describe 'GET /user_subscription_cases/:id' do
    context 'when the user_subscription_cases exists' do
      it 'returns the detail of the user_subscription_cases' do
        get "/esp/user_subscription_cases/#{user_subscription_cases_id}"

        expect(response).to have_http_status(200)
        expect(json['resource']).to eq(user_subscription_cases_id.to_s)
      end
    end

    context 'when the user_subscription_cases that not exist' do
      let(:user_subscription_cases_id) { 2 }

      it 'returns status code 404' do
        get "/esp/user_subscription_cases/#{user_subscription_cases_id}"

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get "/esp/user_subscription_cases/#{user_subscription_cases_id}"
        expect(response.body).to match(/Document\(s\) not found. When calling Esp::UserSubscriptionCase/)
      end
    end
  end


  describe 'POST /user_subscription_cases' do
    context 'when the request is valid' do
      it 'creates a user_subscription_case' do
        valid_attributes = {
          namecase: 'tonetti',
          summary: "caso de tonetti",
          documents: ['TOL1','TOL2','TOL3'],
          annotations: ['TOL1','TOL3'],
          user_subscription_id: 1,
          folderContent: "[ { 'type' : 'folder', 'name' : 'Pruebas incriminatorias', 'id' : '111', 'children' : [] }]"
        }

        post '/esp/user_subscription_cases', params: valid_attributes
        expect(response).to have_http_status(201)
        expect(json['object']['namecase']).to eq('tonetti')
        expect(json['object']['summary']).to eq('caso de tonetti')
        expect(json['object']['id']).to_not be_nil
        expect(json['object']['id'].is_a?(String)).to eq(true)
        expect(json['object']['created_at']).to_not be_nil
        expect(json['object']['updated_at']).to_not be_nil
        expect(json['object']['documents'].size).to eq(3)
        expect(json['object']['annotations'].size).to eq(2)
        expect(json['object']['folderContent']).to eq("[ { 'type' : 'folder', 'name' : 'Pruebas incriminatorias', 'id' : '111', 'children' : [] }]")
      end
    end
  end

  describe 'PUT /user_subscription_cases/:id' do
    let(:user_subscription_cases_update) { create(:esp_user_subscription_case) }
    let(:user_subscription_cases_update_id) { user_subscription_cases_update.id }
    let(:valid_attributes) { { namecase: 'tonetti_update', annotations:['TOL2'], documents: ['TOL2','TOL3'], summary: "update de tonetti", folderContent:"", downloadUrl:"www.downloadUrl.com", downloadUrlDate:DateTime.now}}

    context 'when the user exists' do
      before { put "/esp/user_subscription_cases/#{user_subscription_cases_update_id}", params: valid_attributes }
      it 'updates the user_subscription_cases with new params' do
        expect(json['object']['namecase']).to eq('tonetti_update')
        expect(json['object']['summary']).to eq('update de tonetti')
        expect(json['object']['documents'].size).to eq(2)
        expect(json['object']['annotations'].size).to eq(1)
        expect(json['object']['annotations'][0]).to eq('TOL2')
        expect(json['object']['folderContent']).to eq("")
        expect(json['object']['downloadUrl']).to eq("www.downloadUrl.com")
        expect(json['object']['downloadUrlDate']).to_not be_nil
       
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

    end

    context 'when the user_subscription_cases does not exist' do
      it 'responds with 404 if user_subscription_cases does not exist' do
        user_subscription_cases_update_id = 2
        put "/esp/user_subscription_cases/#{user_subscription_cases_update_id}", params: valid_attributes

        expect(response).to have_http_status(404)
      end
    end

  end

  describe 'DELETE /user_subscription_cases/:id' do
    let!(:user_subscription_cases_delete) { create(:esp_user_subscription_case) }
    let(:user_subscription_cases_delete_id) { user_subscription_cases_delete.id }

    context 'when delete user completed' do
      it 'returns status code 204' do
        delete "/esp/user_subscription_cases/#{user_subscription_cases_delete_id}"
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'search all cases by user_subscription' do
    let!(:subsystem) { Esp::Subsystem.where(:id => 0).first || create(:subsystem, name: 'Another Subsystem', id: 0)}
    let!(:user_subscription1) { create(:user, :with_subscriptions) }
    let!(:user_subscription_cases_by_user_subscription) { create_list(:esp_user_subscription_case, 2, :namecase => 'pruebaporid', :user_subscription_id => user_subscription1.id) }

    context 'when user_subscription has cases' do

      before(:context) do
        Esp::UserSubscriptionCase.destroy_all()
        Esp::UserSubscription.destroy_all()
      end

      it 'return cases' do
        cases_by_user_subscription = Esp::UserSubscriptionCase.by_user_subscription_id(user_subscription1.id).to_a
        expect(cases_by_user_subscription[0]['namecase']).to eq('pruebaporid')
        expect(cases_by_user_subscription.size).to eq(2)
      end

      it 'return empty' do
        cases_by_user_subscription = Esp::UserSubscriptionCase.by_user_subscription_id(01234).to_a
        expect(cases_by_user_subscription.size).to eq(0)
      end

    end
  end

  describe 'search all cases by folderContent' do
    let!(:subsystem) { Esp::Subsystem.where(:id => 0).first || create(:subsystem, name: 'Another Subsystem', id: 0)}
    let!(:user_subscription1) { create(:user, :with_subscriptions) }
    let!(:user_subscription_cases_by_user_subscription) { create_list(:esp_user_subscription_case, 2, :folderContent => '[{"type":doc,"idTol":75868}]',:namecase => 'pruebaporfoldercontent', :user_subscription_id => user_subscription1.id) }

    context 'when user_subscription has cases' do

      before(:context) do
        Esp::UserSubscriptionCase.destroy_all()
        Esp::UserSubscription.destroy_all()
      end

      it 'return cases' do
        cases_by_user_subscription = Esp::UserSubscriptionCase.by_folderContent('"idTol":75868').to_a
        expect(cases_by_user_subscription[0]['namecase']).to eq('pruebaporfoldercontent')
        expect(cases_by_user_subscription.size).to eq(2)
      end

      it 'return empty' do
        cases_by_user_subscription = Esp::UserSubscriptionCase.by_folderContent('"idTol":85868').to_a
        expect(cases_by_user_subscription.size).to eq(0)
      end

    end
  end

  def stub_foro_requests
    allow(Esp::Foro).to receive(:new)
  end

end
