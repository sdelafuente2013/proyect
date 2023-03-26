require 'rails_helper'

describe "Alert update", :type => :request do

  before do
    stub_requests
    create(:subsystem, :id => 0)
  end

  let!(:alert) { create(:document_alert)}
  let(:alert_params) { { alert_date: '2018-01-03' , alertable_id: 9999, email:'tony@mafia.es', document_id:99999999, document_tolgeo:'foo' } }
  let(:alert_update) { put "/#{alert.tolgeo}/document_alerts/#{alert.id}", params:alert_params }
  let(:alert_update_response) { json['object'] }


  it 'updates only alert_date' do
    alert_update
    alert.reload

    expect(Date.parse(alert_update_response['alert_date']).strftime('%F')).to eq alert_params[:alert_date]

    expect(alert_update_response['alertable_id']).to_not    eq alert_params[:alertable_id]
    expect(alert_update_response['email']).to_not           eq alert_params[:email]
    expect(alert_update_response['document_id']).to_not     eq alert_params[:document_id]
    expect(alert_update_response['document_tolgeo']).to_not eq alert_params[:document_tolgeo]

    expect(alert_update_response['alertable_id']).to        eq alert.alertable_id
    expect(alert_update_response['email']).to               eq alert.email
    expect(alert_update_response['document_id']).to         eq alert.document_id
    expect(alert_update_response['document_tolgeo']).to     eq alert.document_tolgeo
  end

end
