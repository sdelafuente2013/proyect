require 'rails_helper'

describe "Send email to user subscriptions" do
  let(:email_type) { "foo" }
  let(:user_subscription_id) { "11" }
  let(:tolgeo) { "esp" }
  let(:params) do
    {
      email_type: email_type,
      user_subscription_id: user_subscription_id
    }
  end

  subject { post user_subscription_mailers_path(tolgeo), params: params }

  before do
    allow(UserSubscription::SendMail).to receive(:call!)

    subject
  end

  it do
    expect(UserSubscription::SendMail)
      .to have_received(:call!)
      .with(
        email_type,
        {
          user_subscription_id: user_subscription_id,
          tolgeo: tolgeo
        }
      )
  end

  it { expect(response).to have_http_status(:ok) }
end
