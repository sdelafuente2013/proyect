require 'rails_helper'

describe 'Users Api', type: :request do
  let!(:user) { create(:user, :with_presubscriptions) }
  let(:default_subid) { 0 }
  let!(:subsystem) { Esp::Subsystem.where(:id => default_subid).first || create(:subsystem, name: 'Default Subsystem', id: default_subid)}

  before(:each) do
    allow(Esp::Foro).to receive(:new)
  end

  describe 'GET /user_presubscriptions' do
    it 'returns the list of user pending to approved the subscription' do
      get '/esp/user_presubscriptions'

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(5)
      expect(json['total']).to eq(5)
    end

    it 'can be retrieves by user' do
      create(:user, :with_presubscriptions)
      get '/esp/user_presubscriptions', params: { usuarioid: user.id }
      expect(json['objects'].size).to eq(5)
    end
  end

  describe 'POST /user_subscriptions/' do
    context 'when the request is valid and it creates a new user presubscription' do

      let(:valid_attributes) do {
        perusuid: "email@test.com",
        password: "mycontras",
        subid: default_subid,
        usuarioid: user.id
        } end

        before { post '/esp/user_presubscriptions', params: valid_attributes }

        it 'returns status code 200' do
          expect(response).to have_http_status(201)
        end

        it 'returns the new user subscription object' do
          expect(json['object']['perusuid']).to eq('email@test.com')
         end

    end

    context 'when the request is not valid because of the params' do

      shared_examples "invalid_fields" do

        before { post '/esp/user_presubscriptions', params: invalid_params }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to include('Errores de validación')
        end
      end

      describe 'when the email is invalid' do
        it_behaves_like "invalid_fields" do
          let(:invalid_params) do{
            perusuid: 'new_email@host',
            password: 'password123'
          }end
        end
      end

      describe 'when the password is empty' do

        it_behaves_like "invalid_fields" do
          let(:invalid_params) do 
            { perusuid: 'new_email@host.com' } 
          end
        end
      end
    end
  end
end


