module DocumentTypeConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'doctipo'
    alias_attribute :id, :tipoid

    searchable_by :nombre
    
    scope :by_check_permisos, lambda { |has_permisos|
      has_permisos.nil? ? all : where('check_permisos = ?', has_permisos)
    }

    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options = {})
      options[:methods] ||= []
      options[:methods] += [:id]
      super(options)
    end
    
    def self.search_scopes(params)
      by_ids(params[:ids]).
      autocomplete(params[:q]).
      by_check_permisos(params[:check_permisos])
    end  
    
  end
end

