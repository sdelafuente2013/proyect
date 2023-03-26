require 'rails_helper'

describe User::SendFullDataJob do
  let(:subsystem) { create(:subsystem, id: 0) }
  let(:user) { create(:user, subsystem: subsystem) }

  before { allow(Esp::Foro).to receive(:new) }

  describe "enqueuing" do
    subject { described_class.perform_later(user: user) }

    it do
      expect { subject }.to have_enqueued_job.with(user: user).on_queue("mailers").at(:no_wait)
    end
  end

  describe "execution" do
    let(:url) { "http://www.example.com" }

    subject { described_class.perform_now(user: user, user_subscription: user_subscription) }

    context "with user_subscription" do
      let(:user_subscription) { create(:user_subscription, user: user) }
      let(:base_url) { "http://www.example.com/base" }

      before do
        allow(UserSubscription::GenerateResetPasswordUrl).to receive(:call).and_return(url)
        allow(user_subscription).to receive(:change_password_base_url).and_return base_url
      end

      it "calls generate reset password url service" do
        subject

        expect(UserSubscription::GenerateResetPasswordUrl)
          .to have_received(:call)
          .with(user_subscription, base_url)
      end

      it do
        expect { subject }
          .to have_enqueued_mail(UserMailer, :email_data_full)
          .with(user: user, user_subscription: user_subscription, reset_password_url: url)
      end
    end

    context "without user_subscription" do
      let(:user_subscription) { nil }

      before do
        allow(UserSubscription::GenerateResetPasswordUrl).to receive(:call).and_return(url)
      end

      it "calls generate reset password url service" do
        expect(UserSubscription::GenerateResetPasswordUrl).not_to receive(:call)

        subject
      end

      it do
        expect { subject }
          .to have_enqueued_mail(UserMailer, :email_data_full)
          .with(user: user, user_subscription: nil, reset_password_url: nil)
      end
    end
  end
end
