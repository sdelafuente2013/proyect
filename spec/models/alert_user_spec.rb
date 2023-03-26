require 'rails_helper'

RSpec.describe Esp::AlertUser, type: :model do

  let(:alert_user) { build(:alert_user) }

  it "is instantiable" do
    expect { alert_user = Esp::AlertUser.new }.not_to raise_error
  end

  it "has a valid factory" do
    expect(alert_user).to be_valid
  end

  describe "ActiveModel validations" do
    it { should have_many(:document_alerts) }
    it { expect(alert_user).to validate_presence_of(:email) }
  end

end
