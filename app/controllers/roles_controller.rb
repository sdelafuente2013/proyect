class RolesController < ApplicationController
  before_action :set_role_class
  before_action :load_role, only: [:show, :update, :destroy]

  def index
    roles = @role_class.search(search_params)
    roles_total = @role_class.search_count(search_params)
    response_with_objects(roles, roles_total)
  end

  def show
    response_with_object(@role)
  end

  def create
    role = @role_class.create!(role_params)
    response_with_object(role, :created)
  end

  def update
    @role.update!(role_params)
    response_with_object(@role)
  end

  def destroy
    @role.destroy!
    response_with_no_content
  end

  def default_search_param_keys
    super()+[:description]
  end

  private

  def set_role_class
    @role_class = Esp::Role
  end

  def role_params
    params.permit(@role_class.new.attributes.keys)
  end

  def load_role
    param = params[:id].presence
    @role = @role_class.find(param)
  end
end
