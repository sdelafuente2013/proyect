class UserPresubscriptionMailer < ApplicationMailer

  helper MailersHelper
  layout 'user_mailer'

  def email_passwd_token
    @user_presubscription = params[:user_presubscription]
    @user=@user_presubscription.user
    @tolgeo = @user.tolgeo
    @subsystem = @user.subsystem
    @app_name = Settings['subid_to_appname'][@tolgeo][@subsystem.id]
    @url_with_token = params[:confirmation_url]
    @site_email = set_sender_email
    mail(to: @user_presubscription.perusuid, subject: '%s %s' % [I18n.t("email_common.title"), @subsystem.name], from: @site_email)
  end
end
