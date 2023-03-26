require "rails_helper"

shared_examples "user subscription password management" do
  describe '#generate_hashed_password' do
    let(:user_subscription) { build_stubbed :user_subscription }

    subject { user_subscription.generate_hashed_password(password, 'saladin') }

    context "with right password" do
      let(:password) { 'thisismypass' }

      it 'is equal to a correct hashed password' do
        is_expected.to eq '04fe10105d8f2dbe28272a4609f06facaf8d7dd171311d87f40208ef1fb41e0a'
      end
    end

    context "with wrong password" do
      let(:password) { 'thisisnotmypass' }

      it 'is not equal to a correct hashed password' do
        is_expected.not_to eq '04fe10105d8f2dbe28272a4609f06facaf8d7dd171311d87f40208ef1fb41e0a'
      end
    end
  end

  describe '#generate_hashed_md5_password' do
    let(:user_subscription) { build_stubbed :user_subscription }

    subject { user_subscription.generate_hashed_md5_password( password,'saladin' ) }

    context "with right password" do
      let(:password) { 'thisismypass' }

      it 'is equal to  a correct MD5 password' do
        is_expected.to eq 'ac157f9145c595ebe1711a257bc18a5081f751ff7348e097a79e0ac98f7bc26c'
      end
    end

    context "with wrong password" do
      let(:password) { 'thisisnotmypass' }

      it 'is not equal to  a correct MD5 password' do
        is_expected.not_to eq 'notmd5encrypted'
      end
    end

  end

  describe '#generate_password_salt' do
    let!(:user_subscription) { build_stubbed :user_subscription }

    subject { user_subscription.generate_password_salt }

    before { allow(SecureRandom).to receive(:base64).and_return "foo" }

    it "calls SecureRandom" do
      subject

      expect(SecureRandom)
        .to have_received(:base64)
        .with(UserSubscription::PasswordManagementConcern::SALT_BYTES)
    end

    it "returns the right value" do
      is_expected.to eq "foo"
    end
  end

  describe "#change_password_base_url" do
    let(:subsystem) { create(:subsystem, id: 0) }
    let(:user_subscription) { build_stubbed :user_subscription, subid: 0 }
    subject { user_subscription.change_password_base_url }

    it "returns the right value" do
      is_expected.to eq "https://www.tirantonline.com/base/tol/user_subscriptions/password_changes/new"
    end
  end
end
