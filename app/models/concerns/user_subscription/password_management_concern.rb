# frozen_string_literal: true

module UserSubscription::PasswordManagementConcern
  extend ActiveSupport::Concern

  SALT_BYTES = 8

  included do
    def generate_hashed_password(password, password_salt)
      Digest::SHA2.hexdigest(password_salt + password)
    end

    def generate_password_salt
      SecureRandom.base64(SALT_BYTES)
    end

    def generate_hashed_md5_password(password,password_salt)
      Digest::SHA2.hexdigest(password_salt + Digest::MD5.hexdigest(password))
    end

    def valid_password?(password)
      hashed_password = generate_hashed_password(password, password_salt)
      hashed_password == password_digest || hashed_password == password_digest_md5
    end

    def change_password_base_url
      "#{tolweb_root_url}/base/#{subid_to_appname}/user_subscriptions/password_changes/new"
    end

    def confirm_presubscription_base_url
      "#{tolweb_root_url}/base/#{subid_to_appname}/user_presubscriptions/confirm_mail"
    end

    def password=(password)
      return unless password

      self.password_salt = generate_password_salt
      self.password_digest = generate_hashed_password(password, password_salt)
      self.password_digest_md5 = generate_hashed_md5_password(password, password_salt)
    end
  end

  private

  def tolweb_root_url
    Settings.canaltirant.detect { |p| p.code == subid_to_appname }.url
  end

  def subid_to_appname
    return unless (subid_to_appname_hash = Settings.subid_to_appname[tolgeo])

    subid_to_appname_hash[subid] || subid_to_appname_hash[0]
  end

end
