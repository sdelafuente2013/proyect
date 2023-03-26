class CommercialContactOriginsController < BaseController
  
  def index
    origins = @item_class.list_origins
    response_with_objects(origins, origins.count)
  end
  
  def set_item_class
    @item_class = Objects.tolgeo_model_class(params['tolgeo'], 'commercial_contact')
  end

end