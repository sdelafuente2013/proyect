require 'rails_helper'

describe 'Products API', type: :request do
  describe_crud(Esp::Product, show: false, delete: false, check_attributes: ['descripcion'])
end
