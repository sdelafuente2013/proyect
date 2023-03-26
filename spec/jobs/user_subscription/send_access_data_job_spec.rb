require 'rails_helper'

describe UserSubscription::SendAccessDataJob do
  let(:subsystem) { create(:subsystem, id: 0) }
  let(:user_subscription) { create(:user_subscription, subsystem: subsystem) }

  before { allow(Esp::Foro).to receive(:new) }

  describe "enqueuing" do
    subject { described_class.perform_later(user_subscription: user_subscription) }

    it do
      expect { subject }.to have_enqueued_job.with(user_subscription: user_subscription).on_queue("default").at(:no_wait)
    end
  end

  xdescribe "execution" do
    let(:url) { "http://www.example.com" }
    let(:base_url) { "http://www.example.com/base" }

    subject { described_class.perform_now(user: user, user_subscription: user_subscription) }

    context "with user_subscription" do
      let(:user_subscription) { create(:user_subscription, user: user) }

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
