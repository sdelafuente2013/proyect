class UserSubscriptionMailersController < ApplicationController
  def create
    UserSubscription::SendMail.call!(params[:email_type], user_mailer_params)

    head :ok
  end

  private

  def user_mailer_params
    params.permit(:user_subscription_id, :tolgeo).to_h
  end
end
