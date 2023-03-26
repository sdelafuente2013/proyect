require 'rails_helper'

describe 'Users Subsystems API' do
  describe_crud(Esp::Subsystem, show: false, delete: false, check_attributes: ['name'], ordering: 'id')
end
