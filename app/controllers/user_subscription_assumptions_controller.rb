class UserSubscriptionAssumptionsController < UserSubscriptionBaseController

  private

  def create_item
    create_params = item_params
    unless @token_filters.blank?
      create_params["filters"].merge!(@token_filters)
    end
    @item_class.create!(create_params)
  end

  def default_search_param_keys
    super()+[:title, :user_subscription_id, :user_subscription_case_id]
  end
  
  def set_item_class
    @item_class=Objects.tolgeo_model_class(params['tolgeo'], 'user_subscription_assumption')
  end
  
  def item_params
    params.permit(["_id", "created_at", "updated_at", "token_id",
                  "title", "summary", "user_subscription_id", 
                  "user_subscription_case_id", "filters" => {}])
    
  end
end