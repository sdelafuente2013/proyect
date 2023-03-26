# frozen_string_literal: true

class UserSubscription::ChangePassword < BaseService
  class InvalidToken < StandardError; end

  include UserSubscription::ResetPasswordCommon

  EXPIRATION_DAYS = 1

  pattr_initialize :tolgeo, :token, :password

  def call
    encrypted = EncryptToken.call(token)
    user_subscription =
      user_subscription_model
        .where(reset_password_token: encrypted)
        .where("reset_password_sent_at > ?", EXPIRATION_DAYS.days.ago)
        .first

    raise InvalidToken unless user_subscription

    user_subscription.update(
      password: password,
      reset_password_token: nil
    )

    user_subscription
  end
end
