module JurisprudenciaOrigenConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'despsorigen'
    
    searchable_by :origen
    
    validates :origen,  presence: true, length: {maximum:100}
    validates :orden,  presence: true, numericality: { only_integer: true }
  
    default_scope { order("orden asc") }
  
    scope :by_ids, ->(ids) { (ids.nil? or ids.blank?) ?  all : where(:id => ids) }
    scope :by_padre_id, -> (padre_id) { padre_id.blank? ? all : where(:padre_id => padre_id ) }
    scope :primer_nivel, -> { where('padre_id is null') }
    scope :search_scopes, -> (params) {
      q = autocomplete(params[:q]).by_ids(params[:ids]).by_padre_id(params[:padre_id])
      q = q.primer_nivel if params[:primer_nivel].present? && params[:primer_nivel].to_s.downcase !='false'  && params[:primer_nivel].to_s.downcase != 'off'
      q
    }

    def self.get_uniq_parents
      self.distinct(:padre_id).pluck(:padre_id)
    end

  end
end

