require 'rails_helper'

describe 'Roles API', type: :request do

  describe_crud(Esp::Role, {
    create_params: {
      'description' => 'the role description'
    },
    update_params: {
      'description' => 'the new role description'
    },
    check_attributes: [
      'description'
    ],
    unique_attributes: [
      'description'
    ]
  })

end
