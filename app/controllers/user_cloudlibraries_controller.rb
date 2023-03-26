class UserCloudlibrariesController < ApplicationController
  before_action :set_user_cloudlibrary_class
  before_action :load_user_cloudlibrary, :only => [:update, :destroy, :show]

  def index
    response_with_objects(load_items, total_items)
  end
  
  def show
    response_with_object(@user_cloudlibrary)
  end

  def update
    update_user_cloudlibrary
    response_with_object(@user_cloudlibrary)
  end
  
  def destroy
    delete_user_cloudlibrary
    response_with_no_content
  end

  def create
    user = create_user
    response_with_object(user, :created)
  end
  
  private

  def load_items
    @user_cloudlibrary_class.search(search_params)
  end

  def total_items
    @user_cloudlibrary_class.search_count(search_params)
  end
  
  def load_user_cloudlibrary
    user_id = params[:id].presence
    @user_cloudlibrary = @user_cloudlibrary_class.find(user_id)
  end
  
  def update_user_cloudlibrary
    @user_cloudlibrary.update(user_cloudlibrary_params)
  end
  
  def delete_user_cloudlibrary
    @user_cloudlibrary.destroy
  end
  
  def create_user
    @user_cloudlibrary_class.create!(user_cloudlibrary_params)
  end
  
  def default_search_param_keys
    super()+[:subid,:usuarioid,:moduloid]
  end

  def set_user_cloudlibrary_class
    @user_cloudlibrary_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_cloudlibrary')
  end
  
  def user_cloudlibrary_params
    params.permit(@user_cloudlibrary_class.new.attributes.keys)
  end
  
end

