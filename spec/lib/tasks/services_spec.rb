require 'rails_helper'
require 'rake'

RSpec.describe 'services rake task' do
  before :all do
    Rake.application.rake_require 'tasks/old_rake/services'
    Rake::Task.define_task(:environment)
  end

  describe ':update' do
    let(:chile_subid) { 7 }
    let(:despachos_moduloid) { 9 }
    let(:premium_groupid) { 63 }

    before(:example) do
      subsystem_latam = create(:subsystem_latam, id: chile_subid)
      create(:modulo_latam, id: despachos_moduloid)
      create(:service_group_latam, id: premium_groupid, subsystem: subsystem_latam)
      Rake::Task['services:update'].reenable
    end

    it 'creates Gestión Despachos Plus service for Chile' do
      expect {
        Rake.application.invoke_task 'services:update'
      }.to change(Latam::Service, :count).by(1)

      service = Latam::Service.last
      expect(service.clave).to eq('gdespachosplus')
      expect(service.subid).to eq(chile_subid)
      expect(service.moduloid).to eq(despachos_moduloid)
      expect(service.orden).to eq(110)
      expect(service.grupoid).to eq(premium_groupid)
    end

    context 'when Gestión Despachos Plus service for Chile already exists' do
      it 'does not create any new service' do
        create(:servicio_latam_gestion, subid: chile_subid, moduloid: despachos_moduloid, grupoid: premium_groupid)
        expect {
          Rake.application.invoke_task 'services:update'
        }.not_to change(Latam::Service, :count)
      end
    end
  end
end
