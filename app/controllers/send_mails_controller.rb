# frozen_string_literal: true

class SendMailsController < ApplicationController
  def create
    SendMailBase.call!(params[:email_type], mail_params)

    head :ok
  end

  private

  def mail_params
    params.permit(extra_params: {}).to_h
  end
end
