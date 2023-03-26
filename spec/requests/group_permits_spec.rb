require 'rails_helper'

describe 'Group Permits Api', type: :request do
  let!(:groups) { create_list(:group, 1) }
  let(:group_id) { groups.first.id }
  let!(:user_type_groups) { create_list(:user_type_group, 5) }
  let!(:subsystems) { create_list(:subsystem, 2) }

  let!(:initial_subid) { subsystems.last.id }
  let!(:users_from_group) { create_list(:user, 1,
                                        :grupoid => group_id,
                                        :tipousuariogrupoid => user_type_groups.last.id,
                                        subid: initial_subid) }

  describe 'POST /group_permits' do

    context 'change all users with new tipousuariogrupoid' do
      let(:valid_attributes) { { tipousuariogrupoid: user_type_groups.first.id } }

      before { post "/esp/group_permits", params: valid_attributes.merge(:id => group_id) }

      it 'updates the users from this group' do
        tipousuariogrupoids = Esp::User.where(:grupoid => group_id).pluck(:tipousuariogrupoid).uniq

        expect(tipousuariogrupoids.count).to eq(1)
        expect(tipousuariogrupoids[0]).to eq(user_type_groups.first.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end
    end

    context 'change all users with nothing' do
      let(:valid_attributes) { {} }

      before { post "/esp/group_permits", params: valid_attributes.merge(:id => group_id) }

      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end
    end

    context 'change all users with a different subid' do
      let(:valid_attributes) { { subid: subsystems.first.id } }

      before { post "/esp/group_permits", params: valid_attributes.merge(:id => group_id) }

      it 'does not change subid in any user' do
        subids = Esp::User.where(:grupoid => group_id).pluck(:subid)
        subids.each do |subid|
          expect(subid).to eq(initial_subid)
        end
      end
    end

  end

end
