class UserSubscriptionSearchesController < UserSubscriptionBaseController

  def update
    @item.update!(update_params)
    response_with_object(@item)
  end

  private

  def create_item
    create_params = item_params
    
    unless @token_filters.blank?
      create_params["filters"] = @token_filters
    end
    @item_class.create!(create_params)
  end

  def default_search_param_keys
    super()+[:summary, :alert, :user_subscription_id, :user_subscription_case_id, :subid, :alert_period]
  end

  def set_item_class
    @item_class=Objects.tolgeo_model_class(params['tolgeo'], 'user_subscription_search')
  end
  
  def item_params
    params.permit(["_id", "created_at", "updated_at",
                  "alert_period", "summary", "user_subscription_id", 
                  "user_subscription_case_id", "token_id","subid","paisiso", "filters" => {}])
  end

  def update_params
    params.permit(@item_class.new.attributes.keys).merge({"last_alert_sent": DateTime.now})
  end
end