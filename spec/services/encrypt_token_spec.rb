# frozen_string_literal: true

require "rails_helper"

describe EncryptToken do
  subject { described_class.call(token) }

  let(:token) { "foo" }
  let(:encrypted_token) { "1c4e4ff984cde8ea5b34cfed8a92dc256babc4bd59c160b34bc34d7ca007415b" }

  it do
    is_expected.to eq(encrypted_token)
  end
end
