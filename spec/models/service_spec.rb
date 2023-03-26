require 'rails_helper'

RSpec.describe Latam::Service, type: :model do
  
  before do
    create_or_return_subsytem_latam(7)
    create_or_return_subsytem_latam(1)
    FactoryBot.create(:grupo_servicio_latam, :subid => 1, :id => 65, :name => "premium", :order => 33) 
    FactoryBot.create(:grupo_servicio_latam, :subid => 7, :id => 63, :name => "premium", :order => 32) 

  end
  let(:service) { build(:servicio_latam_biblioteca) }

  it "is instantiable" do
    expect { service = Latam::Service.new }.not_to raise_error
  end

  it "has a valid factory" do
    expect(service).to be_valid
  end

  describe '#scopes' do

    describe '#by_subid' do
      before do
        create(:servicio_latam_biblioteca, grupoid: 63, subid: 7)
        create(:servicio_latam_biblioteca, grupoid: 63, subid: 7)
        create(:servicio_latam_biblioteca, grupoid: 65, subid: 1)
      end

      it 'finds all alerts when app_id blank' do
        expect(Latam::Service.by_subid(nil).size).to eq 3
      end

      it 'filter alerts when app_id not blank' do
        expect(Latam::Service.by_subid(7).size).to eq 2
      end
    end
  end
end
