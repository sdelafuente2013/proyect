# frozen_string_literal: true

class UserSubscription::ConfirmSubscription < BaseService
  class InvalidToken < StandardError; end

  include UserSubscription::ResetPasswordCommon

  pattr_initialize :tolgeo, :token

  def call
    raise InvalidToken unless user_presubscription

    ApplicationRecord.transaction do
      user_subscription = create_user_subscription
      delete_temporal_lopd unless tolgeo_mex?
      delete_user_presubscription
      user_subscription
    end
  end

  private

  def create_user_subscription
    user_subscription_model.create!(create_params_user_subscription)
  end

  def user_presubscription
    @user_presubscription ||= user_presubscription_by_token
  end

  def user_presubscription_by_token
    user_presubscription_model.find_by(confirmation_token: encrypted_token)
  end

  def encrypted_token
    EncryptToken.call(token)
  end

  def create_params_user_subscription
    default_params.tap do |obj|
      obj.merge!(lopd_params) unless tolgeo_mex?
    end
  end

  def default_params
    {
      password_salt: user_presubscription.password_salt,
      password_digest: user_presubscription.password_digest,
      password_digest_md5: user_presubscription.password_digest_md5,
      nombre: user_presubscription.nombre,
      apellidos: user_presubscription.apellidos,
      telefono: user_presubscription.telefono,
      perusuid: user_presubscription.perusuid,
      usuarioid: user_presubscription.user.id,
      subid: user_presubscription.user.subid
    }
  end

  def lopd_params
    {
      comercial: lopd_aceptacion.aceptada_lopd_comercial,
      grupo: lopd_aceptacion.aceptada_lopd_grupo,
      privacidad: lopd_aceptacion.aceptada_lopd
    }
  end

  def delete_user_presubscription
    user_presubscription.destroy
  end

  def delete_temporal_lopd
    lopd_aceptacion.destroy
  end

  def lopd_aceptacion
    @lopd_aceptacion ||= user_presubscription.lopd_aceptacion
  end

  def tolgeo_mex?
    tolgeo == "mex"
  end
end
