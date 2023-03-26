module ModuloPremiumSubsystemConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'modulo_premium_subsystem'

    belongs_to :subsystem, :foreign_key => 'subid'
    belongs_to :modulo, :foreign_key => 'moduloid'
  end
end

