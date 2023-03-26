class UserMailersController < ApplicationController
  def create
    Users::SendMail.call!(params[:email_type], user_mailer_params)

    head :ok
  end

  private

  def user_mailer_params
    params.permit(:user_id, :tolgeo, extra_params: {}).to_h
  end
end
