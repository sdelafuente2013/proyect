require 'rails_helper'

describe 'AccessErrors Api', type: :request do

  let!(:access_errors_from_tony_login_tipo1) { create_list(:access_error, 8, :username => 'tony',
                                                                             :tipo_error_acceso_id => 1,
                                                                             :tipo_peticion => 'login') }

  let!(:access_errors_from_tony_kk_tipo1) { create_list(:access_error, 4, :username => 'tony',
                                                                             :tipo_error_acceso_id => 1,
                                                                             :tipo_peticion => 'kk') }
  let!(:access_errors_from_tony_kk_tipo2) { create_list(:access_error, 10, :username => 'tony',
                                                                          :tipo_error_acceso_id => 2,
                                                                          :tipo_peticion => 'kk') }

  let!(:access_errors_from_soriano_kk_tipo2) { create_list(:access_error, 14, :username => 'soriano',
                                                           :tipo_error_acceso_id => 2,
                                                           :tipo_peticion => 'kk') }

  let!(:access_errors_from_soriano_login_tipo3) { create_list(:access_error, 6, :username => 'soriano',
                                                              :tipo_error_acceso_id => 3,
                                                              :tipo_peticion => 'login') }

  describe 'GET /access_errors' do

    context 'returns access errors without params' do

      before(:context) do
        Esp::AccessError.destroy_all()
      end

      it 'returns all items paginated' do
        get '/esp/access_errors'
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(25)
        expect(json['total']).to eq(42)
      end

    end

    context 'when i search by username tony' do

      before(:context) do
        Esp::AccessError.destroy_all()
      end

      it 'returns all items paginated' do
        get '/esp/access_errors', params: { username: 'tony' }
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(22)
        expect(json['total']).to eq(22)
      end

    end

    context 'when i search by username soriano' do
      before(:context) do
        Esp::AccessError.destroy_all()
      end

      it 'returns all items paginated' do
        get '/esp/access_errors', params: { username: 'soriano' }
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(20)
        expect(json['total']).to eq(20)
      end

    end

    context 'when i search by username tony and tipo_error_acceso_id=1' do

      before(:context) do
        Esp::AccessError.destroy_all()
      end

      it 'returns all items  paginated' do
        get '/esp/access_errors', params: { username: 'tony', :tipoerror => 1 }
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(12)
        expect(json['total']).to eq(12)
      end

    end

    context 'when i search by username tony and tipo_error_acceso_id=2' do

      before(:context) do
        Esp::AccessError.destroy_all()
      end

      it 'returns all items paginated' do
        get '/esp/access_errors', params: { username: 'tony', :tipoerror => 2 }
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(10)
        expect(json['total']).to eq(10)
      end

    end

    context 'when i search by username tony and tipo_error_acceso_id=2 and tipo_peticion=login' do

      before(:context) do
        Esp::AccessError.destroy_all()
      end

      it 'returns all items paginated' do
        get '/esp/access_errors', params: { username: 'tony', :tipoerror => 1, :tipopeticion => 'login' }
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(8)
        expect(json['total']).to eq(8)
      end

    end

    context 'when i tipo_peticion=kk' do

      before(:context) do
        Esp::AccessError.destroy_all()
      end

      it 'returns all items paginated' do
        get '/esp/access_errors', params: {:tipopeticion => 'kk' }
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(25)
        expect(json['total']).to eq(28)
      end

    end
  end

  describe 'POST /access_error' do
    context 'when the request is valid' do
      it 'creates a access_error' do
        valid_attributes = {
          username: 'tonetti',
          tipo_error_acceso_id: 1,
          tipo_peticion: 'login',
          descripcion: 'Mola mazo'
        }

        post '/esp/access_errors', params: valid_attributes

        expect(response).to have_http_status(201)
        expect(json['object']['descripcion']).to eq('Mola mazo')
        expect(json['object']['id']).to_not be_nil
        expect(json['object']['id'].is_a?(String)).to eq(true)
        expect(json['object']['tipo_error_acceso']).to_not be_nil
        expect(json['object']['created_at']).to_not be_nil
      end
    end
  end

  describe 'GET /access_error_types' do

    context 'returns all access errors types' do

      it 'returns all items' do
        get '/esp/access_error_types'
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(11)
        expect(json['total']).to eq(11)
        expect(json['objects'][0]["id"]).to eq(1)
        expect(json['objects'][0]["name"]).to eq("IP Inválida")
      end

    end
  end

end
