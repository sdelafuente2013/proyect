require 'rails_helper'

RSpec.describe Latam::DocumentAlert, type: :model do

  let(:alert) { build(:document_alert_latam) }

  it "is instantiable" do
    expect { alert = Latam::DocumentAlert.new }.not_to raise_error
  end

  it "has a valid factory" do
    expect(alert).to be_valid
  end

  describe "ActiveModel validations" do
    it { should belong_to(:alertable) }
    it { expect(alert).to validate_presence_of(:document_id) }
  end

  it 'includes extended attributes' do
    expect( build(:document_alert_latam).as_json ).to include( 'tolgeo' => 'latam' )
    expect( build(:document_alert_latam).as_json ).to include( 'sk' )
    expect( build(:document_alert_latam).as_json ).to include( 'dsk' )
    expect( build(:document_alert_latam).as_json ).to include( 'email' )
  end

  describe '#scopes' do

    describe '#by_app_id' do
      before do
        create(:document_alert_latam, app_id:'latam')
        create(:document_alert_latam, app_id:'latam-1')
        create(:document_alert_latam, app_id:'latam-2')
        create(:document_alert_latam, app_id:'latam')
      end

      it 'finds all alerts when app_id blank' do
        expect(Latam::DocumentAlert.by_app_id(nil).size).to eq 4
      end

      it 'filter alerts when app_id not blank' do
        expect(Latam::DocumentAlert.by_app_id('latam').size).to eq 2
      end
    end

    describe '#by_docid' do
      before do
        create(:document_alert_latam)
        create(:document_alert_latam)
        create(:document_alert_latam, document_id:10)
        create(:document_alert_latam, document_id:10)
      end

      it 'finds all alerts when docid blank' do
        expect(Latam::DocumentAlert.by_docid(nil).size).to eq 4
      end

      it 'filter alerts when docid not blank' do
        expect(Latam::DocumentAlert.by_docid(10).size).to eq 2
      end
    end


    describe '#by_alert_date_gt' do
      before do
        create(:document_alert_latam, alert_date: 7.days.ago)
        create(:document_alert_latam, alert_date: 3.days.ago)
        create(:document_alert_latam, alert_date: 2.days.ago)
        create(:document_alert_latam, alert_date: 1.days.ago)
      end

      it 'finds all alerts when alert_date blank' do
        expect(Latam::DocumentAlert.by_alert_date_gt(nil).size).to eq 4
      end

      it 'filter alerts greather than alert_date' do
        expect(Latam::DocumentAlert.by_alert_date_gt(2.days.ago).size).to eq 2
      end
    end
  end

  describe "#find_alert" do

    context "with user subscription alert" do
      before do
        stub_requests
      end

      let!(:subsystem) { create(:subsystem_latam, :id => 0) }
      let!(:alert) { create(:user_subscription_alert_latam) }

      let(:alert_to_find) { Latam::DocumentAlert.find_alert(app_id: alert.app_id,
                                       alertable_id: alert.alertable.subscriptionid,
                                       document_id: alert.document_id,
                                       document_tolgeo: alert.document_tolgeo)
      }

      it { expect(alert_to_find).to eq alert }
    end

  end

  describe "#create_with_alert_user" do

    let(:app_id)      { 'tolmex' }
    let(:email)       { 'test1@test.com' }
    let(:document_id) { 10 }
    let(:document_tolgeo) { 'esp' }

    context "It is a subscription alert" do
      before do
        stub_requests
      end

      let!(:subsystem) { create(:subsystem_latam, :id => 0) }
      let(:user_subscription){ create(:user_subscription_latam, perusuid: email)}
      let(:alert_params) { { app_id: app_id,
                             alertable_id: user_subscription.id,
                             document_id: document_id,
                             document_tolgeo: document_tolgeo} }
      let!(:new_alert) { Latam::DocumentAlert.create_with_alert_user alert_params }
      let(:alert_to_find) { Latam::DocumentAlert.find_alert alert_params }

      it { expect(alert_to_find).to eq new_alert }
      it { expect(alert_to_find.alertable.perusuid).to eq email }
      it { expect(alert_to_find.email).to eq email }
    end

  end
end
