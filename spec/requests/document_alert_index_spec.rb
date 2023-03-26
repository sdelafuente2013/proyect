require 'rails_helper'

describe "Alert show", :type => :request do

  context "Alert already exists" do

    before (:each) do
      stub_requests
      @subsystem ||= create(:subsystem, :id => 0)
    end

    let!(:alert) { create(:user_subscription_alert)}
    let!(:alert_from_other_app_id) do
      create(:user_subscription_alert,
             alertable_id: alert.alertable_id,
             document_id: alert.document_id,
             app_id: 'other_app_id')
    end

    let!(:alert_from_other_doc) do
      create(:user_subscription_alert,
             app_id: alert.app_id,
             alertable_id: alert.alertable_id,
             document_id: alert.document_id + 1)
    end

    describe 'search by document_id, document_tolgeo and subscriptionid' do
      before do
        get "/esp/document_alerts?app_id=#{alert.app_id}&document_id=#{alert.document_id}&document_tolgeo=#{alert.document_tolgeo}&alertable_id=#{alert.alertable.subscriptionid}"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a list of size 1' do
        expect(JSON.parse(response.body)['objects'].size).to eq 1
      end

      it 'returns a total of  1' do
        expect(JSON.parse(response.body)['total']).to eq 1
      end

      it 'returns the alert' do
        expect(JSON.parse(response.body)['objects'][0]['id']).to eq alert.id
      end

    end

    describe 'alert return info' do

      let(:first_alert_object) { JSON.parse(response.body)['objects'][0] }
      before do
        get "/esp/document_alerts"
      end

      it 'returns alert attributes' do
        expect(first_alert_object['id']).to_not be_nil
        expect(first_alert_object['app_id']).to_not be_nil
        expect(first_alert_object['document_id']).to_not be_nil
        expect(first_alert_object['document_tolgeo']).to_not be_nil
        expect(first_alert_object['alert_date']).to_not be_nil
        expect(first_alert_object['alertable_id']).to_not be_nil
        expect(first_alert_object['alertable_type']).to_not be_nil
        expect(first_alert_object['tolgeo']).to_not be_nil
        expect(first_alert_object['email']).to_not be_nil
        expect(first_alert_object['sk']).to_not be_nil
        expect(first_alert_object['dsk']).to_not be_nil
        expect(first_alert_object['created_at']).to_not be_nil
      end

    end

    describe 'search by document_id, subscriptionid but different document_tolgeo' do
      before do
        document_tolgeo_search = "PREFIX#{alert.document_tolgeo}"
        get "/esp/document_alerts?app_id=#{alert.app_id}&document_id=#{alert.document_id}&document_tolgeo=#{document_tolgeo_search}&alertable_id=#{alert.alertable.subscriptionid}"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a list of size 0' do
        expect(JSON.parse(response.body)['objects'].size).to eq 0
      end

      it 'returns a total of  0' do
        expect(JSON.parse(response.body)['total']).to eq 0
      end

    end

    describe 'search by app_id and subscriptionid' do
      before do
        get "/esp/document_alerts?app_id=#{alert.app_id}&alertable_id=#{alert.alertable.subscriptionid}"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a list of size 2' do
        expect(JSON.parse(response.body)['objects'].size).to eq 2
      end
    end

  end

  context "More alerts than one page" do

    before do
      stub_requests
      @subsystem ||= create(:subsystem, :id => 0)
      @first_alert = create(:user_subscription_alert)
      (1..8).to_a.each do |index|
        create(:user_subscription_alert,
               alertable_id: @first_alert.alertable_id,
               document_id: @first_alert.document_id+index,
               app_id: @first_alert.app_id)
      end


    end

    describe 'searching first page ' do
      before do
        get "/esp/document_alerts?sort=id&order=desc&per=5&page=1&app_id=#{@first_alert.app_id}&alertable_id=#{@first_alert.alertable.subscriptionid}"
      end

      it 'returns a list of size 5' do
        expect(JSON.parse(response.body)['objects'].size).to eq 5
      end

      it 'returns a list ordered by id desc' do
        alert_ids = JSON.parse(response.body)['objects'].collect{|alert| alert['id']}
        sorted_alert_ids = alert_ids.sort.reverse
        expect(alert_ids).to eq sorted_alert_ids
      end
    end

    describe 'searching second page ' do
      before do
        get "/esp/document_alerts?sort=id&order=desc&per=5&page=2&app_id=#{@first_alert.app_id}&alertable_id=#{@first_alert.alertable.subscriptionid}"
      end

      it 'returns a list of size 4' do
        expect(JSON.parse(response.body)['objects'].size).to eq 4
      end
    end

    describe 'searching third page ' do
      before do
        get "/esp/document_alerts?sort=id&order=desc&per=5&page=3&app_id=#{@first_alert.app_id}&alertable_id=#{@first_alert.alertable.subscriptionid}"
      end

      it 'returns a list of size 0' do
        expect(JSON.parse(response.body)['objects'].size).to eq 0
      end
    end

  end
end
