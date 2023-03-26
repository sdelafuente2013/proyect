module AccessErrorConcern
  extend ActiveSupport::Concern
  
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Searchable
  
  included do

    REQUEST_TYPE_LOGIN = "LOGIN"

    index({ username: 1 }, { name: "username_index" })
    index({ tipo_error_acceso_id: 1 }, { name: "tipo_error_acceso_id_index" })
    index({ tipo_peticion: 1 }, { name: "tipo_peticion_index" })
    index({ created_at: -1 }, { name: "created_at_index", expire_after_seconds: 5616000 })
    
    default_scope { order(created_at: :desc) }
    
    scope :by_username, -> (username) { username.blank? ? all : where(username: username) }
    scope :by_tipo_error, -> (tipoerror) { tipoerror.blank? ? all : where(tipo_error_acceso_id: tipoerror) }
    scope :by_tipo_peticion, -> (tipopeticion) { tipopeticion.blank? ? all : where(tipo_peticion: tipopeticion) }
    
    field :tipo_error_acceso_id, type: Integer
    field :usuarioid, type: Integer
    field :username, type: String
    field :descripcion, type: String
    field :tipo_peticion, type: String
    field :subid, type: Integer
    field :created_at, type: DateTime, default: Time.current

    def self.search_scopes(params)
      by_username(params[:username]).
      by_tipo_error(params[:tipoerror]).
      by_tipo_peticion(params[:tipopeticion])
    end
    
    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options = {})
      options = (options ||{}).deep_merge(methods: [:tipo_error_acceso])
      attrs = super options
      attrs
    end
    
    def tipo_error_acceso
      tipo_error_acceso_id.nil? ? '' : I18n.t('access_error.tipo_error_acceso_id_%s' % self.tipo_error_acceso_id)
    end  

  end
end
