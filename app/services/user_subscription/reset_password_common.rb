# frozen_string_literal: true

module UserSubscription::ResetPasswordCommon
  private

  def user_presubscription_model
    @user_presubscription_model  ||= Objects.tolgeo_model_class(tolgeo, "user_presubscription")
  end

  def user_subscription_model
    @user_subscription_model ||= Objects.tolgeo_model_class(tolgeo, "user_subscription")
  end

  def user_model
    @user_model ||= Objects.tolgeo_model_class(tolgeo, "user")
  end
end
