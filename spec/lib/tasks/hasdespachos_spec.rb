require 'rails_helper'
require 'rake'

RSpec.describe 'hasdespachos rake task' do
  before :all do
    Rake.application.rake_require 'tasks/old_rake/hasdespachos'
    Rake::Task.define_task(:environment)
  end

  describe ':update' do
    let!(:spain_subsystems) { create_list(:subsystem, 2, has_despachos: false) }
    let!(:mexico_subsystems) { create_list(:subsystem_mex, 2, has_despachos: false) }
    let!(:colombia_subsystem) { create(:subsystem_latam, name: 'Colombia', has_despachos: false) }
    let!(:chile_subsystem) { create(:subsystem_latam, name: 'Chile', has_despachos: false) }
    let!(:latam_subsystem) { create(:subsystem_latam, name: 'Bananalandia', has_despachos: false) }

    before(:example) do
      Rake::Task['hasdespachos:update'].reenable
      Rake.application.invoke_task 'hasdespachos:update'
    end

    it 'sets has_despachos to true for all subsystems in Spain' do
      expect(spain_subsystems.map{ |s| s.reload.has_despachos? }.uniq).to eq([true])
    end

    it 'sets has_despachos to true for all subsystems in Mexico' do
      expect(mexico_subsystems.map{ |s| s.reload.has_despachos? }.uniq).to eq([true])
    end

    it 'sets has_despachos to true for Colombia and Chile subsystems in Latam' do
      expect(colombia_subsystem.reload.has_despachos?).to eq(true)
      expect(chile_subsystem.reload.has_despachos?).to eq(true)
      expect(latam_subsystem.reload.has_despachos?).to eq(false)
    end
  end
end
