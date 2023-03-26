class UserSubscription::RequestRecoverPassword < BaseService
  include UserSubscription::ResetPasswordCommon

  pattr_initialize :tolgeo, :email, :change_password_url, :subid

  def call
    return unless user_subscription

    url =
      UserSubscription::GenerateResetPasswordUrl
        .call(user_subscription, change_password_url)

    send_email(url)
  end

  private

  def user_subscription
    @user_subscription ||= user_subscription_model
      .by_email(email)
      .by_subid(subid).first
  end

  def user
    @user ||= user_model.find(@user_subscription.usuarioid)
  end

  def send_email(url)
    return unless user_subscription

    UserSubscriptionMailer
      .with(user_subscription: user_subscription, user: user, change_password_url: url)
      .request_password_recovery
      .deliver_later
  end
end
