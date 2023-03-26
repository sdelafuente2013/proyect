# frozen_string_literal: true

class UserSubscriptionsController < ApplicationController
  before_action :set_user_subscription_class

  def index
    response_with_objects(load_user_subscriptions, total_user_subscriptions)
  end

  def show
    response_with_object(load_user_subscription)
  end

  def create
    subscription = create_user_subscription
    response_with_object(subscription, :created)
  end

  def update
    response_with_object(load_user_subscription) if update_user_subscription(load_user_subscription)
  end

  def destroy
    delete_user_subscription(load_user_subscription)
    response_with_no_content
  end

  def request_recover_password
    UserSubscription::RequestRecoverPassword
      .call(
        params[:tolgeo],
        params[:email],
        params[:change_password_url],
        params[:subid]
      )

    head :no_content
  end

  def confirm_update_email
    UserSubscription::ConfirmUpdateEmail
      .call(
        params[:tolgeo],
        params[:new_email],
        params[:current_email],
        params[:api_username],
        params[:update_email_url]
      )

    head :no_content
  end

  def change_password
    user_subscription = UserSubscription::ChangePassword
      .call(
        params[:tolgeo],
        params[:token],
        params[:password]
      )

    json_error_response(user_subscription.errors.to_a) unless user_subscription.valid?
  rescue UserSubscription::ChangePassword::InvalidToken
    json_response({ message: I18n.t("controllers.users_subscriptions.invalid_token") }, :forbidden)
  end

  def confirm_subscription
    user_subscription = UserSubscription::ConfirmSubscription
      .call(
        params[:tolgeo],
        params[:token]
      )

    json_error_response(user_subscription.errors.to_a) unless user_subscription.valid?
  rescue UserSubscription::ConfirmSubscription::InvalidToken
    json_response(
      {
        message: I18n.t("controllers.users_subscriptions.invalid_token_confirmation")
      },
      :forbidden
    )
  end

  def change_email
    user_subscription = load_user_subscription
    user_subscription.update(
      perusuid: params["new_email"]
    )
    json_error_response(user_subscription.errors.to_a) unless user_subscription.valid?
  end

  def validate
    params.require([:perusuid, :password])
    if params[:single]
      user_subscription = auth_user_subscription
      return json_error_response unless !!user_subscription[:perusuid]
      response_with_object(user_subscription)
    else
      subscriptions = load_user_subscriptions
      subscriptions = subscriptions.select{|subscription| subscription.valid_password?(params[:password]) }
      response_with_objects(subscriptions, subscriptions.size)
    end
  end

  protected

  def default_search_param_keys
    super() + %i[perusuid subid usuarioid acceso_tablet news]
  end

  def authenticate_params
    params.permit(:perusuid, :password, :subid, ids: [])
  end

  def load_user_subscriptions
    @user_subscription_class.search(params_with_filter_subsytem_from_backoffice_user)
  end

  def total_user_subscriptions
    @user_subscription_class.search_count(params_with_filter_subsytem_from_backoffice_user)
  end

  def load_user_subscription
    subscription_id = params[:id].presence
    @user_subscription_class.find(subscription_id)
  end

  def create_user_subscription
    @user_subscription_class.create!(user_subscription_params)
  end

  def delete_user_subscription(subscription)
    subscription.destroy
  end

  def update_user_subscription(subscription)
    subscription.update!(user_subscription_params)
  end

  def auth_user_subscription
    @user_subscription_class.authenticate(authenticate_params)
  end

  private

  def user_subscription_params
    params.permit(@user_subscription_class.new.attributes.keys +
       %w[enable_newsletter comercial grupo privacidad sent_email_creation password])
  end

  def set_user_subscription_class
    @user_subscription_class = Objects.tolgeo_model_class(params["tolgeo"], "user_subscription")
  end
end
