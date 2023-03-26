require 'rails_helper'

describe 'Groups Api', type: :request do
  describe 'GET /group_authentication_types' do
    it 'returns group auth types' do
      get '/esp/group_authentication_types'

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(2)
    end
  end
end

