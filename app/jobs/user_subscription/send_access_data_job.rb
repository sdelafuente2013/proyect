class UserSubscription::SendAccessDataJob < ApplicationJob
  def perform(params)
    return unless params[:user_subscription]

    @params = params

    UserSubscriptionMailer.with(mailer_params).email_passwd.deliver_later
  end

  private

  attr_accessor :params

  def mailer_params
    {
      user_subscription: user_subscription,
      change_password_url: reset_password_url
    }
  end

  def reset_password_url
    return unless user_subscription

    UserSubscription::GenerateResetPasswordUrl
      .call(
        user_subscription,
        user_subscription.change_password_base_url
      )
  end

  def user_subscription
    @user_subscription ||= params[:user_subscription]
  end
end
