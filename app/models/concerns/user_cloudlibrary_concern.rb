module UserCloudlibraryConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'usuario_cloudlibrary'

    belongs_to :user, :foreign_key => 'usuarioid', inverse_of: :userCloudlibraries
    belongs_to :modulo, :foreign_key => 'moduloid'

    searchable_by :cloud_user

    validates :user, :modulo, :cloud_user, :cloud_password, presence: true
    validates :moduloid, uniqueness: { scope: :usuarioid }

    scope :by_modulo, lambda { |modulo_id|
      modulo_id.blank? ? all : where('usuario_cloudlibrary.moduloid = ?', modulo_id)
    }
    
    scope :by_usuario, lambda { |usuario_id|
      usuario_id.blank? ? all : where('usuario_cloudlibrary.usuarioid = ?', usuario_id)
    }
    
    def self.search_scopes(params)
      by_ids(params[:ids]).
      autocomplete(params[:q]).
      by_modulo(params[:moduloid]).
      by_usuario(params[:usuarioid])
    end

    def to_json(options={})
      self.as_json(options)
    end
    
  end
  
end
