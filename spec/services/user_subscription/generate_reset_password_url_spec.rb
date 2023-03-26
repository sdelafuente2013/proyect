# frozen_string_literal: true

require "rails_helper"

describe UserSubscription::GenerateResetPasswordUrl do
  subject do
    described_class.call(user_subscription, change_password_url)
  end

  let(:user_subscription) { create(:user_subscription) }
  let(:change_password_url) { "http://www.example.com/wololo" }
  let(:token) { "foo" }
  let(:encrypted_token) { "1c4e4ff984cde8ea5b34cfed8a92dc256babc4bd59c160b34bc34d7ca007415b" }

  before do
    allow(SecureRandom).to receive(:urlsafe_base64).and_return token
  end

  it "adds the token to the user subscription" do
    expect { subject }
      .to change(user_subscription, :reset_password_token)
      .to encrypted_token
  end

  it "sets the reset_password_sent_at" do
    Timecop.freeze

    expect { subject }
      .to change { user_subscription.reset_password_sent_at.to_i }
      .to Time.current.to_i

    Timecop.return
  end

  it "returns the url with the token" do
    is_expected.to eq "#{change_password_url}?token=#{token}"
  end
end
