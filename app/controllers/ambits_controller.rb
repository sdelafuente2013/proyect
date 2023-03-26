class AmbitsController < ApplicationController
  before_action :set_ambit_class

  def index
    data = load_ambits
    response_with_objects(data, data.count)
  end

  private

  def load_ambits
    @ambit_class.all
  end

  def set_ambit_class
    @ambit_class = Objects.tolgeo_model_class(params['tolgeo'], 'ambit')
  end
end
