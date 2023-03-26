module UserSessionConcern
  extend ActiveSupport::Concern
  include Mongoid::Document

  included do

    include Searchable
    searchable_by :userId

    ATTRS_USER_SUBSCRIPTION=["subscriptionid", "perusuid", "perusername", "perusupwd", "perusuusuario", "optionsPerSubscription"]

    before_create :set_defaults, :set_attributes_from_user
    before_update :set_attributes_in_session_what_not_setted_in_grails, :set_extend_session, :set_lang_from_locale

    scope :by_user_id, -> (id) { where(userId: id) }

    field :userId, type: String
    field :maxInactiveInterval, type: Integer, default: Proc.new { ENV['SESSION_MAX_INACTIVE_INTERVAL'] || Settings.user_session.max_inactive_interval }
    field :invalidated, type: Boolean, default: false
    field :ultimoAcceso, type: Integer
    field :sessionAttributes, type: Hash, default: {}

    def self.current_millis
      (Time.now.to_f * 1000.0).to_i
    end

    def self.create_from_login(user_login)
      session = self.new(:id => set_id)
      session.set_user(user_login.user)
      session.set_attributes_from_user_subscription(user_login.user_subscription) unless user_login.user_subscription.nil?
      session.sessionAttributes["origenid"]=user_login.origenid unless user_login.origenid.blank?
      session.save!
      session
    end

    def self.set_id
      "%s%s" % [self.new().id.to_s, Time.now.to_i]
    end

    def expired?
      self.invalidated or (self.ultimoAcceso < (self.class.current_millis - (self.maxInactiveInterval * 1000 * 60)))
    end

    def set_invalidate_session
      self.invalidated=true
    end

    def set_extend_session
      self.ultimoAcceso=self.class.current_millis
    end

    def set_lang_from_locale
      self.sessionAttributes["lang"]=I18n.locale.to_s
    end

    def to_json(options={})
      self.as_json(options)
    end

    def as_json(options={})
      options = (options || {})
      attrs = super options
      attrs['expired'] = self.expired?
      attrs
    end

    def tolgeo
      self.class.name.deconstantize.downcase
    end

    def self.tolgeo
      self.name.deconstantize.downcase
    end

    def set_user(user)
      @user=user
      self.userId=user.id.to_s
    end

    def user
      @user ||= Objects.tolgeo_model_class(self.tolgeo, 'user').find(self.userId.to_i)
    end

    def materia
      @materia ||= Objects.tolgeo_model_class(self.tolgeo, 'subject').by_user(self.userId.to_i).first
    end

    def set_defaults
      self.ultimoAcceso=Time.now.to_f * 1000
      self.maxInactiveInterval = self.class.new.maxInactiveInterval
    end

    def set_attributes_from_user_subscription(user_subscription)
      self.sessionAttributes["subscriptionid"]=user_subscription.id
      self.sessionAttributes["perusuid"]=user_subscription.perusuid
      self.sessionAttributes["perusername"]=user_subscription.username
      #TODO: OJO el password en session, ahora mismo copiamos lo mismo de tol
      self.sessionAttributes["perusuusuario"]={id: user_subscription.user.id,
                                               username: user_subscription.user.username}
      self.sessionAttributes["optionsPerSubscription"]=  user_subscription.user.has_options_per_subscription?
    end

    def set_attributes_from_user
      # NOTE: faltan setear mas attributes de TOL, esto es para los create ahora de aqui
      # has_subscription_visible?
      self.sessionAttributes["mySubscriptionVisible"]=user.my_subscription_visible
      # premium
      self.sessionAttributes["usuario_premium"]=user.is_premium?
      # only one materia
      self.sessionAttributes["only_one_materia"]=user.only_one_materia?
      # subid
      self.sessionAttributes["subid"]=user.subid
      # permisos
      self.sessionAttributes["permissions"]=set_permissions_from_user
      # grupo
      self.sessionAttributes["usuario_grupoid"]=user.grupoid || user.class::WITHOUT_GROUP

      set_attributes_in_session_what_not_setted_in_grails
    end

    def set_permissions_from_user
      permissions = {}
      permissions["id"] = user.id
      permissions["modulos"] = user.modulo_ids
      permissions["subjects"]= user.subject_ids
      permissions["products"]= user.product_ids
      permissions["usuario_premium"]=user.is_premium?
      permissions["permissions"]= user.permisos
      permissions["jurisprudencia_origenes"] = user.jurisprudencia_origenes
      permissions["jurisprudencia_jurisdicciones"] = user.jurisprudencia_jurisdicciones
      permissions["number_type_docs"] = self.total_document_types_for_permisos
      permissions
    end

    def set_attributes_in_session_what_not_setted_in_grails
      # materia default
      if self.sessionAttributes.fetch("only_one_materia", false) and !self.sessionAttributes.key?("current_materia")
        self.sessionAttributes["current_materia"]={"id" => materia.id,
                                                   "tema" => materia.tema,
                                                   "translate_name" => materia.translate_name} if materia
      end
      # logo
      unless self.sessionAttributes.key?("user_image")
        self.sessionAttributes["user_image"] = user.logo
      end

      unless self.sessionAttributes.key?("permissions")
        self.sessionAttributes["permissions"] = {}
      end

      # jurisprudencia origenes
      unless self.sessionAttributes["permissions"].key?("jurisprudencia_origenes")
        self.sessionAttributes["permissions"]["jurisprudencia_origenes"] = user.jurisprudencia_origenes
      end
      
      # jurisprudencia origenes
      unless self.sessionAttributes["permissions"].key?("jurisprudencia_jurisdicciones")
        self.sessionAttributes["permissions"]["jurisprudencia_jurisdicciones"] = user.jurisprudencia_jurisdicciones
      end

      # number_tipo_docs
      unless self.sessionAttributes["permissions"].key?("number_type_docs")
        self.sessionAttributes["permissions"]["number_type_docs"] = self.total_document_types_for_permisos
      end

    end

    def remove_user_subscription_attributes
      ATTRS_USER_SUBSCRIPTION.each do |attribute|
        self.sessionAttributes.delete(attribute)
      end
    end

    def document_type_class
      Objects.tolgeo_model_class(self.tolgeo, "document_type")
    end

    def total_document_types_for_permisos
      total = document_type_class.count()
      total-=1 if self.tolgeo == "esp"
      total
    end

  end
end
