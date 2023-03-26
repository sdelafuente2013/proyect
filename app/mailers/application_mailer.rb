class ApplicationMailer < ActionMailer::Base
  include MailersHelper

  default from: 'atencionalcliente@tirantonline.com'
  layout 'mailer'
end
