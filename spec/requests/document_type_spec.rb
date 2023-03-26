require 'rails_helper'

describe 'Users DocumentTypes API', type: :request do
  describe_crud(Esp::DocumentType, show: false, delete: false, check_attributes: ['nombre'], ordering: 'tipoid')
end
