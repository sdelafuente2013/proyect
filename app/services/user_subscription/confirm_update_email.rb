class UserSubscription::ConfirmUpdateEmail < BaseService
  include UserSubscription::ResetPasswordCommon

  pattr_initialize :tolgeo,:new_email, :current_email , :user_id, :update_email_url

  def call
    return unless validate_email.blank?
    url = update_email_url
    send_email(url)
  end

  private

  def validate_email
    user_subscription_model.by_email(new_email).by_subid(user_subscription["subid"]).first
  end

  def user_subscription
    @user_subscription=user_subscription_model.by_email(current_email).first
  end

  def user
    @user ||= user_model.find(user_id)
  end

  def send_email(url)
    UserSubscriptionMailer
      .with(current_email: current_email, user_subscription: user_subscription, update_email_url: url, user: user, new_email: new_email, tolgeo: tolgeo)
      .confirm_update_email
      .deliver_later
  end
end
