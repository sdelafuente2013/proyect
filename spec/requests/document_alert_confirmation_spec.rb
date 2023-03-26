require 'rails_helper'

describe "Alert confirm", :type => :request do

  context "New Alert" do
    let(:alert_params) { { app_id:'boc', email: 'test@tirant.com', document_id: 1 , document_tolgeo: 'esp' } }

    before do
      post '/esp/document_alerts', params:alert_params
    end

    it 'returns result ok' do
      expect(json['object']['email']).to eq alert_params[:email]
    end

    it 'returns and user id ' do
      expect(json['object']['alertable_id']).to be_an(Numeric)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:created)
    end

    it 'Creates an Alert' do
      count = Esp::DocumentAlert.count
      expect(count).to eq(1)

      alert = Esp::DocumentAlert.find_alert(alert_params)
      expect(alert.as_json.symbolize_keys).to include alert_params
    end

    context 'with subscriptionid params blank' do
      let(:alert_params) { { app_id:'boc', email: 'test@tirant.com', document_id: 2 , document_tolgeo: 'esp' , alertable_id:''} }
    end

    it 'returns result ok' do
      expect(json['object']['email']).to eq alert_params[:email]
    end

  end

  context "Alert already exists" do
    let!(:existing_user) { create(:alert_user) }
    let!(:existing_alert) { create(:document_alert, alertable: existing_user) }
    let(:alert_params) { existing_alert.as_json.symbolize_keys.slice(:app_id,:email,:document_id,:document_tolgeo) }

    before do
      post '/esp/document_alerts', params: alert_params
    end

    it 'returns the existing alert' do
      expect(json['object']['id']).to eq existing_alert.id
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:created)
    end

    it 'Does not create a new Alert' do
      count = Esp::DocumentAlert.by_email(alert_params[:email]).
                    by_app_id(alert_params[:app_id]).
                    by_docid(alert_params[:document_id]).count

      expect(count).to eq(1)
    end
  end


  context "Alert already exists in other app_id" do
    let(:app_id) { 'fff' }
    let(:alert_params) { { app_id:app_id, email: 'test@tirant.com', document_id: 1, document_tolgeo: 'esp' } }

    let(:existing_app_id) { 'tol' }
    let!(:existing_user)   { create(:alert_user, app_id:existing_app_id, email: alert_params[:email]) }
    let!(:existing_alert)  { create(:document_alert,      app_id:existing_app_id,
                                                 alertable: existing_user,
                                                 document_id: alert_params[:document_id],
                                                 document_tolgeo: alert_params[:document_tolgeo]) }

    before do
      post '/esp/document_alerts', params: alert_params
    end

    it 'returns result ok' do
      expect(json['object']['email']).to eq alert_params[:email]
    end

    it 'returns and user id ' do
      expect(json['object']['alertable_id']).to be_an(Numeric)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:created)
    end

    it 'expect same mail with 2 alerts' do
      count = Esp::DocumentAlert.by_email(alert_params[:email]).
                    by_docid(alert_params[:document_id]).count

      expect(count).to eq(2)
    end

    it { expect(Esp::DocumentAlert.find_alert(alert_params)).to_not be_nil }
  end



  context "New Alert with invalid attributes" do
    let(:alert_params) { Esp::DocumentAlert.new.as_json }

    before do
      post '/esp/document_alerts', params:alert_params
    end

    it 'returns result empty' do
      expect(json['message']).to_not be_empty
    end

    it 'returns status unprocessable_entity' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'doesn''t create alert' do
      count = Esp::DocumentAlert.count
      expect(count).to eq(0)
    end
  end

end
