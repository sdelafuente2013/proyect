class BackofficeUsersController < ApplicationController
  before_action :set_backoffice_user_class
  before_action :load_backoffice_user, only: [:show, :update, :destroy]

  def index
    backoffice_users = @backoffice_user_class.search(search_params)
    backoffice_users_total = @backoffice_user_class.search_count(search_params)
    response_with_objects(backoffice_users, backoffice_users_total)
  end

  def show
    response_with_object(@backoffice_user)
  end

  def create
    backoffice_user = @backoffice_user_class.create!(backoffice_user_params)
    response_with_object(backoffice_user, :created)
  end

  def update
    @backoffice_user.update!(backoffice_user_params)
    response_with_object(@backoffice_user)
  end

  def destroy
    @backoffice_user.destroy!
    response_with_no_content
  end

  def default_search_param_keys
    super()+[:email]
  end

  private

  def set_backoffice_user_class
    @backoffice_user_class = Esp::BackofficeUser
  end

  def backoffice_user_params
    params.permit(@backoffice_user_class.new.attributes.keys + ['password'] + @backoffice_user_class.nested_attributes_params)
  end

  def load_backoffice_user
    param = params[:id].presence
    @backoffice_user = @backoffice_user_class.find(param)
  end
end
