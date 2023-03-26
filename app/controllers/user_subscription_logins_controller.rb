class UserSubscriptionLoginsController < BaseController

  before_action :set_session
  before_action :set_subscription, :only => [:create]

  def create
    json_response({ message: I18n.t("user_subscription_login.errors.invalid_session") }, :unprocessable_entity) and return if @user_session.expired?
    if @user_subscription.present?
      @item_class.updates_after_login_accepted_from(@user_subscription, @user_session)
      response_with_object(@user_subscription, :created)
    else
      json_response({ message: I18n.t("user_subscription_login.errors.invalid")}, :unauthorized)
    end
  end

  def destroy
    @user_session.remove_user_subscription_attributes
    @user_session.update!
    response_with_no_content
  end

  private

  def set_item_class
    @item_class = Objects.tolgeo_model_class(params["tolgeo"], "user_subscription")
  end

  def set_session
    @user_session_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_session')
    @user_session = @user_session_class.find(item_params[:sessionid] || params[:id])
  end

  def set_subscription
    @user_subscription = @item_class.authenticate(item_params)
  end

  def load_item
    set_session
  end

  def item_params
    params.permit(["perusuid", "password", "subid", "sessionid"])
  end

end
