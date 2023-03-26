class AccessErrorsController < ApplicationController
  before_action :set_access_error_class

  def index
    response_with_objects(load_access_errors, total_access_errors)
  end

  def create
    access_error = create_access_error
    response_with_object(access_error, :created)
  end

  protected

  def load_access_errors
    @access_error_class.search(search_params)
  end

  def total_access_errors
    @access_error_class.search_count(search_params)
  end

  def create_access_error
    @access_error_class.create!(access_error_params)
  end
  
  def default_search_param_keys
    super()+[:tipopeticion, :username, :tipoerror]
  end

  private

  def access_error_params
    params.permit(@access_error_class.new.fields.keys)
  end

  def set_access_error_class
    @access_error_class = Objects.tolgeo_model_class(params['tolgeo'], 'access_error')
  end
  
end
