# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def email_massive_import
    @usernames = params[:usernames]
    @errors = params[:errors]

    mail(
      to: ENV['DEFAULT_CC_EMAIL_ATENCION_CLIENTE'],
      subject: 'alta masiva terminada',
      from: ENV['DEFAULT_CC_EMAIL_ATENCION_CLIENTE']
    )
  end

  def email_call_back
    @name = params[:name]
    @phone = params[:phone]
    @horary = params[:horary]
    @appname = params[:appname]

    mail(
      to: ENV["EMAIL_AUTOVENTA_#{@appname.upcase}"],
      subject: format(t('.subject'), t("canaltirant.#{@appname}")),
      from: ENV["EMAIL_AUTOVENTA_#{@appname.upcase}"]
    )
  end
end
