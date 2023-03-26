class CountriesController < ApplicationController
  before_action :set_country_class

  def index
    data = load_countries
    response_with_objects(data, data.count)
  end

  private

  def load_countries
    @country_class.search(search_params)
  end

  def default_search_param_keys
    super()+[:subid]
  end

  def set_country_class
    @country_class = Objects.tolgeo_model_class(params['tolgeo'], 'pais')
  end
end

