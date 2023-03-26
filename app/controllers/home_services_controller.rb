class HomeServicesController < BaseController
 
  private

  def set_item_class
    @item_class = Objects.tolgeo_model_class(params["tolgeo"], "service")
  end
  
  def default_search_param_keys
    super()+[:subid]
  end
  
end