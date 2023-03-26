class GroupSentEmailsController < ApplicationController
  before_action :set_user_and_group_class

  def show
    response_with_object(@group)
  end
  
  def update
    valid = @group.sent_email_users(params[:locale] || 'es')
    response_with_object(@group, valid ? :ok :  :unprocessable_entity)
  end
    
  private

  def set_user_and_group_class
    @group_class = Objects.tolgeo_model_class(params['tolgeo'], 'group')
    @group = @group_class.find(params[:id])
  end

end