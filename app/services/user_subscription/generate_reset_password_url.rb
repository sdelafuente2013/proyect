# frozen_string_literal: true

class UserSubscription::GenerateResetPasswordUrl < BaseService
  pattr_initialize :user_subscription, :change_password_url

  def call
    @token, encrypted_token = GenerateToken.call(
      user_subscription, "reset_password_token"
    )

    user_subscription
      .update(
        reset_password_token: encrypted_token,
        reset_password_sent_at: Time.current
      )

    TokenUrlCreate.call(change_password_url, token)
  end

  private

  attr_accessor :token
end
