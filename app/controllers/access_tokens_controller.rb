class AccessTokensController < ApplicationController
  before_action :set_access_token_class
  before_action :set_access_token_item, :only => [:show]
  
  def show
    response_with_object(@access_token)
  end

  def create
    @access_token = create_access_token
    response_with_object(@access_token, :created)
  end
  
  def destroy
    @access_token_class.where(:id => params[:id]).destroy_all
    response_with_no_content
  end  

  private
  
  def create_access_token
     @access_token_class.create!(access_token_params)
  end
    
  def access_token_params
    params.permit(@access_token_class.new.fields.keys)
  end

  def set_access_token_class
    @access_token_class = Objects.tolgeo_model_class(params['tolgeo'], 'access_token')
  end
  
  def set_access_token_item
    @access_token = @access_token_class.find(params[:id])
  end
  
end
