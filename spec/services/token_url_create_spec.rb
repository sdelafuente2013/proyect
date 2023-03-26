# frozen_string_literal: true

require "rails_helper"

describe TokenUrlCreate do
  subject { described_class.call(url, token) }

  let(:url) { "http://www.google.es" }
  let(:token) { "foo" }

  context "with a invalid url" do
    let(:url) { "google" }

    it "returns nil" do
      is_expected.to be_nil
    end
  end

  context "with a valid url" do
    it "returns a url with token" do
      valid_token_url = "#{url}?token=#{token}"

      is_expected.to eq(valid_token_url)
    end
  end
end
