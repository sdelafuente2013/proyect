module PaisConcern
  extend ActiveSupport::Concern
  include Searchable
  
  included do

    self.table_name = 'desppaislatam'
    searchable_by :nombre

    SPAIN = 1
    MEXICO = 2
    belongs_to :subsystem, :foreign_key => 'subid'
    
    validates :codigo, presence:true, numericality: { only_integer: true }
    validates :codigo_iso, presence:true, length: {maximum:3}
    validates :nombre, presence:true, length: {maximum:256}
    validates :subid, presence:true

    validates_uniqueness_of :codigo_iso, case_sensitive: false
    validates_uniqueness_of :codigo_iso_2digits, case_sensitive: false
    validates_uniqueness_of :subid

    default_scope { order("nombre asc") }

    scope :by_iso_code, ->(iso_code) { where(:codigo_iso => iso_code ) }
    scope :by_iso_code_2digits, ->(iso_code) { where(:codigo_iso_2digits => iso_code ) }
    scope :by_subsystem, -> (subid) { subid.blank? ? all : where('subid = ?', subid) }
    
    def self.search_scopes(params)
      by_ids(params[:ids]).
      by_subsystem(params[:subid]).
      joins(:subsystem).
      includes(:subsystem)
    end

  end

end
