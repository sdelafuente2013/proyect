module ProductJurisdiccionJurisprudenciaConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'producto_jurisdiccion'
    self.primary_keys = :productoid, :jurisdiccionid

    belongs_to :product, foreign_key: 'productoid'
  end
end
