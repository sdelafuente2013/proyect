class UserPresubscriptionMailerPreview < ActionMailer::Preview
  def email_passwd_token_esp
    user_presubscription = Esp::UserPresubscription.first
    UserPresubscriptionMailer.with(user_presubscription:user_presubscription).email_passwd_token
  end

  def email_passwd_token_mex
    user_presubscription = Mex::UserPresubscription.first
    UserPresubscriptionMailer.with(user_presubscription:user_presubscription).email_passwd_token
  end

  def email_passwd_token_latam
    user_presubscription = Latam::UserPresubscription.first
    UserPresubscriptionMailer.with(user_presubscription:user_presubscription).email_passwd_token
  end

end
