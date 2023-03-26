require "rails_helper"
require_relative 'previews/user_subscription_mailer_preview'

RSpec.describe UserSubscriptionMailer do
  describe '#email_passwd' do
    subject do
      described_class
        .with(
          user_subscription: user_subscription,
          change_password_url: 'http://www.example.com'
        )
        .email_passwd
    end

    before { I18n.locale = :es }

    context 'esp user' do
      let(:user_subscription) { create(:user_subscription) }
      let(:user) { create(:user) }

      it 'has the right subject' do
        expect(subject.subject).to eq "#{I18n.t("email_common.title")} #{user_subscription.subsystem.name}"
      end

      it 'has the right receiver' do
        expect(subject.to.first).to eq user_subscription.perusuid
      end

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencionalcliente@tirantonline.com'
      end

      it 'includes the url in the email body' do
        expect(subject.body.encoded).to include('http://www.example.com')
      end
    end

    context 'latam user' do
      let(:user_subscription) { create(:user_subscription_latam) }
      let(:user) { create(:user_latam) }

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencion.latam@tirantonline.com'
      end
    end

    context 'mex user' do
      let(:user_subscription) { create(:user_subscription_mex) }
      let(:user) { create(:user_mex) }

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencion.tolmex@tirantonline.com.mx'
      end
    end
  end
  describe '#request_password_recovery' do
    subject do
      described_class
        .with(
          user_subscription: user_subscription,
          user: user,
          change_password_url: 'http://www.example.com'
        )
        .request_password_recovery
    end

    before { I18n.locale = :es }

    context 'esp user' do
      let(:user_subscription) { create(:user_subscription) }
      let(:user) { create(:user) }

      it 'has the right subject' do
        expect(subject.subject).to eq 'Petición de recuperación de contraseña'
      end

      it 'has the right receiver' do
        expect(subject.to.first).to eq user_subscription.perusuid
      end

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencionalcliente@tirantonline.com'
      end

      it 'includes the url in the email body' do
        expect(subject.body.encoded).to include('http://www.example.com')
      end
    end

    context 'latam user' do
      let(:user_subscription) { create(:user_subscription_latam) }
      let(:user) { create(:user_latam) }

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencion.latam@tirantonline.com'
      end
    end

    context 'mex user' do
      let(:user_subscription) { create(:user_subscription_mex) }
      let(:user) { create(:user_mex) }

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencion.tolmex@tirantonline.com.mx'
      end
    end
  end

  describe '#confirm_update_email' do
    subject do
      described_class
        .with(
          user_subscription: user_subscription,
          user: user,
          update_email_url: 'http://www.linktoconfirmupdate.com',
          new_email: 'minuevocorrein@gmail.com'
        )
        .confirm_update_email
    end

    before { I18n.locale = :es }

    context 'esp user' do
      let(:user_subscription) { create(:user_subscription) }
      let(:user) { create(:user) }

      it 'has the right subject' do
        expect(subject.subject).to eq 'Petición de actualización de correo'
      end

      it 'has the right receiver' do
        expect(subject.to.first).to eq 'minuevocorrein@gmail.com'
      end

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencionalcliente@tirantonline.com'
      end

      it 'includes the url in the email body' do
        expect(subject.body.encoded).to include('http://www.linktoconfirmupdate.com')
      end
    end

    context 'latam user' do
      let(:user_subscription) { create(:user_subscription_latam) }
      let(:user) { create(:user_latam) }

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencion.latam@tirantonline.com'
      end
    end

    context 'mex user' do
      let(:user_subscription) { create(:user_subscription_mex) }
      let(:user) { create(:user_mex) }

      it 'has the right sender' do
        expect(subject.from.first).to eq 'atencion.tolmex@tirantonline.com.mx'
      end
    end
  end
end
