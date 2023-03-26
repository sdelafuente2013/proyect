require 'rails_helper'
require 'rake'

RSpec.describe 'modulos rake task' do
  before :all do
    Rake.application.rake_require 'tasks/old_rake/modulos'
    Rake::Task.define_task(:environment)
  end

  describe ':update' do
    let!(:colombia_subsystem) { create(:subsystem_latam, name: 'Colombia') }
    let!(:chile_subsystem) { create(:subsystem_latam, name: 'Chile') }
    let!(:latam_subsystem) { create(:subsystem_latam, name: 'Bananalandia') }
    let!(:modulo_despachos) { create(:modulo_latam, id: Latam::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM) }
    let!(:modulo_latam) { create(:modulo_latam) }

    before(:example) do
      Rake::Task['modulos:update'].reenable
      Rake.application.invoke_task 'modulos:update'
    end

    it 'enables Gestión Despachos module for Colombia and Chile' do
      modulo_subsystem_colombia = Latam::ModuloSubsystem.find_by(modulo: modulo_despachos, subsystem: colombia_subsystem)
      expect(modulo_subsystem_colombia).to be
      
      modulo_subsystem_chile = Latam::ModuloSubsystem.find_by(modulo: modulo_despachos, subsystem: chile_subsystem)
      expect(modulo_subsystem_chile).to be

      modulo_subsystem_latam = Latam::ModuloSubsystem.find_by(modulo: modulo_despachos, subsystem: latam_subsystem)
      expect(modulo_subsystem_latam).not_to be
    end
  end
end
