class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include Search

  before_action :set_locale

  private

  def set_locale
    locale = params['locale'] || 'es'

    I18n.locale = locale if locale_available?(locale)
  end

  def locale_available?(locale)
    locale && I18n.available_locales.include?(locale.to_sym)
  end

  def set_backoffice_user
    @backoffice_user = Esp::BackofficeUser.find(params[:current_user_id])
  end
end
