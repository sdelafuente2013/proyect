require 'rails_helper'

describe 'Group' do
  it 'can be created' do
    user_type_group = Esp::UserTypeGroup.new(id: 1, descripcion: 'UserTypeGroup descripcion')
    user_type_group.save
    access_type = Esp::AccessType.new(descripcion: 'AccessType description')
    access_type.save
    group = Esp::Group.new(descripcion: 'Group descripcion', tipoid: user_type_group.id)

    result = group.save

    expect(result).to be_truthy
  end

  it 'can delete its users when it is deleted' do
    group = create(:group)
    user = create(:user, group: group)
    backoffice_user = create(:backoffice_user)
    another_user = create(:user, group: group)

    group.destroy_with_users(backoffice_user)

    groups = Esp::Group.all
    users = Esp::User.all
    expect(users.by_group_id(group.id).size).to be_zero
    expect(groups.size).to be_zero
  end

  describe "scope #by_popup_demo " do
    before(:each) do
      create_list(:group,2)
      create_list(:group_show_demo_enabled,3)
      create_list(:group_show_demo_disabled,1)
      @groups = Esp::Group.all
    end

    let(:groups_with_demo_popup_enabled)    { @groups.by_popup_demo('true') }
    let(:groups_with_demo_popup_disabled)   { @groups.by_popup_demo('false') }
    let(:groups_no_filtering_by_demo_popup) { @groups.by_popup_demo('') }

    it { expect(groups_with_demo_popup_enabled.size).to eq 3 }
    it { expect(groups_with_demo_popup_disabled.size).to eq 3 }
    it { expect(groups_no_filtering_by_demo_popup.size).to eq 6 }

  end

end
