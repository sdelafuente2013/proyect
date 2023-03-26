module UserTypeSubsystemConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'tipo_usuario_subsystem'

    belongs_to :subsystem, :foreign_key => 'subid'
    belongs_to :user_type_group, :foreign_key => 'tipousuariogrupoid'
    default_scope { order('orden asc') }
  end
end

