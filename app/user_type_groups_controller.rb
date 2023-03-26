class UserTypeGroupsController < ApplicationController
  before_action :set_user_type_group_class

  def index
    load_user_type_groups
    response_with_objects(load_user_type_groups, total_user_type_groups)
  end

  private

  def load_user_type_groups
    @user_type_group_class.all
  end

  def total_user_type_groups
    load_user_type_groups.count
  end

  def set_user_type_group_class
    @user_type_group_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_type_group')
  end
end

