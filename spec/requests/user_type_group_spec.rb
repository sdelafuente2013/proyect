require 'rails_helper'

describe 'Groups Api', type: :request do
  let!(:user_type_groups) { create_list(:user_type_group, 5) }
  let!(:subsystems) { create_list(:subsystem, 2) }
  let(:subsystem_id) { subsystems.first.id }

  describe 'GET /user_type_groups' do
    it 'returns user type groups' do
      get '/esp/user_type_groups'

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(Esp::UserTypeGroup.count)
    end

    context 'when search for the type groups of a user' do
      it 'returns the list of types' do
        assing_user_type_subsystem

        get '/esp/user_type_groups', params: { subid: subsystem_id }

        expect(json['objects'].size).to eq(Esp::UserTypeGroup.count)
      end
    end
  end

  def assing_user_type_subsystem
    user_type_groups.each_with_index do |user_type_group, index|
      index < 2 ? subsystem = subsystems.first : subsystem = subsystems.last
      create(:user_type_subsystem, :user_type_group => user_type_group, :subsystem => subsystem, :orden => index)
    end
  end
end
