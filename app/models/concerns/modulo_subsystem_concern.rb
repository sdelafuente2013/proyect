module ModuloSubsystemConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'modulo_subsystem'
    self.primary_keys = :subid,:moduloid

    belongs_to :subsystem, :foreign_key => 'subid'
    belongs_to :modulo, :foreign_key => 'moduloid'
    default_scope { order('orden asc') }
  end
end

