require 'rails_helper'

RSpec.describe Latam::ServiceGroup, type: :model do
  describe 'ActiveRecord associations' do
    it { should belong_to(:subsystem) }
  end
end
