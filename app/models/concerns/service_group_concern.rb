module ServiceGroupConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'grupo_servicio'

    belongs_to :subsystem, foreign_key: 'subid'
  end
end

