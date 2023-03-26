module ServiceConcern
  extend ActiveSupport::Concern

  included do

    include Searchable
    searchable_by :subid

    self.table_name = 'servicio'

    belongs_to :modulo, :foreign_key => 'moduloid', optional: true
    belongs_to :grupo_servicio, :foreign_key => 'grupoid'


    scope :by_subid, lambda { |subid|
      subid.blank? ? all : where('servicio.subid = ?', subid)
    }

    scope :by_clave, lambda { |clave|
      clave.blank? ? all : where('servicio.clave = ?', clave)
    }

    def self.search_scopes(params)
      joins(:grupo_servicio).
      by_subid(params[:subid]).
      by_clave(params[:clave]).
      includes(:grupo_servicio)
    end

    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options = {})
      options = (options || {}).merge(:include => {:grupo_servicio => {}})
      attrs = super options
      attrs
    end

  end
end

