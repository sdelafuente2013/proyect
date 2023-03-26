class UsersController < ApplicationController
  before_action :set_user_class
  before_action :set_backoffice_user, :only => [:destroy]

  def index
    response_with_objects(load_users, total_users)
  end

  def show
    response_with_object(load_user)
  end

  def update
    response_with_object(load_user) if update_user(load_user)
  end

  def update_all
    response_with_object({"updates_count" => update_all_items})
  end
  def destroy
    delete_user(load_user)
    response_with_no_content
  end

  def create
    @user = @user_class.create!(user_params)

    Users::CreateWithEmail
      .call(
        user_params[:has_to_send_welcome_email],
        user_params[:add_perso_account],
        @user)

    Users::CreateWithSubscription
      .call(
        user_params,
        @user,
        params['tolgeo']
      )

    response_with_object(@user, :created)
  end

  def validate
    users = auth_users
    unless users.blank?
      response_with_object(users.first)
    else
      json_response({ message: "Usuario no encontrado"}, :not_found)
    end
  end

  protected

  def default_search_param_keys
    super() + [:username_without_like, :username, :nombre, :apellidos, :email, :nif, :grupoid, :grupo, :maxconexiones, :comentario, :tipoaccesoid, :isdemo, :iscolectivo, :tipousuariogrupoid, :fecha_alta_start, :fecha_alta_end, :fecha_revision_start, :fecha_revision_end, :subid, :isactivo, :id]
  end

  def load_users
    @user_class.search(params_with_filter_subsytem_from_backoffice_user)
  end

  def total_users
    @user_class.search_count(params_with_filter_subsytem_from_backoffice_user)
  end

  def load_user
    user_id = params[:id].presence
    @user_class.find(user_id)
  end

  def update_user(loaded_user)
    translated_params = {}

    if params.key?(:access_type_tablet)
      access_type = access_type_tablet.find(params[:access_type_tablet])
      translated_params[:access_type_tablet] = access_type
    end

    loaded_user.update!(user_params.merge(translated_params))
  end

  def delete_user(loaded_user)
    loaded_user.backoffice_user = @backoffice_user
    loaded_user.destroy!
  end

  private

  def auth_users
    @user_class.authenticate(user_params)
  end

  def user_params
    params.permit(@user_class.new.attributes.keys + [:comercial, :grupo, :privacidad, :add_perso_account, :has_to_send_welcome_email] + @user_class.nested_attributes_params + ['subject_ids': []] + ['modulo_ids': []]+ ['product_ids': []])
  end

  def set_user_class
    @user_class = Objects.tolgeo_model_class(params['tolgeo'], 'user')
  end

  def access_type_tablet
    Objects.tolgeo_model_class(params['tolgeo'], 'access_type_tablet')
  end
end
