class GroupsController < ApplicationController
  before_action :set_group_class
  before_action :set_backoffice_user, :only => [:destroy]

  def index
    response_with_objects(load_groups, total_groups)
  end

  def show
    response_with_object(load_group)
  end

  def create
    group = create_group
    response_with_object(group, :created)
  end

  def update
    response_with_object(load_group) if update_group(load_group)
  end

  def destroy
    group = @group_class.find(params[:id])

    group.destroy_with_users(@backoffice_user) if has_remove_users?
    group.destroy unless has_remove_users?

    response_with_no_content
  end

  protected

  def default_search_param_keys
    super()+[:isactivo, :show_demo]
  end

  def load_groups
    @group_class.search(search_params)
  end

  def total_groups
    @group_class.search_count(search_params)
  end

  def load_group
    param = params[:id].presence
    @group_class.find(param)
  end

  def create_group
    @group_class.create!(group_params)
  end

  def update_group(loaded_group)
    loaded_group.update(group_params)
  end

  def delete_group(loaded_group)
    loaded_group.destroy
  end

  private

  def has_remove_users?
    params[:remove_users] == "true"
  end

  def group_params
    params.permit(@group_class.new.attributes.keys)
  end

  def set_group_class
    @group_class = Objects.tolgeo_model_class(params['tolgeo'], 'group')
  end
end
