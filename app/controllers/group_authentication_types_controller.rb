class GroupAuthenticationTypesController < ApplicationController

  def index
    response_with_objects(authentication_types, authentication_types.size)
  end

  private

  def authentication_types
    [
      { 'id': 0, 'descripcion': 'Tirant' },
      { 'id': 1, 'descripcion': 'Autentifica el Colegio' }
    ]
  end
end
