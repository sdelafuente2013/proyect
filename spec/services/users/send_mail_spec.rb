require 'rails_helper'

describe Users::SendMail do
  let(:user) { build_stubbed :user }
  let(:extra_params) { { foo: "bar" } }
  let(:params) do
    {
      user_id: user.id,
      tolgeo: user.tolgeo,
      extra_params: extra_params
    }
  end

  subject { described_class.call!(email_type, params) }

  before do
    allow(Esp::User).to receive(:find).with(user.id).and_return user
    allow(Esp::User).to receive(:find).with(user.id.to_s).and_return user
  end

  shared_examples "email_user_passwd" do
    it do
      expect { subject }
        .to have_enqueued_mail(UserMailer, :email_user_passwd)
        .with( { user: user, user_subscription: nil, extra_params: extra_params } )
    end
  end

  shared_examples "email_data_full" do
    it do
      expect { subject }
        .to have_enqueued_job(User::SendFullDataJob)
        .with( { user: user, user_subscription: user_subscription, extra_params: extra_params } )
    end
  end

  shared_examples "email_user_share_document" do
    it do
      expect { subject }
        .to have_enqueued_mail(UserMailer, :email_user_share_document)
        .with( { user: user, user_subscription: user_subscription, extra_params: extra_params } )
    end
  end

  context "when user has not a subscription user with same email" do
    let(:user_subscription) { nil }
    let(:other_user_subscription) { create :user_subscription, user: user }

    describe "for email_user_passwd" do
      let(:email_type) { "email_user_passwd"}

      include_examples "email_user_passwd"
    end

    describe "for email_data_full" do
      let(:email_type) { "email_data_full"}

      include_examples "email_data_full"
    end

    describe "for email_user_share_document" do
      let(:email_type) { "email_user_share_document" }

      include_examples "email_user_share_document"
    end
  end

  context "when user has subscription user with same email" do
    let(:user_subscription) { create :user_subscription, user: user, perusuid: user.email }

    describe "for email_user_passwd" do
      let(:email_type) { "email_user_passwd"}

      include_examples "email_user_passwd"
    end

    describe "for email_data_full" do
      let(:email_type) { "email_data_full"}

      include_examples "email_data_full"
    end

    describe "for email_user_share_document" do
      let(:email_type) { "email_user_share_document" }

      include_examples "email_user_share_document"
    end
  end
end
