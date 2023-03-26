class AccessTypeTabletsController < ApplicationController
  before_action :set_access_type_tablet_class

  def index
    data = load_access_type_tablets
    response_with_objects(data, data.count)
  end

  private

  def load_access_type_tablets
    @access_type_tablet_class.all
  end

  def set_access_type_tablet_class
    @access_type_tablet_class = Objects.tolgeo_model_class(params['tolgeo'], 'access_type_tablet')
  end
end

