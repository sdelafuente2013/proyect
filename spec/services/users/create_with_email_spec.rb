require "rails_helper"

describe Users::CreateWithEmail do
  let(:user) { create(:user) }

  subject do
    described_class
      .call(
        email,
        perso_account,
        user
      )
  end

  describe 'when mail option is selected' do
    let(:perso_account) { false }
    let(:email) { true }

    it 'enques send full data job' do
      expect { subject }
      .to have_enqueued_job( User::SendFullDataJob)
      .with(user: user, user_subscription: nil)
      .on_queue("mailers")
    end

    describe 'but user personalization is selected' do
      let(:perso_account) { true }
      it 'does not enques full data job' do
        expect {
          subject
        }.to change {
          ActiveJob::Base.queue_adapter.enqueued_jobs.count
        }.by 0
      end
    end
  end

  describe 'when mail option is NOT selected' do
    let(:email) { false }
    let(:perso_account) { true }
    it 'does not enques full data job' do 
      expect {
        subject
      }.to change {
        ActiveJob::Base.queue_adapter.enqueued_jobs.count
      }.by 0
    end
  end
end
