require 'rails_helper'

describe 'BackofficeUsers API', type: :request do
  
  describe 'update tolgeo with not default tolgeo' do
    before(:example) do
      @tolgeo_esp = create(:tolgeo, description: 'España')
      @tolgeo_mex = create(:tolgeo, description: 'Mexico')
      @tolgeo_latam = create(:tolgeo, description: 'Latam')
      
      @user3 = create(:backoffice_user, 
                     :email => 'nomas@sorianos.com', 
                     :password_digest => BCrypt::Password.create("molamazo"),
                     :tolgeo_default => @tolgeo_esp
                    )
      @tolgeo_backoffice_esp = create(:backoffice_user_tolgeo, :backoffice_user => @user3, :tolgeo => @tolgeo_esp)
      @tolgeo_backoffice_mex = create(:backoffice_user_tolgeo, :backoffice_user => @user3, :tolgeo => @tolgeo_mex)
    end
    
    it "from default tolgeo is " do
      expect(@user3.tolgeo_default).to eq(@tolgeo_esp)
    end

    context 'i update backoffice user with tolgeo latam' do
      it "then the default tolgeo now is latam" do
        put '/esp/backoffice_users/%s' % @user3.id, params: {"backoffice_user_tolgeos_attributes" => {"0" => {'tolgeo_id': @tolgeo_latam.id, "id": "", "_destroy": "0"}, "1" => {'tolgeo_id': @tolgeo_esp.id, "id": @tolgeo_backoffice_esp.id, "_destroy": "1"}, "2" => {'tolgeo_id': @tolgeo_mex.id, "id": @tolgeo_backoffice_mex.id, "_destroy": "1"}}}
        @user3.reload
        expect(@user3.tolgeo_default).to eq(@tolgeo_latam)
      end
    end
    
    context 'i update backoffice without tolgeos' do
      it "then the default tolgeo now is latam" do
        put '/esp/backoffice_users/%s' % @user3.id, params: {"backoffice_user_tolgeos_attributes" => {"0" => {'tolgeo_id': @tolgeo_latam.id, "id": "", "_destroy": "1"}, "1" => {'tolgeo_id': @tolgeo_esp.id, "id": @tolgeo_backoffice_esp.id, "_destroy": "1"}, "2" => {'tolgeo_id': @tolgeo_mex.id, "id": @tolgeo_backoffice_mex.id, "_destroy": "1"}}}
        @user3.reload
        expect(@user3.tolgeo_default).to eq(@tolgeo_esp)
        expect(@user3.active).to eq(false)
        expect(@user3.backoffice_user_tolgeos.count).to eq(0)
      end
    end 
    
  end
  
  before(:example) do
    # associated tolgeo_default must exist for creating a BackofficeUser
    create(:tolgeo, id: 0)
    # associated role must exist for creating BackofficeUserRole
    create(:role, id: 0)
    create(:role, id: 1)
  end
   
  describe_crud(Esp::BackofficeUser, {
    factory: :backoffice_user_with_associations,
    create_params: {
      'email' => 'new_email@mail.com',
      'password' => 'the_password',
      'backoffice_user_roles_attributes' => {
        '0' => {
          'role_id' => 0
        },
        '1' => {
          'role_id' => 1
        }
      },
      'backoffice_user_tolgeos_attributes' => {
        '0' => {
          'tolgeo_id' => 0,
          'backoffice_user_subsystems_attributes' => {
            '0' => {
              'subsystem_id' => 0
            }
          }
        }
      }
    },
    update_params: {
      'email' => 'new_email@mail.com',
      'backoffice_user_tolgeos_attributes' => {
        '0' => {
          'tolgeo_id' => 0,
          'backoffice_user_subsystems_attributes' => {
            '0' => {
              'subsystem_id' => 0
            }
          }
        }
      }
    },
    check_attributes: [
      'email'
    ],
    ignore_attributes: [
      'password'
    ],
    unique_attributes: [
      'email'
    ],
    delete_associations: [
      Esp::BackofficeUserRole,
      Esp::BackofficeUserTolgeo
    ]
  })
end
