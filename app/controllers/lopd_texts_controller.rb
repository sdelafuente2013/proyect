# frozen_string_literal: true

class LopdTextsController < ApplicationController
  def index
    response_with_object({ content: I18n.t("lopd", locale: params[:locale]) })
  end
end
