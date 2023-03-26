require 'rails_helper'
require 'rake'

RSpec.describe 'modulo_premium_subsystems rake task' do
  before :all do
    Rake.application.rake_require 'tasks/old_rake/modulo_premium_subsystems'
    Rake::Task.define_task(:environment)
  end

  describe ':update' do
    let(:chile_subid) { 7 }
    let(:despachos_moduloid) { 9 }

    before(:example) do
      create(:subsystem_latam, id: chile_subid)
      create(:modulo_latam, id: despachos_moduloid)
      Rake::Task['modulo_premium_subsystems:update'].reenable
    end

    it 'creates premium entry for despachos module in Chile' do
      expect {
        Rake.application.invoke_task 'modulo_premium_subsystems:update'
      }.to change(Latam::ModuloPremiumSubsystem, :count).by(1)

      modulo_premium_subsystem = Latam::ModuloPremiumSubsystem.find_by(subid: chile_subid, moduloid: despachos_moduloid)
      expect(modulo_premium_subsystem).to be
    end

    context 'when premium entry for despachos module in Chile already exists' do
      it 'does not create any new premium entry' do
        create(:modulo_premium_subsystem_latam, subid: chile_subid, moduloid: despachos_moduloid)
        expect {
          Rake.application.invoke_task 'modulo_premium_subsystems:update'
        }.not_to change(Latam::Service, :count)
      end
    end
  end
end
