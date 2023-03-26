class MoveUsersFromGroupsController < ApplicationController
  before_action :set_user_and_groups
  before_action :set_destination_group, :only => [:update]

  def show
    response_with_object(@group)
  end
  
  def update
    total=@group.move_all_users_to_group(@group_destination)
    p "TOTAL"
    p total
    response_with_object({"updates_count" => total})
  end

  private
  
  def group_params
    params.permit(["group_destination_id"])
  end
  
  def set_user_and_groups
    @group_class = Objects.tolgeo_model_class(params['tolgeo'], 'group')
    @user_class = Objects.tolgeo_model_class(params['tolgeo'], 'user')
    @group = @group_class.find(params[:id])
  end
  
  def set_destination_group
    @group_destination = @group_class.find(params[:group_destination_id])
  end  

end