require 'rails_helper'

RSpec.describe Esp::DocumentAlert, type: :model do

  let(:alert) { build(:document_alert) }

  it "is instantiable" do
    expect { alert = Esp::DocumentAlert.new }.not_to raise_error
  end

  it "has a valid factory" do
    expect(alert).to be_valid
  end

  describe "ActiveModel validations" do
    it { should belong_to(:alertable) }
    it { expect(alert).to validate_presence_of(:document_id) }
  end

  it 'includes extended attributes' do
    expect( build(:boc_document_alert) ).to have_attributes( tolgeo:'esp' )
  end

  it 'includes extended in json' do
    expect( build(:boc_document_alert).as_json ).to include( 'tolgeo' => 'esp' )
    expect( build(:boc_document_alert).as_json ).to include( 'sk' )
    expect( build(:boc_document_alert).as_json ).to include( 'dsk' )
    expect( build(:boc_document_alert).as_json ).to include( 'email' )
  end

  describe '#locale' do
    context 'alert for public user' do
      let(:alert) { build(:document_alert) }
      it { expect( alert.locale ).to be_nil }
      it { expect( alert.as_json ).to include( 'locale' => nil ) }
    end

    context 'alert for subscriber user' do
      before do
        stub_requests
      end

      let!(:subsystem) { create(:subsystem, :id => 0) }
      let(:alert_params) { { app_id:'boc', alertable_id: user_subscription.id , document_id: 1000, document_tolgeo: 'esp' } }
      let(:alert) { Esp::DocumentAlert.create_with_alert_user alert_params }

      context 'without lang value' do
        let(:user_subscription){ create(:user_subscription, perusuid: 'prueba@tirant.com')}
        it { expect( alert.locale ).to be_nil }
        it { expect( alert.as_json ).to include( 'locale' => nil ) }
      end

      context 'with lang value' do
        let(:user_subscription){ create(:user_subscription, perusuid: 'prueba@tirant.com', lang: 'es')}
        it { expect( alert.locale ).to eq 'es' }
        it { expect( alert.as_json ).to include( 'locale' => 'es' ) }

        context 'with lang value esp' do
          let(:user_subscription){ create(:user_subscription, perusuid: 'prueba@tirant.com', lang: 'esp')}
          it { expect( alert.locale ).to eq 'es' }
          it { expect( alert.as_json ).to include( 'locale' => 'es' ) }
        end

        context 'with lang value cat' do
          let(:user_subscription){ create(:user_subscription, perusuid: 'prueba@tirant.com', lang: 'cat')}
          it { expect( alert.locale ).to eq 'ca' }
          it { expect( alert.as_json ).to include( 'locale' => 'ca' ) }
        end
      end

    end


  end

  describe '#scopes' do

    describe '#by_app_id' do
      before do
        create(:document_alert, app_id:'tol')
        create(:document_alert, app_id:'boc')
        create(:document_alert, app_id:'boc')
        create(:document_alert, app_id:'boa')
      end

      it 'finds all alerts when app_id blank' do
        expect(Esp::DocumentAlert.by_app_id(nil).size).to eq 4
      end

      it 'filter alerts when app_id not blank' do
        expect(Esp::DocumentAlert.by_app_id('boc').size).to eq 2
      end
    end

    describe '#by_docid' do
      before do
        create(:document_alert)
        create(:document_alert)
        create(:document_alert, document_id:10)
        create(:document_alert, document_id:10)
      end

      it 'finds all alerts when docid blank' do
        expect(Esp::DocumentAlert.by_docid(nil).size).to eq 4
      end

      it 'filter alerts when docid not blank' do
        expect(Esp::DocumentAlert.by_docid(10).size).to eq 2
      end
    end

    describe '#by_email' do
      before do
        create(:document_alert)
        create(:document_alert)
        alert_user = create( :alert_user, email:'tony@example.org')
        create(:document_alert, alertable: alert_user)
        create(:document_alert, alertable: alert_user)
      end

      it 'finds all alerts when email blank' do
        expect(Esp::DocumentAlert.by_email(nil).size).to eq 4
      end

      it 'filter alerts when email not blank' do
        expect(Esp::DocumentAlert.by_email('tony@example.org').size).to eq 2
      end
    end

    describe '#by_alert_date_gt' do
      before do
        create(:document_alert, alert_date: 7.days.ago)
        create(:document_alert, alert_date: 3.days.ago)
        create(:document_alert, alert_date: 2.days.ago)
        create(:document_alert, alert_date: 1.days.ago)
      end

      it 'finds all alerts when alert_date blank' do
        expect(Esp::DocumentAlert.by_alert_date_gt(nil).size).to eq 4
      end

      it 'filter alerts greather than alert_date' do
        expect(Esp::DocumentAlert.by_alert_date_gt(2.days.ago).size).to eq 2
      end
    end
  end

  describe "#find_alert" do

    context "with email alert" do
      let!(:alert) { create(:document_alert) }

      let(:alert_to_find) { Esp::DocumentAlert.find_alert(app_id: alert.app_id,
                                       email: alert.alertable.email,
                                       document_id: alert.document_id, document_tolgeo: alert.document_tolgeo)
      }

      it { expect(alert_to_find).to eq alert }
    end

    context "with user subscription alert" do
      before do
        stub_requests
      end

      let!(:subsystem) { create(:subsystem, :id => 0) }
      let!(:alert) { create(:user_subscription_alert) }

      let(:alert_to_find) { Esp::DocumentAlert.find_alert(app_id: alert.app_id,
                                       alertable_id: alert.alertable.subscriptionid,
                                       document_id: alert.document_id, document_tolgeo: alert.document_tolgeo)
      }

      it { expect(alert_to_find).to eq alert }
    end

  end

  describe "#create_with_alert_user" do

    let(:app_id)      { 'tol' }
    let(:email)       { 'test1@test.com' }
    let(:document_id) { 10 }
    let(:document_tolgeo) { 'esp' }

    context "With an email alert" do

      let(:alert_params) { { app_id:app_id, email:email, document_id: document_id, document_tolgeo: document_tolgeo } }
      let(:alert_to_find) { Esp::DocumentAlert.find_alert alert_params }
      let(:alter_users_created) { Esp::AlertUser.where(email: email) }
      let!(:new_alert) { Esp::DocumentAlert.create_with_alert_user alert_params }
      let(:alert_to_find) { Esp::DocumentAlert.find_alert alert_params }

      it { expect(alert_to_find).to eq new_alert }
      it { expect(alert_to_find.alertable.email).to eq email }
      it { expect(alert_to_find.email).to eq email }
      it { expect( alter_users_created.size).to eq 1 }
    end

    context "It is a subscription alert" do
      before do
        stub_requests
      end

      let!(:subsystem) { create(:subsystem, :id => 0) }
      let(:user_subscription){ create(:user_subscription, perusuid: email)}
      let(:alert_params) { { app_id:app_id, alertable_id: user_subscription.id , document_id: document_id, document_tolgeo: document_tolgeo } }
      let!(:new_alert) { Esp::DocumentAlert.create_with_alert_user alert_params }
      let(:alert_to_find) { Esp::DocumentAlert.find_alert alert_params }

      it { expect(alert_to_find).to eq new_alert }
      it { expect(alert_to_find.alertable.perusuid).to eq email }
      it { expect(alert_to_find.email).to eq email }
    end

    context 'when email and subscription with same alertable_id and same document_id' do
      before do
        stub_requests
      end

      let!(:subsystem) { create(:subsystem, :id => 0) }
      let(:user_subscription){ create(:user_subscription, perusuid: 'otro@email.com') }
      let(:subscription_alert_params) { { app_id:app_id, document_id: document_id, document_tolgeo: document_tolgeo,
                                          alertable_id: user_subscription.id ,
                                          alertable_type: user_subscription.class } }
      let!(:subscription_alert) { Esp::DocumentAlert.create subscription_alert_params }


      let(:alert_user) { create( :alert_user, id: user_subscription.id, email:'ningun@email.com') }
      let(:email_alert_params) { { app_id:app_id, document_id: document_id, document_tolgeo: document_tolgeo,
                                   alertable_id: alert_user.id ,
                                   alertable_type: alert_user.class  } }
      let!(:email_alert) { Esp::DocumentAlert.create email_alert_params }

      let(:subscription_alert_to_find) { Esp::DocumentAlert.find_alert( app_id:app_id, document_id: document_id, document_tolgeo: document_tolgeo, alertable_id: user_subscription.id ) }
      let(:email_alert_to_find) { Esp::DocumentAlert.find_alert( app_id:app_id, document_id: document_id, document_tolgeo: document_tolgeo, email: alert_user.email ) }

      it 'should not confuse alerts' do
        expect(subscription_alert_to_find).to_not eq email_alert_to_find
        expect(subscription_alert_to_find.alertable_type).to_not eq email_alert_to_find.alertable_type
        expect(subscription_alert_to_find.email).to_not eq email_alert_to_find.email

        expect(subscription_alert_to_find.alertable_id).to eq email_alert_to_find.alertable_id
        expect(subscription_alert_to_find.document_id).to eq email_alert_to_find.document_id
      end

    end
  end
end
