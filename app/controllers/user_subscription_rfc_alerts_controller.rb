# frozen_string_literal: true

class UserSubscriptionRfcAlertsController < BaseController
  def user_subscription_class
    Objects.tolgeo_model_class(params['tolgeo'], 'user_subscription')
  end

  def default_search_param_keys
    super() + [:user_subscription_id, :rfc, { rfc_ids: [] }]
  end

  def set_item_class
    @item_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_subscription_rfc_alert')
  end

  def item_params
    params.permit([:user_subscription_id, :rfc, :name])
  end

  def delete_all_params
    params.permit([:user_subscription_id, { rfc_ids: [] }])
  end
end
