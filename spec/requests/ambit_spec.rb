require 'rails_helper'

describe 'Users Ambits API', type: :request do
  describe_crud(Esp::Ambit, show: false, delete: false, check_attributes: ['nombre','orden'])
end
