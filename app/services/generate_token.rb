# frozen_string_literal: true

class GenerateToken < BaseService
  pattr_initialize :resource, :column_name

  def call
    loop do
      token = SecureRandom.urlsafe_base64
      encrypted = EncryptToken.call(token)
      break [token, encrypted] unless resource.class.find_by(column_name => encrypted)
    end
  end
end
