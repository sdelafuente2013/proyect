class User::SendFullDataJob < ApplicationJob

  queue_as :mailers

  def perform(params)
    @params = params

    return unless user

    UserMailer.with(mailer_params).email_data_full.deliver_later
  end

  private

  attr_accessor :params

  def mailer_params
    {
      user: user,
      user_subscription: user_subscription,
      reset_password_url: reset_password_url
    }
  end

  def reset_password_url
    return unless params[:user_subscription]

    UserSubscription::GenerateResetPasswordUrl
      .call(
        user_subscription,
        user_subscription.change_password_base_url
      )
  end

  def user_subscription
    @user_subscription ||= params[:user_subscription]
  end

  def user
    @user ||= params[:user]
  end
end
