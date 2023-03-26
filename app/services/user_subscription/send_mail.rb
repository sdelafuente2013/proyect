class UserSubscription::SendMail < SendMailBase
  private

  def user_subscription
    @user_subscription ||= user_subscription_model.find(params[:user_subscription_id])
  end

  def processed_params
    {
      user_subscription: user_subscription
    }
  end

  def mapping
    {
      email_user_subscription_passwd: [:job, UserSubscription::SendAccessDataJob]
    }
  end

  def user_subscription_model
    Objects.tolgeo_model_class(params[:tolgeo], 'user_subscription')
  end
end
