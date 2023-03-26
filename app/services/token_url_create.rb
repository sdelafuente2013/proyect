# frozen_string_literal: true

class TokenUrlCreate < BaseService
  pattr_initialize :url, :token

  def call
    uri = URI(url)
    return unless uri.host

    params = URI.decode_www_form(uri.query || "") << ["token", token]
    uri.query = URI.encode_www_form(params)

    uri.to_s
  end
end
