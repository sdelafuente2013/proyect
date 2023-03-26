require 'time'
module DeletedUserConcern
  extend ActiveSupport::Concern

  included do
    include Searchable

    self.table_name = 'deleted_users'
    searchable_by :username
    
    before_save :set_deleted_date
    
    belongs_to :subsystem, :foreign_key => 'subid'
    
    validates :password, :username, :subid, 
              :userid, :fechaalta, 
              :backoffice_user_id, 
              :backoffice_user_name, presence: true
 
    default_scope { order(fechaborrado: :desc) }
       
    def set_deleted_date
      self.fechaborrado = Time.now.utc.strftime('%d-%m-%Y %H:%M:%S')
    end
    
    def self.search_scopes(params)
      joins(:subsystem).includes(:subsystem)
    end
    
    def to_json(options={})
      self.as_json(options)
    end

    def as_json(options={})
      attrs = super options
      attrs[:subid_name] = subid_name
      attrs
    end
    
    def subid_name
      self.subsystem.name
    end

  end
end
