module AccessTypeConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'tipo_acceso'

    has_many :users, :foreign_key => 'tipoaccesoid'

    searchable_by :descripcion
  end
end

