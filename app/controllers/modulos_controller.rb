class ModulosController < ApplicationController
  before_action :set_module_class

  def index
    response_with_objects(load_modules, total_modules)
  end

  private

  def load_modules
    @module_class.search(search_params)
  end

  def total_modules
    @module_class.search_count(search_params)
  end

  def set_module_class
    @module_class = Objects.tolgeo_model_class(params['tolgeo'], 'modulo')
  end

  def default_search_param_keys
    super()+[:subid, :premium_subid, :not_formation, :nombre, :key]
  end
end
