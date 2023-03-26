class DocumentAlertsController < ApplicationController

  before_action :set_alert_class, :set_alert
  before_action :set_alert, :except => [:index]

  def show
    response_with_object(@alert)
  end

  def index
    response_with_objects(@alert_class.search(search_params),
                          @alert_class.search_count(search_params))
  end

  def create
    @alert ||= @alert_class.create_with_alert_user(alert_params)
    response_with_object(@alert, :created)
  end

  def update
    response_with_object(@alert) if @alert.update!(update_alert_params)
  end

  def destroy
    @alert.destroy
    response_with_no_content
  end

  private

  def set_alert
    @alert= params[:id].present? ? @alert_class.find(params[:id]) : (@alert_class.find_alert(alert_params) unless alert_params.reject{|k,v| v.blank?}.empty?)
  end

  def alert_params
    params.require([:app_id,:document_id, :document_tolgeo])
    params.permit(:app_id, :document_id, :document_tolgeo, :email, :alertable_id).tap do |_alert_params|
      raise ActionController::ParameterMissing.new('email or alertable_id') unless (_alert_params[:email].present? or _alert_params[:alertable_id].present?)
    end
  end

  def search_params
    params.permit(:app_id, :document_id, :document_tolgeo, :alertable_id, :alert_date, :page, :per, :sort, :order).tap do |_search_params|
      raise ActionController::ParameterMissing.new('document_id and document_tolgeo both must be empty or valued') unless _search_params[:document_id].present? == _search_params[:document_tolgeo].present?
    end
  end

  def update_alert_params
    params.permit(:alert_date)
  end

  def set_alert_class
    @alert_class = Objects.tolgeo_model_class(params['tolgeo'], 'document_alert')
  end
end
