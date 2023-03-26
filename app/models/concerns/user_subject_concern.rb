module UserSubjectConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'usuario_materia'

    belongs_to :user, :foreign_key => 'usuarioid'
    belongs_to :subject, :foreign_key => 'materiaid'
  end
end
