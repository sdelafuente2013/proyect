class MassiveUsersController < ApplicationController
  before_action :set_user_class

  def create
    MassiveUsersJob.perform_later(params['tolgeo'], user_params.to_h, params['locale_send_mail'].presence || params['locale'])
    response_with_object({}, :created)
  end

  private

  def user_params
    params.permit(@user_class.new.attributes_and_permitted_attr_accessor.keys+@user_class.nested_attributes_params + ['subject_ids': []] + ['modulo_ids': []] + ['product_ids': []]+ ['user_candidates': [:identificador, :nombre, :apellido1, :apellido2, :email, :usuario,:password, :lopd_grupo, :lopd_comercial]])
  end

  def set_user_class
    @user_class = Objects.tolgeo_model_class(params['tolgeo'], 'user')
  end

end
