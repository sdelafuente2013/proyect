require 'rails_helper'

describe 'Tolgeos API', type: :request do

  describe_crud(Esp::Tolgeo, {
    create_params: {
      'name' => 'lalala',
      'description' => 'Lalala description'
    },
    update_params: {
      'name' => 'lolailo'
    },
    check_attributes: [
      'name'
    ],
    unique_attributes: [
      'name'
    ]
  })

end
