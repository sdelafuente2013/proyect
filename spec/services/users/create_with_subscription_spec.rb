# frozen_string_literal: true
require "rails_helper"

describe Users::CreateWithSubscription do
  subject do
    described_class
      .call(
       user_params,
       user,
       user.tolgeo
      )
  end

  let(:user) { create(:user) }
  let(:subsystem) { create(:subsystem, id: 0) }
  let(:user_params) do {
    email: "mytestmail@tirant.com",
    password: "miclavesecreta",
    subid: subsystem.id,
    add_perso_account: perso_account,
    has_to_send_welcome_email: email
  }
  end

  before do
    stub_request(:any, "#{ENV["XT_API_BASE_FOROS"]}/crea_usuario.php")
      .with(query: hash_including({}))
  end

  shared_examples "enques send full data job" do
    it do
      expect { subject }
        .to have_enqueued_job(User::SendFullDataJob)
        .on_queue("mailers")
    end
  end

  shared_examples "creates user subscription" do
    it do
      expect { subject }
        .to change { Esp::User.count }.by(1)
    end
  end

  shared_examples "does not enque send full data job" do
    it do
      expect { subject }.to change {
        ActiveJob::Base.queue_adapter.enqueued_jobs.count
      }.by 0
    end
  end

  describe "when mail option is selected" do
    let(:perso_account) { true }
    let(:email) { true }

    include_examples "enques send full data job"
    include_examples "creates user subscription"

    describe "but perso account is not selected" do
      let(:perso_account) { false }

      include_examples "does not enque send full data job"
    end
  end

  describe "when mail option is NOT selected" do
    let(:perso_account) { true }
    let(:email) { false }

    include_examples "does not enque send full data job"
    include_examples "creates user subscription"
  end
end
