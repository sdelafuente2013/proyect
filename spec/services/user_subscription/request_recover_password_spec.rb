require "rails_helper"

describe UserSubscription::RequestRecoverPassword do
  let(:user_subscription) { create(:user_subscription) }
  let(:change_password_url) { 'http://www.example.com/wololo' }
  let(:url_with_token) { 'http://www.example.com/wololo?token=1234' }

  subject do
    described_class
      .call(
        user_subscription.user.tolgeo,
        user_subscription.perusuid,
        change_password_url,
        user_subscription.subid
      )

    user_subscription.reload
  end

  before do
    allow(UserSubscription::GenerateResetPasswordUrl)
      .to receive(:call)
      .and_return url_with_token
  end

  it 'calls the generate reset password service' do
    subject

    expect(UserSubscription::GenerateResetPasswordUrl)
      .to have_received(:call)
      .with(user_subscription, change_password_url)
  end

  it 'enqueues the mailer' do
    expect { subject }
      .to have_enqueued_mail(UserSubscriptionMailer, :request_password_recovery)
      .with(
        user_subscription: user_subscription,
        user: user_subscription.user,
        change_password_url: url_with_token
      )
  end
end
