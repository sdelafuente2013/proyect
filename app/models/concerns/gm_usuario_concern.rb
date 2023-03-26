module GmUsuarioConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'gm_usuario'
    self.primary_keys = :usuarioid, :gmid
    
    belongs_to :user, :foreign_key => 'usuarioid'
    belongs_to :subject_group, :foreign_key => 'gmid'
    
    scope :by_gmid, lambda { |gmid|
       where('gmid = ?', gmid)
    }

  end
end

