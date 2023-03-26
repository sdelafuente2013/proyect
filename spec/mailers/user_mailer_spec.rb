require "rails_helper"
require_relative 'previews/user_mailer_preview'


RSpec.describe UserMailer, :type => :mailer do

  let!(:esp_user) {
    username = 'username'
    password = '123456789'
    email = 'new@user.com'
    locale = 'es'
    subsystem = create(:subsystem)
    user = create(:user, subsystem: subsystem, username: username, password: password, email: email)
  }

  let!(:latam_user) {
    username = 'latamuser'
    password = '123456789'
    email = 'new@latamuser.com'
    locale = 'es'
    subsystem = create(:subsystem_latam)
    user = create(:user_latam, subsystem: subsystem, username: username, password: password, email: email)
  }

  let!(:mex_user) {
    username = 'mexusername'
    password = '123456789'
    email = 'mexusername@user.com'
    locale = 'es'
    subsystem = create(:subsystem_mex)
    user = create(:user_mex, subsystem: subsystem, username: username, password: password, email: email)
  }

  let(:user_mail_preview) { UserMailerPreview.new }

  let(:extra_params_share_document) {
    { 'numeroTOL' => 'TOL54.345', 'text' => 'Esto es el texto', 'doc_url' => 'document_path/file.pdf', 'mail' => 'prueba@tirant.net' }
  }

  describe '#email_user_passwd' do
    it 'works for Esp::User' do
      expect(user_mail_preview.email_user_passwd_esp.html_part.decoded).to include(esp_user.username)
    end

    it 'works for Mex::User' do
      expect(user_mail_preview.email_user_passwd_mex.html_part.decoded).to include(mex_user.username)
    end

    it 'works for Latam::User' do
      expect(user_mail_preview.email_user_passwd_latam.html_part.decoded).to include(latam_user.username)
    end
  end

  describe '#email_data_full' do
    let(:user_subscription) { create :user_subscription }
    let(:user) { user_subscription.user }

    subject do
      described_class
        .with(
          user: user,
          user_subscription: user_subscription,
          reset_password_url: "http://www.example.com"
        )
        .email_data_full
    end

    shared_examples 'for email_data_full' do
      it 'has the right subject' do
        expect(subject.subject).to eq "#{I18n.t('email_common.title')} #{user.subsystem.name}"
      end

      it 'has the right receiver' do
        expect(subject.to.first).to eq user_subscription.user.email
      end

      it 'includes the url in the email body' do
        expect(subject.body.encoded).to include('http://www.example.com')
      end
    end

    describe 'for esp user' do
      let(:user_subscription) { create :user_subscription }

      include_examples 'for email_data_full'

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencionalcliente@tirantonline.com'
      end
    end

    describe 'for mex user' do
      let(:user_subscription) { create :user_subscription_mex }

      include_examples 'for email_data_full'

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencion.tolmex@tirantonline.com.mx'
      end
    end

    describe 'for latam user' do
      let(:user_subscription) { create :user_subscription_latam }

      include_examples 'for email_data_full'

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencion.latam@tirantonline.com'
      end
    end
  end

  describe '#email_user_share_document' do
    it 'works for Esp::User' do
      mail = user_mail_preview.email_user_share_document_esp(extra_params_share_document)
      expect(mail.subject).to include(extra_params_share_document['numeroTOL'])
      expect(mail.subject).to include(esp_user.username)
      expect(mail.to).to include(extra_params_share_document['mail'])
      expect(mail.encoded).to include(extra_params_share_document['text'])
      expect(mail.encoded).to include(extra_params_share_document['doc_url'])
    end

    it 'works for Mex::User' do
      mail = user_mail_preview.email_user_share_document_mex(extra_params_share_document)
      expect(mail.subject).to include(extra_params_share_document['numeroTOL'])
      expect(mail.subject).to include(mex_user.username)
      expect(mail.to).to include(extra_params_share_document['mail'])
      expect(mail.encoded).to include(extra_params_share_document['text'])
      expect(mail.encoded).to include(extra_params_share_document['doc_url'])
    end

    it 'works for Latam::User' do
      mail = user_mail_preview.email_user_share_document_latam(extra_params_share_document)
      expect(mail.subject).to include(extra_params_share_document['numeroTOL'])
      expect(mail.subject).to include(latam_user.username)
      expect(mail.to).to include(extra_params_share_document['mail'])
      expect(mail.encoded).to include(extra_params_share_document['text'])
      expect(mail.encoded).to include(extra_params_share_document['doc_url'])
    end
  end
end
