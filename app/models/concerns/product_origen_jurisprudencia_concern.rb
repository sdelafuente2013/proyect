module ProductOrigenJurisprudenciaConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'producto_origen'
    self.primary_keys = :productoid, :origenid

    belongs_to :product, foreign_key: 'productoid'
  end
end
