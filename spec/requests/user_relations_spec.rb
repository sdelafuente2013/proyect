require 'rails_helper'

describe 'User Relations Api', type: :request do
  let!(:users_with_cloudlibrary_user_4) { create_list(:user, 5, :cloudlibrary_user => 4) }
  let!(:users_without_cloud) { create_list(:user, 4) }

  describe 'GET /user_relations' do
    it 'returns users from differents tolgeos with cloudlibrary id' do
      get '/user_relations', params: { cloud_user_id: 4, scope: "detail" }

      expect(response).to have_http_status(200)
      expect(json['total']).to eq(5)
    end

    it 'returns empty list with cloudlibrary id empty' do
      get '/user_relations', params: { cloud_user_id: nil }

      expect(response).to have_http_status(200)
      expect(json['total']).to eq(0)
    end

    it 'returns users with its modules' do
      subsystem = create(:subsystem)
      modulo = create(:modulo)
      servicios = [{
        "id" => modulo.id,
        "nombre" => modulo.nombre,
        "seccionweb" => modulo.seccionweb,
        "key" => nil
      }]
      cloudlibrary_user_id = 5
      user = create(:user, :cloudlibrary_user => cloudlibrary_user_id, :modulos => [modulo])

      get '/user_relations', params: { cloud_user_id: cloudlibrary_user_id, scope: "detail" }
      expect(json['objects'][0]['modulos']).to eq(servicios)
    end
  end
end
