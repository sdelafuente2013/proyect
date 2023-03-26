class UserLoginsController < BaseController
  
  def create
    response_with_object(@item_class.authentificate(item_params), :created)
  end

  private

  def set_item_class
    @item_class = Objects.tolgeo_model_class(params["tolgeo"], "user_login")
  end
  
  def item_params
    params.permit(@item_class.permit_values)
  end

end