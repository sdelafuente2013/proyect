class UserSubscriptionBaseController < BaseController

  before_action :load_with_params, :only => [:show]
  before_action :retrieve_filters_from_token_parameter, :only => [:create]
  
  def user_session_token_class
    Objects.tolgeo_model_class(params["tolgeo"], "user_session_token")
  end

  def load_with_params
    @item = @item_class.by_user_subscription_id(params[:user_subscription_id]).find(params[:id])
  end
  
  def retrieve_filters_from_token_parameter
    @token_filters=nil
    if item_params["token_id"].present?
      @token_filters = user_session_token_class.where(:id => item_params["token_id"]).first.try(:filters)
    end

  end

end