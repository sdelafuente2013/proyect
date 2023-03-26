require 'rails_helper'

describe "Alert deleting", :type => :request do

  before do
    stub_requests
    create(:subsystem, :id => 0)
  end


  context "Alert already exists" do
    let!(:alert) { create(:document_alert)}

    describe 'delete by id' do
      before do
        delete "/esp/document_alerts/#{alert.id}"
      end

      it 'returns no_content' do
        expect(response).to have_http_status(204)
      end

      it 'expects Alert deleted' do
        expect { Esp::DocumentAlert.find(alert.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end


    describe 'delete by unique alternative keys' do
      let(:user_subscription){ create(:user_subscription)}
      let(:alert) { create(:user_subscription_alert, alertable: user_subscription) }

      before do
        delete "/esp/document_alerts", params: { app_id:alert.app_id,
                                        document_id: alert.document_id,
                                        document_tolgeo: alert.document_tolgeo,
                                        alertable_id: alert.alertable_id }
      end

      it 'returns not_content' do
        expect(response).to have_http_status(204)
      end

      it 'expects Alert deleted' do
        expect { Esp::DocumentAlert.find(alert.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

  end

end
