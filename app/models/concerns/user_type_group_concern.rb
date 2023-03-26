module UserTypeGroupConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    CONECTA = 24
    self.table_name = 'tipo_usuario_grupo'

    has_many :users, :foreign_key => 'tipousuariogrupoid'

    searchable_by :descripcion
  end
end

