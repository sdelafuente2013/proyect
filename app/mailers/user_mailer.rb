class UserMailer < ApplicationMailer
  helper MailersHelper
  layout :get_layout

  def email_user_passwd(user: nil, locale: nil, bcc: nil)
    @user = user || params[:user]
    set_template_params
    @site_email = set_sender_email
    @bbc = params && params.key?(:bbc) ? params[:bcc] || bcc || ENV['DEFAULT_CC_EMAIL_ATENCION_CLIENTE'] : ENV['DEFAULT_CC_EMAIL_ATENCION_CLIENTE']
    @locale = params && params.key?(:locale) ? params[:locale] || locale || 'es' : locale || 'es'

    I18n.with_locale(@locale) do
      mail(to: @user.email, subject: format('%s %s', t('email_common.title'), @subsystem.name),
           from: @site_email, bcc: @bbc)
    end
  end

  def email_data_full
    @user = params[:user]
    set_template_params
    @user_subscription = params[:user_subscription]
    bbc = ENV['DEFAULT_CC_EMAIL_ATENCION_CLIENTE']
    site_email = set_sender_email
    mail(to: @user.email, subject: format('%s %s', I18n.t('email_common.title'), @subsystem.name),
         from: site_email, bcc: bbc)
  end

  def email_user_share_document
    @user = params[:user]
    set_template_params
    @user_subscription = params[:user_subscription]
    @extra_params = params[:extra_params]
    subject = format(I18n.t('email_user_share_document.subject'), @extra_params['numeroTOL'],
                     @user.username)
    subject += " <#{@user_subscription.perusuid}>" if @user_subscription.present?
    mail(to: @extra_params['mail'], subject: subject, from: set_sender_email)
  end

  def set_template_params
    @tolgeo = @user.tolgeo
    @subsystem = @user.subsystem
    @app_name = Settings['subid_to_appname'][@tolgeo][@subsystem.id]
  end

  def get_layout
    @_action_name == 'email_user_share_document' ? 'user_mailer_share_document' : 'user_mailer'
  end
end
