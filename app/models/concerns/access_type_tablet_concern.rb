module AccessTypeTabletConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'tipo_acceso_tablet'

    has_many :users, :foreign_key => 'tipoaccesotabletid'

    searchable_by :descripcion
  end
end

