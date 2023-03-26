# frozen_string_literal: true

require 'rails_helper'
describe 'User Subscription RFC alerts', type: :request do
  before do
    create(:user_subscription_rfc_alert_mex, id: '1', user_subscription_id: 3, rfc: 'a1',
                                             name: 'alerta 1')
    create(:user_subscription_rfc_alert_mex, id: '2', user_subscription_id: 3, rfc: 'a2',
                                             name: 'alerta 2')
    create(:user_subscription_rfc_alert_mex, id: '3', user_subscription_id: 1, rfc: 'a1',
                                             name: 'alerta uno')
  end

  describe 'GET /user_subscription_rfc_alerts/:id' do
    subject { get user_subscription_rfc_alert_path('mex', id) }

    before { subject }

    context 'with existing alert id' do
      let(:id) { '1' }

      it 'returns ok status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns alert that matches request id' do
        expect(json['object']['id']).to eq('1')
      end

      it 'returns alert name' do
        expect(json['object']['name']).not_to be_empty
      end

      it 'returns alert rfc' do
        expect(json['object']['rfc']).not_to be_empty
      end

      it 'returns alert user subscription id' do
        expect(json['object']['user_subscription_id']).not_to be_blank
      end
    end

    context 'with not existing alert id' do
      let(:id) { '4' }

      it 'returns not found status 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /user_subscription_rfc_alerts/' do
    subject { post user_subscription_rfc_alerts_path('mex', params) }

    before do
      # Mex::UserSubscriptionRfcAlert.delete_all
      subject
    end

    context 'with valid params' do
      let(:params) do
        {
          name: 'alerta 3',
          user_subscription_id: 3,
          rfc: 'a3'
        }
      end

      it 'returns created status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns new alert id' do
        expect(json['object']['id']).not_to be_empty
      end

      it 'saves alert' do
        expect(Mex::UserSubscriptionRfcAlert.find(json['object']['id'])).not_to be_blank
      end
    end
  end

  describe 'GET /user_subscription_rfc_alerts/' do
    subject { get user_subscription_rfc_alerts_path('mex', params) }

    before { subject }

    context 'with user_subscription_id param' do
      let(:params) { { user_subscription_id: 3 } }

      it 'returns only the user_subscription alerts' do
        expect(json['objects'].length).to eq(2)
      end
    end

    context 'with no params' do
      let(:params) { {} }

      it 'returns all alerts' do
        expect(json['objects'].length).to eq(3)
      end
    end
  end

  describe 'PUT /user_subscription_rfc_alerts/:id' do
    subject { put user_subscription_rfc_alert_path('mex', id, params) }

    before { subject }

    let(:params) do
      {
        name: 'alerta nueva',
        rfc: 'a4'
      }
    end

    context 'with existing id' do
      let(:id) { '1' }

      it 'returns ok status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns updated name' do
        expect(json['object']['name']).to eq 'alerta nueva'
      end

      it 'returns updated rfc' do
        expect(json['object']['rfc']).to eq 'a4'
      end

      it 'updates alert' do
        expect(Mex::UserSubscriptionRfcAlert.find(id).name).to eq 'alerta nueva'
      end
    end

    context 'with not existing id' do
      let(:id) { '5' }

      it 'returns not found status 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /user_subscription_rfc_alerts/:id' do
    subject { delete user_subscription_rfc_alert_path('mex', id) }

    before { subject }

    context 'with existing id' do
      let(:id) { '1' }

      it 'returns no content status 204' do
        expect(response).to have_http_status(:no_content)
      end

      it 'deletes alert' do
        expect {
          Mex::UserSubscriptionRfcAlert.find(id)
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context 'with not existing id' do
      let(:id) { '4' }

      it 'returns not found status 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
