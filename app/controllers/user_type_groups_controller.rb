class UserTypeGroupsController < ApplicationController
  before_action :set_user_type_group_class

  def index
    data = load_user_type_groups
    response_with_objects(data, data.count)
  end

  private

  def load_user_type_groups
    @user_type_group_class.all
  end

  def set_user_type_group_class
    @user_type_group_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_type_group')
  end
end

