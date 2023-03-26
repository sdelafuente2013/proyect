module ProductConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'producto'

    has_many :user_products, :foreign_key => 'productoid', inverse_of: :productos
    has_many :users, through: :user_productos, source: :user
    has_many :product_origen_jurisprudencias, :foreign_key => 'productoid'
    has_many :product_jurisdiccion_jurisprudencias, :foreign_key => 'productoid'
    
    searchable_by :descripcion
    
    def jurisprudencia_origenes
      self.product_origen_jurisprudencias.pluck(:origenid)
    end
    
    def jurisprudencia_jurisdicciones
      self.product_jurisdiccion_jurisprudencias.pluck(:jurisdiccionid)
    end
  end
end

