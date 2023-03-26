require "rails_helper"

describe UserSubscription::ConfirmUpdateEmail do
  let(:user_subscription) { create(:user_subscription) }
  let(:new_email) { 'minuevocorrein@tirant.com' }
  let(:update_email_url) { 'http://www.example.com/wololo' }
  let(:user) { create(:user, subid: user_subscription.subid) }

  subject do
    described_class
      .call(
        user_subscription.user.tolgeo,
        new_email,
        user_subscription.perusuid,
        user.id,
        update_email_url
      )

    user_subscription.reload
  end

  it 'enqueues the mailer' do
    expect { subject }
      .to have_enqueued_mail(UserSubscriptionMailer, :confirm_update_email)
      .with(
        current_email: user_subscription.perusuid,
        user_subscription: user_subscription,
        update_email_url: update_email_url,
        user: user,
        new_email: new_email,
        tolgeo: user_subscription.user.tolgeo
      )
  end
end
