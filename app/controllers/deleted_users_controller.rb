class DeletedUsersController < ApplicationController
  before_action :set_deleted_user_class

  def index
    response_with_objects(load_deleted_users, total_deleted_users)
  end

  private

  def load_deleted_users
    @deleted_class.search(search_params)
  end

  def total_deleted_users
    @deleted_class.search_count(search_params)
  end

  def set_deleted_user_class
    @deleted_class = Objects.tolgeo_model_class(params['tolgeo'], 'deleted_user')
  end
end
