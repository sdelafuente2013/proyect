module UserModuloConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'usuario_modulo'
    self.primary_keys = :moduloid,:usuarioid

    belongs_to :user, foreign_key: 'usuarioid'
    belongs_to :modulo, foreign_key: 'moduloid'
  end
end
