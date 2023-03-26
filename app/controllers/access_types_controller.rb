class AccessTypesController < ApplicationController
  before_action :set_access_type_class

  def index
    data = load_access_types
    response_with_objects(data, data.count)
  end

  private

  def load_access_types
    @access_type_class.all
  end

  def set_access_type_class
    @access_type_class = Objects.tolgeo_model_class(params['tolgeo'], 'access_type')
  end
end
