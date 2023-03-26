class MassiveSubscriptionsController < ApplicationController
  before_action :set_user_subscription_class

  def create
    error_message = @user_subscription_class.import_users(user_params)
    if error_message.blank?
      response_with_object({}, :created)
    else
      json_response({message: error_message}, :unprocessable_entity)
    end
  end
  
  private
  
  def user_params
    params.permit(:usuarioid, ['user_candidates': [:perusuid, :nombre, :apellidos, :lopd_grupo, :lopd_comercial]])
  end

  def set_user_subscription_class
    @user_subscription_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_subscription')
  end
  
end
