require 'rails_helper'

describe UserSubscription::SendMail do
  let(:user_subscription) { build_stubbed :user_subscription }
  let(:email_type) { "email_user_subscription_passwd" }
  let(:params) do
    {
      user_subscription_id: user_subscription.id,
      tolgeo: 'esp'
    }
  end

  before do
    allow(Esp::UserSubscription)
      .to receive(:find)
      .with(user_subscription.id)
      .and_return user_subscription
    allow(Esp::UserSubscription)
      .to receive(:find)
      .with(user_subscription.id.to_s)
      .and_return user_subscription
  end

  subject { described_class.call!(email_type, params) }

  it do
    expect { subject }
      .to have_enqueued_job(UserSubscription::SendAccessDataJob)
      .with( { user_subscription: user_subscription } )
  end
end
