require 'rails_helper'

module AlertCreationHelper
  extend ActiveSupport::Concern
  included do
    before do
      stub_requests
    end

    let(:alert_params) { { app_id: app_id, alertable_id: user_subscription.id , document_id: 1, document_tolgeo: 'esp' } }
    let(:alert_creation) { post "/#{tolgeo}/document_alerts", params:alert_params }
    let(:alert_creation_response) { json['object'] }
    let(:alert_class) { Objects.tolgeo_model_class(tolgeo, 'document_alert') }
    let(:alert_found) { alert_class.find_alert(alert_params) }
    let(:alert_found_attrs) { alert_found.as_json.symbolize_keys }
  end
end

RSpec.shared_examples 'can manage alert creation when no alerted document in app with user subscription' do
  include AlertCreationHelper

  it 'returns result ok' do
    alert_creation
    expect(alert_creation_response['email']).to eq user_subscription.perusuid
  end

  it 'returns status code 200' do
   alert_creation
   expect(response).to have_http_status(:created)
  end

  it 'expect new alert created' do
    expect{ alert_creation }.to change{ alert_class.count }.by(1)
  end

  it 'expect new alert created found' do
    alert_creation
    expect( alert_found_attrs ).to include alert_params
  end

end

RSpec.shared_examples 'can manage alert creation when previous alerted document in app with user subscription' do
  include AlertCreationHelper

  before do
    alert_creation
  end

  it 'returns result ok' do
    alert_creation
    expect(alert_creation_response['email']).to eq user_subscription.perusuid
  end

  it 'returns status code 200' do
   alert_creation
   expect(response).to have_http_status(:created)
  end

  it 'expect no new alert created' do
    expect{ alert_creation }.to change{ alert_class.count }.by(0)
  end

end

RSpec.shared_examples 'can manage alert creation when same alerted document and user subscription but other app' do
  include AlertCreationHelper

  let(:other_app_id) { 'fff' }

  before do
    expect{
      post "/#{tolgeo}/document_alerts", params:alert_params.merge(app_id: other_app_id)
     }.to change{ alert_class.count }.by(1)
  end

  it 'returns result ok' do
    alert_creation
    expect(alert_creation_response['email']).to eq user_subscription.perusuid
  end

  it 'returns status code 200' do
   alert_creation
   expect(response).to have_http_status(:created)
  end

  it 'expect new alert created' do
    expect{ alert_creation }.to change{ alert_class.count }.by(1)
  end

  it 'expect new alert created found' do
    alert_creation
    expect( alert_found_attrs ).to include alert_params
  end

end

describe "Alert creation with user subscription", :type => :request do

  context 'in mex' do
    let!(:user_subscription) { create(:user_subscription_mex, subsystem: create(:subsystem_mex)) }
    let(:tolgeo) { 'mex' }
    let(:app_id) { 'tolmex' }

    it_behaves_like 'can manage alert creation when no alerted document in app with user subscription'
    it_behaves_like 'can manage alert creation when previous alerted document in app with user subscription'
    it_behaves_like 'can manage alert creation when same alerted document and user subscription but other app'

    context 'with alert users email param blank' do
      let(:alert_params) { { app_id: app_id, alertable_id: user_subscription.id , document_id: 2, document_tolgeo: 'esp', email:'' } }
      it_behaves_like 'can manage alert creation when no alerted document in app with user subscription'
    end
  end

  context 'in esp' do
    let!(:user_subscription) { create(:user_subscription, subsystem: create(:subsystem)) }
    let(:tolgeo) { 'esp' }
    let(:app_id) { 'tol' }

    it_behaves_like 'can manage alert creation when no alerted document in app with user subscription'
    it_behaves_like 'can manage alert creation when previous alerted document in app with user subscription'
    it_behaves_like 'can manage alert creation when same alerted document and user subscription but other app'

    context 'with alert users email param blank' do
      let(:alert_params) { { app_id: app_id, alertable_id: user_subscription.id , document_id: 2, document_tolgeo: 'esp', email:'' } }
      it_behaves_like 'can manage alert creation when no alerted document in app with user subscription'
    end

  end

  context 'in latam' do
    let!(:user_subscription) { create(:user_subscription_latam, subsystem: create(:subsystem_latam)) }
    let(:tolgeo) { 'latam' }
    let(:app_id) { 'latam' }

    it_behaves_like 'can manage alert creation when no alerted document in app with user subscription'
    it_behaves_like 'can manage alert creation when previous alerted document in app with user subscription'
    it_behaves_like 'can manage alert creation when same alerted document and user subscription but other app'

    context 'with alert users email param blank' do
      let(:alert_params) { { app_id: app_id, alertable_id: user_subscription.id , document_id: 2, document_tolgeo: 'esp', email:'' } }
      it_behaves_like 'can manage alert creation when no alerted document in app with user subscription'
    end

  end

end
