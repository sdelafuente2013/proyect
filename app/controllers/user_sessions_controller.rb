class UserSessionsController < ApplicationController
  before_action :set_session_class
  before_action :set_user_session, :only => [:show, :update, :destroy]

  def index
    response_with_objects(load_sessions, 
                          total_sessions)
  end
    
  def show
    response_with_object(@user_session)
  end
  
  def create
    response_with_object(create_item, :created)
  end

  def update
    @user_session.update!
    response_with_object(@user_session)
  end

  def destroy
    @user_session.set_invalidate_session
    @user_session.save!
    response_with_no_content
  end

  private
  
  def load_sessions
    @user_session_class.search(search_params)
  end
  
  def total_sessions
    @user_session_class.search_count(search_params)
  end

  def default_search_param_keys
    super()+[]
  end

  def user_session_params
    params.permit(@user_session_class.new.fields.keys)
  end

  def set_session_class
    @user_session_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_session')
  end
  
  def set_user_session
    @user_session = @user_session_class.find(params[:id])
  end  
  
  def create_item
    @user_session_class.create!(user_session_params)
  end  
end
