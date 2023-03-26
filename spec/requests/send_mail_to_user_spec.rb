require 'rails_helper'

describe "Send email to user" do
  let(:email_type) { "foo" }
  let(:user_id) { "11" }
  let(:extra_params) { { foo: "bar" } }
  let(:tolgeo) { "esp" }
  let(:params) do
    {
      email_type: email_type,
      user_id: user_id,
      extra_params: extra_params
    }
  end

  subject { post user_mailers_path(tolgeo), params: params }

  before do
    allow(Users::SendMail).to receive(:call!)

    subject
  end

  it do
    expect(Users::SendMail)
      .to have_received(:call!)
      .with(
        email_type,
        {
          user_id: user_id,
          tolgeo: tolgeo,
          extra_params: extra_params
        }
      )
  end

  it { expect(response).to have_http_status(:ok) }
end
