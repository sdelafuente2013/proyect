# frozen_string_literal: true

class UserPresubscription::ConfirmationMailJob < ApplicationJob
  def perform(params)
    return unless params[:user_presubscription]

    @params = params
    UserPresubscriptionMailer.with(
      {
        user_presubscription: params[:user_presubscription],
        confirmation_url: confirmation_url
      }
    ).email_passwd_token.deliver_later
  end

  private

  attr_accessor :params

  def confirmation_url
    UserPresubscription::GenerateConfirmationUrl
      .call(
        @params[:user_presubscription],
        @params[:user_presubscription].confirm_presubscription_base_url
      )
  end
end
