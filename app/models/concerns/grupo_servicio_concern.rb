module GrupoServicioConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    searchable_by :id

    self.table_name = 'grupo_servicio'
     
  end
end

