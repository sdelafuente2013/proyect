module SubjectSubsystemConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'materia_subsystem'

    belongs_to :subsystem, :foreign_key => 'subid'
    belongs_to :subject, :foreign_key => 'materiaid'
    default_scope { order('orden asc') }
  end
end

