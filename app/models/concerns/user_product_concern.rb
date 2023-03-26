module UserProductConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'usuario_producto'
    self.primary_keys = :usuarioid, :productoid

    belongs_to :user, foreign_key: 'usuarioid'
    belongs_to :product, foreign_key: 'productoid'
  end
end
