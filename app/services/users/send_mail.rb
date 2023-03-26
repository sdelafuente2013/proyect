class Users::SendMail < SendMailBase
  private

  def user
    @user ||= user_model.find(params[:user_id])
  end

  def user_subscription
    return unless user.email

    user.user_subscriptions.by_email(user.email).first
  end

  def processed_params
    {
      user: user,
      user_subscription: user_subscription,
      extra_params: params[:extra_params]
    }
  end

  def mapping
    {
      email_user_passwd: [:mailer, UserMailer, :email_user_passwd],
      email_data_full: [:job, User::SendFullDataJob],
      email_user_share_document: [:mailer, UserMailer, :email_user_share_document]
    }
  end

  def user_model
    Objects.tolgeo_model_class(params[:tolgeo], 'user')
  end
end
