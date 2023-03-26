class TolgeosController < ApplicationController
  before_action :set_tolgeo_class
  before_action :load_tolgeo, only: [:show, :update, :destroy]

  def index
    tolgeos = @tolgeo_class.search(search_params)
    tolgeos_total = @tolgeo_class.search_count(search_params)
    response_with_objects(tolgeos, tolgeos_total)
  end

  def show
    response_with_object(@tolgeo)
  end

  def create
    tolgeo = @tolgeo_class.create!(tolgeo_params)
    response_with_object(tolgeo, :created)
  end

  def update
    @tolgeo.update!(tolgeo_params)
    response_with_object(@tolgeo)
  end

  def destroy
    @tolgeo.destroy!
    response_with_no_content
  end

  def default_search_param_keys
    super()+[:name]
  end

  private

  def set_tolgeo_class
    @tolgeo_class = Esp::Tolgeo
  end

  def tolgeo_params
    params.permit(@tolgeo_class.new.attributes.keys)
  end

  def load_tolgeo
    param = params[:id].presence
    @tolgeo = @tolgeo_class.find(param)
  end
end
