class GroupPermitsController < ApplicationController
  before_action :set_user_and_group_class

  def show
    response_with_object(@group.user_model_with_group_params)
  end

  def create
    valid = @group.update_users(user_params)
    response_with_object(@group, valid ? :created :  :unprocessable_entity)
  end

  private

  def user_params
    params.permit(@user_class.new.attributes.keys +
                  @user_class.nested_attributes_params + ['subject_ids': []] +
                  ['modulo_ids': []] + ['product_ids': []] - ['subid'])
  end

  def set_user_and_group_class
    @group_class = Objects.tolgeo_model_class(params['tolgeo'], 'group')
    @user_class = Objects.tolgeo_model_class(params['tolgeo'], 'user')
    @group = @group_class.find(params[:id])
  end

end