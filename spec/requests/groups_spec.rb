require 'rails_helper'

describe 'Groups API', type: :request do

  context 'Testing CRUD' do
    before(:example) do
      create(:user_type_group, id: 0)
    end

    describe_crud(Esp::Group, {
      delete: false,
      create_params: {
        'descripcion' => 'Colegio de Abogados Tirant',
        'tipoid' => 0
      },
      update_params: {
        'descripcion' => 'Shopping',
      },
      check_attributes: [
        'descripcion'
      ]
    })
  end

  describe 'DELETE /esp/groups/:id' do
    let!(:group) { create(:group) }
    let!(:group_id) { group.id }
    let!(:user) { create(:user, grupoid: group.id) }
    let!(:user_id) { user.id }
    let!(:backoffice_user) { create(:backoffice_user) }

    after(:example) do
      expect{ Esp::Group.find(group_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'keeping users' do
      after(:example) do
        expect{
          u = Esp::User.find(user_id)
          expect(u.grupoid).to be_nil
        }.to_not raise_error
      end

      context 'when remove_users is not present' do
        it 'removes group and nullifies reference on users' do
          delete "/esp/groups/#{group.id}?current_user_id=#{backoffice_user.id}"
        end
      end

      context 'when remove_users is false' do
        it 'removes group and nullifies reference on users' do
          delete "/esp/groups/#{group.id}?current_user_id=#{backoffice_user.id}", params: { remove_users: false }
        end
      end
    end

    context 'when remove_users is true' do
      it 'removes group and its users' do
        delete "/esp/groups/#{group.id}?current_user_id=#{backoffice_user.id}", params: { remove_users: true }
        expect{ Esp::User.find(user_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end
