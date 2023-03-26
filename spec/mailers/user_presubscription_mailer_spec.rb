# frozen_string_literal: true

require "rails_helper"
require_relative "previews/user_presubscription_mailer_preview"

RSpec.describe UserPresubscriptionMailer, type: :mailer do
  let!(:esp_user) do
    username = "username"
    password = "123456789"
    email = "new@user.com"
    subsystem = create(:subsystem)
    create(:user, subsystem: subsystem, username: username, password: password, email: email)
  end

  let!(:latam_user) do
    username = "latamuser"
    password = "123456789"
    email = "new@latamuser.com"
    subsystem = create(:subsystem_latam)
    create(:user_latam, subsystem: subsystem, username: username, password: password, email: email)
  end

  let!(:mex_user) do
    username = "mexusername"
    password = "123456789"
    email = "mexusername@user.com"
    subsystem = create(:subsystem_mex)
    create(:user_mex, subsystem: subsystem, username: username, password: password, email: email)
  end

  let(:user_presubscription_mail_preview) { UserPresubscriptionMailerPreview.new }

  describe "#email_passwd_token" do
    let!(:esp_presubscription) do
      Esp::UserPresubscription.new(
          perusuid: "test5001@user.com",
          password: "molamazo",
          usuarioid: esp_user.id,
          user: esp_user
      ).tap {|o| o.save! }
    end

    let!(:latam_presubscription) do
      Latam::UserPresubscription.new(
          perusuid: "test5001@user.com",
          password: "molamazo",
          usuarioid: latam_user.id,
          user: latam_user
      ).tap {|o| o.save! }
    end

    let!(:mex_presubscription) do
      Mex::UserPresubscription.new(
          perusuid: "test5001@user.com",
          password: "molamazo",
          usuarioid: mex_user.id,
          user: mex_user
      ).tap {|o| o.save! }
    end

    it "works for Esp::UserPresubscription" do
      expect(user_presubscription_mail_preview.email_passwd_token_esp.to)
        .to include esp_presubscription.perusuid
    end

    it "works for Mex::UserPresubscription" do
      expect(user_presubscription_mail_preview.email_passwd_token_mex.to)
        .to include mex_presubscription.perusuid
    end

    it "works for Latam::UserPresubscription" do
      expect(user_presubscription_mail_preview.email_passwd_token_latam.to)
        .to include latam_presubscription.perusuid
    end
  end
end
