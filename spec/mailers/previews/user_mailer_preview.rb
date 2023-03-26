class UserMailerPreview < ActionMailer::Preview
  def email_user_passwd_esp
    user = Esp::User.first
    UserMailer.with(user:user).email_user_passwd
  end

  def email_user_passwd_mex
    user = Mex::User.first
    UserMailer.with(user:user).email_user_passwd
  end

  def email_user_passwd_latam
    user = Latam::User.first
    UserMailer.with(user:user).email_user_passwd
  end



  def email_data_full_esp
    email_data_full(Esp::UserSubscription.first)
  end

  def email_data_full_latam
    email_data_full(Latam::UserSubscription.first)
  end

  def email_data_full_mex
    email_data_full(Mex::UserSubscription.first)
  end



  def email_user_share_document_esp(extra_params)
    user = Esp::User.first
    UserMailer.with({user:user, extra_params:extra_params}).email_user_share_document
  end

  def email_user_share_document_latam(extra_params)
    user = Latam::User.first
    UserMailer.with({user:user, extra_params:extra_params}).email_user_share_document
  end

  def email_user_share_document_mex(extra_params)
    user = Mex::User.first
    UserMailer.with({user:user, extra_params:extra_params}).email_user_share_document
  end

  private

  def email_data_full(user_subscription)
    UserMailer.with(
      {
        user: user_subscription.user,
        user_subscription: user_subscription,
        reset_password_url: "http://www.example.com"
      }
    ).email_data_full
  end

end
