# frozen_string_literal: true

require "rails_helper"

class ResourceClass
  def self.find_by(params); end
end

describe GenerateToken do
  subject { described_class.call(resource, column) }

  let(:resource) { ResourceClass.new }
  let(:column) { "column_name" }
  let(:token) { "new_token" }
  let(:encrypted) { "new_token_encrypted" }

  before do
    allow(SecureRandom).to receive(:urlsafe_base64).and_return "present_token", token
    allow(EncryptToken).to receive(:call).with("present_token").and_return "present_token_encrypted"
    allow(EncryptToken).to receive(:call).with(token).and_return encrypted
    stub_resource_find("present_token_encrypted", resource)
    stub_resource_find(encrypted, nil)
  end

  describe "find_by is called" do
    before { subject }

    it "with present token" do
      expect(ResourceClass).to have_received(:find_by).with(column => "present_token_encrypted")
    end

    it "with not present token" do
      expect(ResourceClass).to have_received(:find_by).with(column => encrypted)
    end
  end

  it "result is an encrypted token" do
    is_expected.to eq([token, encrypted])
  end
end

def stub_resource_find(token, result)
  allow(ResourceClass).to receive(:find_by).with(column => token).and_return result
end
