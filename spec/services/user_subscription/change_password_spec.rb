# frozen_string_literal: true

require "rails_helper"

describe UserSubscription::ChangePassword do
  subject do
    described_class.call("esp", token, password)

    user_subscription.reload
  end

  let(:token) { "foo" }
  let(:password) { "12341234" }
  let(:encrypted_token) { "my_encrypt_token" }
  let(:sent_at) { 1.minute.ago }
  let!(:user_subscription) do
    create(
      :user_subscription,
      reset_password_token: encrypted_token,
      reset_password_sent_at: sent_at
    )
  end

  before do
    allow(SecureRandom).to receive(:urlsafe_base64).and_return token
    allow(EncryptToken).to receive(:call).and_return service_token
  end

  context "with a matching token, exists subscription user" do
    let(:service_token) { encrypted_token }

    context "but expired" do
      let(:sent_at) { 1.year.ago }

      it { expect { subject }.to raise_error described_class::InvalidToken }
    end

    context "but without token sent date" do
      let(:sent_at) { nil }

      it { expect { subject }.to raise_error described_class::InvalidToken }
    end

    context "and not expired" do

      describe "updates encrypted password columns" do
        let(:salt) { "foo" }
        let(:encrypted_password) { "bar" }
        let(:password_md5) { "12341234_md5" }
        let(:encrypted_password_md5) { "bar_md5" }

        before do
          allow(SecureRandom).to receive(:base64).with(8).and_return salt

          allow(Digest::SHA2)
            .to receive(:hexdigest)
            .with(salt + password)
            .and_return encrypted_password

          allow(Digest::MD5).to receive(:hexdigest).with(password).and_return password_md5
          allow(Digest::SHA2)
            .to receive(:hexdigest)
            .with(salt + password_md5)
            .and_return encrypted_password_md5
        end

        it { expect { subject }.to change(user_subscription, :password_salt).to salt }
        it do
          expect { subject }
            .to change(user_subscription, :password_digest)
            .to encrypted_password
        end
      end

      it { is_expected.to eq user_subscription }
    end
  end

  context "with a matching token does not exist subscription user" do
    let(:service_token) { "other_encrypted_token" }

    it { expect { subject }.to raise_error described_class::InvalidToken }
  end
end
