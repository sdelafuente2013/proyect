require 'rails_helper'

describe 'BackOffice Login Api', type: :request do
  let(:tolgeo_esp) { create(:tolgeo, name: 'esp', description: 'España') }
  let(:tolgeo_latam) { create(:tolgeo, name: 'latam', description: 'Latinoamérica') }

  let(:plain_password) { 'molamazo' }
  let!(:user) { create(:backoffice_user, 
                       :email => 'nomas@sorianos.com', 
                       :password_digest => BCrypt::Password.create(plain_password),
                       :tolgeo_default => tolgeo_esp
                       )}
  let!(:user2) { create(:backoffice_user, 
                        :email => 'pleasenomas@sorianos.com', 
                        :password_digest => BCrypt::Password.create(plain_password),
                        :tolgeo_default => tolgeo_esp,
                        :active => false
                        )}
  let!(:user_tolgeo_1) { create(:backoffice_user_tolgeo, :tolgeo => tolgeo_esp, :backoffice_user => user) }
  let!(:user_tolgeo_2) { create(:backoffice_user_tolgeo, :tolgeo => tolgeo_latam, :backoffice_user => user) }
  
  let!(:subsystem_1) { create(:backoffice_user_subsystem, :backoffice_user_tolgeo => user_tolgeo_1, 
                                                          :subsystem_id => 1) }
  let!(:subsystem_2) { create(:backoffice_user_subsystem, :backoffice_user_tolgeo => user_tolgeo_2, 
                                                          :subsystem_id => 2) }
  let!(:subsystem_3) { create(:backoffice_user_subsystem, :backoffice_user_tolgeo => user_tolgeo_2, 
                                                          :subsystem_id => 3) }
                                                    
  describe 'POST /backoffice_logins' do
    before do
      user.update(:active => true)
    end
    
    context 'when the request is valid' do
      it 'with valid attributes do login' do
        valid_attributes = {
          email: user.email,
          password: plain_password
        }

        post '/esp/backoffice_logins', params: valid_attributes

        expect(response).to have_http_status(201)

        expect(json['object']['email']).to eq(valid_attributes[:email])
        expect(json['object']['id']).to eq(user.id)
        expect(json['object']['tolgeo_default']['name']).to eq(user.tolgeo_default.name)
        expect(json['object']['backoffice_user_tolgeos'].count).to eq(2)
        expect(json['object']['backoffice_user_tolgeos'][0]['tolgeo_id']).to eq(tolgeo_esp.id)
        expect(json['object']['backoffice_user_tolgeos'][1]['tolgeo_id']).to eq(tolgeo_latam.id)
        expect(json['object']['backoffice_user_tolgeos'][0]['backoffice_user_subsystems'].count).to eq(1)
        expect(json['object']['backoffice_user_tolgeos'][0]['backoffice_user_subsystems'][0]['subsystem_id']).to eq(subsystem_1.subsystem_id)
        expect(json['object']['backoffice_user_tolgeos'][1]['backoffice_user_subsystems'].count).to eq(2)
        expect(json['object']['backoffice_user_tolgeos'][1]['backoffice_user_subsystems'][0]['subsystem_id']).to eq(subsystem_2.subsystem_id)
        expect(json['object']['backoffice_user_tolgeos'][1]['backoffice_user_subsystems'][1]['subsystem_id']).to eq(subsystem_3.subsystem_id)
        expect(json['object']['last_login'].nil?).to eq(false)
      end
    end
    
    context 'with valid attributes but user is desactivated' do
      it 'must return error' do
        valid_attributes = {
          email: user2.email,
          password: plain_password
        }

        post '/esp/backoffice_logins', params: valid_attributes

        expect(response).to have_http_status(401)
        expect(response.body).to match(/Este Usuario ha sido desactivado/)
      end
    end

    context 'with valid email but bad password' do
      it 'must return error' do
        bad_password_attributes = {
          email: user.email,
          password: 'bad_password'
        }

        post '/esp/backoffice_logins', params: bad_password_attributes

        expect(response).to have_http_status(401)
        expect(response.body).to match(/Usuario o password incorrecto/)
      end
    end

    context 'when the request is invalid' do
      before { post '/esp/backoffice_logins', params: { } }

      it 'returns status code 422' do
        expect(response).to have_http_status(401)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Usuario o password incorrecto/)
      end
    end
  end

end
