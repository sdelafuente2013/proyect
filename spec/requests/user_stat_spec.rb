require 'rails_helper'

describe 'User Stats Api', type: :request do
  let!(:user_1) { create(:user, nif: '123NIF') }
  let!(:user_2) { create(:user) }
  let!(:user_3) { create(:user) }
  let!(:user_stats_user_1) { 10.times.map{|i| create(:user_stat, :user => user_1, :fecha => i.month.ago.to_date, :sesiones => i+1, :documentos => (i+1)*2)}}
  let!(:user_stats_user_2) { 10.times.map{|i| create(:user_stat, :user => user_2, :fecha => i.month.ago.to_date)} }
  let!(:user_stats_user_3) { 10.times.map{|i| create(:user_stat, :user => user_3, :fecha => i.month.ago.to_date)} }

  describe 'GET INDEX /user_stats' do

    context 'without params' do
      it 'returns list of user stats' do
        get '/esp/user_stats',  params: {}

        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(3)
      end
    end

    context 'with userid' do
      it 'returns one object with the user total of users stats' do
        get '/esp/user_stats', params: {user_id: user_1.id}

        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(1)
        expect(json['objects'][0]['sesiones']).to eq(user_stats_user_1.sum(&:sesiones))
        expect(json['objects'][0]['documentos']).to eq(user_stats_user_1.sum(&:documentos))
      end
    end

    context 'with userid and not_grouped' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {user_id: user_1.id, not_grouped: true}

        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(10)
        expect(json['objects'][0]['sesiones']).to eq(1)
        expect(json['objects'][0]['documentos']).to eq(2)
      end
    end


    context 'with userid and 2 month ago' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {user_id: user_1.id, period: 2}
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(1)
      end
    end

    context 'with userid and 1 month ago' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {user_id: user_1.id, period: 1}
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(1)
      end
    end

    context 'with userid and period and and 1 month ago and sessions < 10 or documents < 10' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {user_id: user_1.id, period: 1, num_sessions: 10, num_documents: 10}
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(1)
        expect(json['objects'][0].key?("usuario_id")).to eq(true)
        expect(json['objects'][0].key?("sesiones")).to eq(true)
        expect(json['objects'][0].key?("documentos")).to eq(true)
        expect(json['objects'][0].key?("user")).to eq(true)
        expect(json['objects'][0]["user"].key?("id")).to eq(true)
        expect(json['objects'][0]["user"].key?("username")).to eq(true)
        expect(json['objects'][0]["user"].key?("email")).to eq(true)
        expect(json['objects'][0]["user"].key?("nif")).to eq(true)
      end
    end

    context 'with userid and period and and 1 month ago and sessions < 1 or documents < 1' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {user_id: user_1.id, period: 1, num_sessions: 1, num_documents: 1}
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(0)
      end
    end

    context 'with nif' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {nif: user_1.nif}
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(1)
      end
    end

    context 'with cif' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {cif: user_1.nif}
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(1)
      end
    end

    context 'with user and fecha_start but no fecha_end and not_grouped' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {user_id: user_1.id, fecha_start: 1.month.ago.to_date.to_s, not_grouped: true}
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(2)
      end
    end

    context 'with user and fecha_end but no fecha_start and not_grouped' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {user_id: user_1.id, fecha_end: 1.month.ago.to_date.to_s, not_grouped: true}
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(9)
      end
    end

    context 'with user and fecha_end but and fecha_start and not_grouped' do
      it 'returns list of users stats' do
        get '/esp/user_stats', params: {user_id: user_1.id, fecha_start: 2.month.ago.to_date.to_s, fecha_end: 1.month.ago.to_date.to_s, not_grouped: true}
        expect(response).to have_http_status(200)
        expect(json['objects'].size).to eq(2)
      end
    end

  end
end
