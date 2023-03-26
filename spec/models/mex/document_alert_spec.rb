require 'rails_helper'

RSpec.describe Mex::DocumentAlert, type: :model do

  let(:alert) { build(:document_alert_mex) }

  it "is instantiable" do
    expect { alert = Mex::DocumentAlert.new }.not_to raise_error
  end

  it "has a valid factory" do
    expect(alert).to be_valid
  end

  describe "ActiveModel validations" do
    it { should belong_to(:alertable) }
    it { expect(alert).to validate_presence_of(:document_id) }
  end

  it 'includes extended attributes' do
    expect( build(:document_alert_mex).as_json ).to include( 'tolgeo' => 'mex' )
    expect( build(:document_alert_mex).as_json ).to include( 'sk' )
    expect( build(:document_alert_mex).as_json ).to include( 'dsk' )
    expect( build(:document_alert_mex).as_json ).to include( 'email' )
  end

  describe '#scopes' do

    describe '#by_app_id' do
      before do
        create(:document_alert_mex, app_id:'tolmex')
        create(:document_alert_mex, app_id:'tolmex-1')
        create(:document_alert_mex, app_id:'tolmex-2')
        create(:document_alert_mex, app_id:'tolmex')
      end

      it 'finds all alerts when app_id blank' do
        expect(Mex::DocumentAlert.by_app_id(nil).size).to eq 4
      end

      it 'filter alerts when app_id not blank' do
        expect(Mex::DocumentAlert.by_app_id('tolmex').size).to eq 2
      end
    end

    describe '#by_docid' do
      before do
        create(:document_alert_mex)
        create(:document_alert_mex)
        create(:document_alert_mex, document_id:10)
        create(:document_alert_mex, document_id:10)
      end

      it 'finds all alerts when docid blank' do
        expect(Mex::DocumentAlert.by_docid(nil).size).to eq 4
      end

      it 'filter alerts when docid not blank' do
        expect(Mex::DocumentAlert.by_docid(10).size).to eq 2
      end
    end


    describe '#by_alert_date_gt' do
      before do
        create(:document_alert_mex, alert_date: 7.days.ago)
        create(:document_alert_mex, alert_date: 3.days.ago)
        create(:document_alert_mex, alert_date: 2.days.ago)
        create(:document_alert_mex, alert_date: 1.days.ago)
      end

      it 'finds all alerts when alert_date blank' do
        expect(Mex::DocumentAlert.by_alert_date_gt(nil).size).to eq 4
      end

      it 'filter alerts greather than alert_date' do
        expect(Mex::DocumentAlert.by_alert_date_gt(2.days.ago).size).to eq 2
      end
    end
  end

  describe "#find_alert" do

    context "with user subscription alert" do
      before do
        stub_requests
      end

      let!(:subsystem) { create(:subsystem_mex, :id => 0) }
      let!(:alert) { create(:user_subscription_alert_mex) }

      let(:alert_to_find) { Mex::DocumentAlert.find_alert(app_id: alert.app_id,
                                       alertable_id: alert.alertable.subscriptionid,
                                       document_id: alert.document_id)
      }

      it {

        expect(alert_to_find).to eq alert }
    end

  end

  describe "#create_with_alert_user" do

    let(:app_id)      { 'tolmex' }
    let(:email)       { 'test1@test.com' }
    let(:document_id) { 10 }

    context "It is a subscription alert" do
      before do
        stub_requests
      end

      let!(:subsystem) { create(:subsystem_mex, :id => 0) }
      let(:user_subscription){ create(:user_subscription_mex, perusuid: email)}
      let(:alert_params) { { app_id:app_id, alertable_id: user_subscription.id , document_id: document_id } }
      let!(:new_alert) { Mex::DocumentAlert.create_with_alert_user alert_params }
      let(:alert_to_find) { Mex::DocumentAlert.find_alert alert_params }

      it { expect(alert_to_find).to eq new_alert }
      it { expect(alert_to_find.alertable.perusuid).to eq email }
      it { expect(alert_to_find.email).to eq email }
    end

  end
end
