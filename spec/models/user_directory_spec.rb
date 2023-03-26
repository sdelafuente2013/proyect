require 'rails_helper'

describe 'UserDirectory' do
  it 'can be created' do
    @another_subsystem = Esp::Subsystem.where(:id => 0).first || create(:subsystem, name: 'Another Subsystem', id: 0)
    allow(Esp::Foro).to receive(:new)
    subsystem = create(:subsystem, id: 4)
    user = create(:user, subid: subsystem.id)
    subscription = create(:user_subscription, usuarioid: user.id)
    attributes = {
      type: 0,
      parentdirectoryid: nil,
      childcount: 0,
      description: 'Carpeta Principal',
      persubscription_id: subscription.id
    }

    directory = Esp::UserDirectory.new(attributes)
    result = directory.save

    expect(result).to be_truthy
  end
end
