class UserSessionTokensController < BaseController
 
  private

  def set_item_class
    @item_class = Objects.tolgeo_model_class(params["tolgeo"], "user_session_token")
  end
  
  def item_params
    params.permit(["_id", "session_id", "created_at", "updated_at", "filters", "filters" => {}])
  end
  
end