class AlertsController < ApplicationController

  before_action :set_alert_class, :set_alert

  def show
      render json: @alert
  end

  def index
    response_with_objects(@alert_class.search(search_params),
                          @alert_class.search_count(search_params))
  end

  def create
    @alert ||= @alert_class.create_with_alert_user(alert_params)
    render json: @alert.as_json({ include: :alertable }), status: :ok
  end

  def destroy
    @alert.destroy
    render json: {result: 'ok'}
  end

  private

  def set_alert
    @alert= params[:id].present? ? @alert_class.find(params[:id]) : @alert_class.find_alert(alert_params)
  end

  def alert_params
    params.permit(:app_id, :email, :document_id, :document_tolgeo, :alertable_id)
  end

  def search_params
    params.permit(:app_id, :document_id, :document_tolgeo, :alertable_id, :page, :per, :sort, :order)
  end

  def set_alert_class
    @alert_class = Objects.tolgeo_model_class(params['tolgeo'], 'document_alert')
  end
end
