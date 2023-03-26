class SubsystemsController < ApplicationController
  before_action :set_subsystem_class

  def show
    response_with_object(load_subsystem)
  end
  
  def index
    data = load_subsystems
    response_with_objects(data, data.count)
  end

  private

  def load_subsytem
    @subsystem_class.find(params[:id])
  end
    
  def load_subsystems
    @subsystem_class.all
  end

  def set_subsystem_class
    @subsystem_class = Objects.tolgeo_model_class(params['tolgeo'], 'subsystem')
  end
end

