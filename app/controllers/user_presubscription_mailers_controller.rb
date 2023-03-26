class UserPresubscriptionMailersController < ApplicationController
  before_action :set_user_presubscription_class, :load_presubscription_user

  def create
    set_user_subscription_class
    existing_user = @user_subscription_class.where(subid: @user_presubscription.user.try(:subid), perusuid: @user_presubscription.perusuid).first
    if existing_user
      json_response({ message: 'El usuario ya existe' }, :unprocessable_entity)
      return
    end
    @user_presubscription.send_email
    response_with_object({}, :created)
  end

  protected

  def load_presubscription_user
    user_presubscription_id = user_mailer_params[:user_presubscription_id].presence
    @user_presubscription = @user_presubscription_class.find(user_presubscription_id)
  end

  private

  def user_mailer_params
    params.permit([:user_presubscription_id])
  end

  def set_user_presubscription_class
    @user_presubscription_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_presubscription')
  end

  def set_user_subscription_class
    @user_subscription_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_subscription')
  end

end
