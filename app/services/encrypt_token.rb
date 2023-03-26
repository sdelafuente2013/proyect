# frozen_string_literal: true

class EncryptToken < BaseService
  pattr_initialize :token

  def call
    OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha256"),
      "trntlblnch token",
      token
    )
  end
end
