class AccessErrorTypesController < ApplicationController

  def index
    error_types = (1..11).map { |i| {:id => i, :name => I18n.t('access_error.tipo_error_acceso_id_%s' % i)} }
    response_with_objects(error_types, error_types.size)
  end

end
