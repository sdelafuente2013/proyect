module SubjectConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'materia'
    has_many :user_subjects, :foreign_key => 'materiaid', inverse_of: :subject
    has_many :users, through: :user_subjects, source: :user
    
    has_many :subject_subsystems, foreign_key: 'materiaid'
    
    scope :by_subsystem, -> (subid) { subid.blank? ? all : joins(:subject_subsystems).where('materia_subsystem.subid = ?', subid) }
    
    scope :by_user, -> (userid) { userid.blank? ? all : joins(:user_subjects).where('usuario_materia.usuarioid = ?', userid) }

    searchable_by :nombre

    def self.search_scopes(params)
      by_ids(params[:ids]).
      by_subsystem(params[:subid]).
      by_user(params[:userid])
    end
    
    def translate_name
      I18n.t('materia.esp.%s' % self.id.to_s)
    end  
    
    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options = {})
      options = (options || {})
      attrs = super options
      attrs["translate_name"] = self.translate_name
      attrs
    end

  end
end

