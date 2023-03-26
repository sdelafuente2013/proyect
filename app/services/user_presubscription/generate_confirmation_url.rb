# frozen_string_literal: true

class UserPresubscription::GenerateConfirmationUrl < BaseService
  pattr_initialize :user_presubscription, :confirm_subscription_url

  def call
    @token, encrypted_token = GenerateToken.call(
      user_presubscription, "confirmation_token"
    )

    user_presubscription
      .update(
        confirmation_token: encrypted_token
      )

    TokenUrlCreate.call(confirm_subscription_url, token)
  end

  private

  attr_accessor :token
end
