require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  it 'sends an email with esp user and password with LOPD' do
    username = 'username'
    password = '123456789'
    email = 'new@user.com'
    locale = 'es'
    subsystem = create(:subsystem)
    user = create(:user, subsystem: subsystem, username: username, password: password, email: email)
    mail = UserMailer.email_user_passwd(user: user, locale: locale)
    body = body_from(mail)
    expect(mail.to.first).to eq(email)
    expect(body).to include(username)
    expect(body).to include(password)
    expect(body).to include('2016/679')
  end

  it 'sends an email with latam user and password with LOPD' do
    username = 'latamuser'
    password = '123456789'
    email = 'new@latamuser.com'
    locale = 'es'
    subsystem = create(:subsystem_latam)
    user = create(:user_latam, subsystem: subsystem, username: username, password: password,
                               email: email)
    mail = UserMailer.email_user_passwd(user: user, locale: locale)
    body = body_from(mail)
    expect(mail.to.first).to eq(email)
    expect(body).to include(username)
    expect(body).to include(password)
    expect(body).to include('2016/679')
  end

  it 'sends an email with mex user and password NO LOPD' do
    username = 'mexusername'
    password = '123456789'
    email = 'mexusername@user.com'
    locale = 'es'
    subsystem = create(:subsystem_mex)
    user = create(:user_mex, subsystem: subsystem, username: username, password: password,
                             email: email)
    mail = UserMailer.email_user_passwd(user: user, locale: locale)
    body = body_from(mail)
    expect(mail.to.first).to eq(email)
    expect(body).to include(username)
    expect(body).to include(password)
    expect(body).not_to include('ADVERTENCIA LEGAL:')
  end

  it 'sends an email with latam user with locale pt' do
    username = 'username'
    password = '123456789'
    email = 'new@user.com'
    locale = 'pt'
    subsystem = create(:subsystem_latam)
    user = create(:user_latam, subsystem: subsystem, username: username, password: password,
                               email: email)
    mail = UserMailer.with(user: user, locale: locale).email_user_passwd
    body = body_from(mail)
    expect(mail.to.first).to eq(email)
    expect(body).to include(username)
    expect(body).to include(password)
    expect(body).to include('Senha')
  end

  def body_from(mail)
    mail.html_part.to_s
  end
end
