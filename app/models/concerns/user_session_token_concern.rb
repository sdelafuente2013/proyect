module UserSessionTokenConcern
  extend ActiveSupport::Concern
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  included do
    
    include Searchable
    searchable_by :id
    
    index({ updated_at: 1}, { expire_after_seconds: 86400 })
    
    field :filters, type: Hash, :default => proc { {} }
    field :session_id, type: String, :default => nil
    
    def filters=(filters=nil)
      self[:filters]=filters || {}
    end
  end
end
