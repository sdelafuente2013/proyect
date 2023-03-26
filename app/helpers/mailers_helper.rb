module MailersHelper
  def tolgeo_mailer_setting(setting)
    if setting == 'logo' && @app_name == 'conmex'
      Settings.mailers[setting][@app_name]
    elsif setting == 'tirant_mail_atencion'
      set_sender_email
    else
      Settings.mailers[setting][@tolgeo]
    end
  end

  def set_sender_email
    setting_email = Settings.mailers.tirant_mail_atencion
    return setting_email[@tolgeo][@app_name] unless setting_email[@tolgeo][@app_name].nil?

    setting_email[@tolgeo]['default']
  end
end
