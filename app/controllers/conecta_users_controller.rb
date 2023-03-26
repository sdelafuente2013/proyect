class ConectaUsersController < ApplicationController
  before_action :set_user_class
  before_action :set_user, only: [:update, :destroy]


  def create
    user = @user_class.create_conecta(params['tolgeo'], user_params, subscription_params)

    response_with_object(user)
  end

  def show
    user = @user_class.find(params['id']) if params['id']
    user = @user_class.find_by_username(params['username']) if params['username']

    response_with_object(user)
  end

  def update
    @user.update_conecta(user_params, subscription_params)

    response_with_object(@user)
  end

  def destroy
    @user.disable_conecta

    response_with_object(@user)
  end

  private

  def set_user
    @user = @user_class.find(params['id'])
  end

  def set_user_class
    @user_class = Objects.tolgeo_model_class(params['tolgeo'], 'user')
    @user_subscription_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_subscription')
  end

  def subscription_params
    params.permit(@user_subscription_class.new.attributes.keys + ['enable_newsletter']+ ['grupo','comercial','privacidad'])
  end

  def user_params
    params.permit(@user_class.new.attributes.keys + @user_class.nested_attributes_params + ['grupo','comercial','privacidad'] + ['subject_ids': []] + ['modulo_ids': []])
  end
end
