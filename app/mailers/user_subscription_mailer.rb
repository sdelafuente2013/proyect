class UserSubscriptionMailer < ApplicationMailer
  default from: -> { set_sender_email }

  helper MailersHelper
  layout 'user_mailer'

  def email_passwd
    @user_subscription = params[:user_subscription]
    @user=@user_subscription.user
    @tolgeo = @user_subscription.tolgeo
    @subsystem = @user_subscription.subsystem
    @app_name = Settings['subid_to_appname'][@tolgeo][@subsystem.id]
    @site_email = set_sender_email
    mail(to: @user_subscription.perusuid, subject: '%s %s' % [I18n.t("email_common.title"), @subsystem.name], from: @site_email)
  end

  def request_password_recovery
    @user_subscription = params[:user_subscription]
    @user = params[:user]
    @tolgeo = @user.tolgeo

    mail(
      to: @user_subscription.perusuid,
      subject: I18n.t('user_subscription_mailer.request_password_recovery.subject')
    )
  end

  def confirm_update_email
    @user_subscription = params[:user_subscription]
    @user = params[:user]
    @tolgeo = @user.tolgeo

    mail(
      to: params[:new_email],
      subject: I18n.t('user_subscription_mailer.confirm_update_email.subject')
    )
  end
end
