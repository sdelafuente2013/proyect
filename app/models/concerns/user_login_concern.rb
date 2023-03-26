module UserLoginConcern
  extend ActiveSupport::Concern

  # TODO destroy session in controller

  # TODO task saml_assertion # https://developers.onelogin.com/saml/ruby
  # TODO set ticket params ( ticket.email && ticket.username then set external_email and set external_username
  # TODO check_and_create_user_subscription
  # TODO pasar session mirar si ya esta logado con el mismo usuario sino deslogar

  # TODO aceptadaLopd ?
  # TODO traducciones errores en catalan y ingles

  # WEB
  # TODO request.env[‘X_FORWARDED_FOR’] para pasar ips o request.remote_ip probar o request.env['HTTP_X_REAL_IP'] || request.env['REMOTE_ADDR']
  # TODO request.referrer
  # TODO set cookies, remember pass, set session
  # TODO web redirect y permisos
  # TODO setActualizacionesCookies en FRONT porque tiene user.actualizaciones is true

  included do

    after_initialize do
      check_is_user_subscription
    end

    validates :subid, presence: true
    validate :login_is_valid?

    attribute :username, :string, :default => nil
    attribute :password, :string, :default => nil
    attribute :subid, :integer, :default => nil
    # xml
    attribute :saml_assertion, :string, :default => nil

    # auto personalization
    attribute :userid, :integer, :default => nil
    attribute :external_email, :string, :default => nil
    attribute :external_username, :string, :default => nil

    attribute :referer, :string, :default => nil
    attribute :ips, :array, :default => proc { [] }

    attribute :ticket, :string, :default => nil

    attribute :origen, :string, :default => nil
    attribute :origenid, :string, :default => nil
    attribute :gmid, :string, :default => nil
    attribute :sessionid, :string, :default => nil
    attribute :actualizaciones, :boolean, :default => false

    attr_accessor :user_subscription

    def self.authentificate(params)
      login = new(params)
      login.valid?
      session = session_class.create_from_login(login)
      login.sessionid = session.id
      login.actualizaciones = true if !login.origen.blank? && login.user.actualizaciones
      login
    end

    def self.user_subscription_class
      @user_subscription_class = Objects.tolgeo_model_class(tolgeo, 'user_subscription')
    end

    def self.user_class
      @user_class = Objects.tolgeo_model_class(tolgeo, 'user')
    end

    def self.session_class
      @user_session_class = Objects.tolgeo_model_class(tolgeo, 'user_session')
    end

    def self.subsystem_class
      @subsystem_class = Objects.tolgeo_model_class(tolgeo, 'subsystem')
    end

    def self.access_error_class
      @access_error_class = Objects.tolgeo_model_class(tolgeo, 'access_error')
    end

    def self.tolgeo
      self.name.deconstantize.downcase
    end

    def tolgeo
      self.class.name.deconstantize.downcase
    end

    def to_json(options={})
      self.as_json(options)
    end

    def as_json(options={})
      options = (options || {})
      attrs = super options
      attrs["id"]=attrs["sessionid"]
      attrs
    end

    def login_is_valid?
      validate_presence_fields
      validate_user_exists
      validate_password
      validate_datelimit
      validate_exceed_max_connections
      validate_referer
      validate_ips
      validate_gmid
      validate_user_is_demo_when_login_with_user_subscription
    end

    def check_is_user_subscription
      return unless check_has_arroba?(self.username)

      attrs = {
        perusuid: self.username,
        password: self.password,
        subid: self.subid
      }
      self.user_subscription = self.class.user_subscription_class.authenticate(attrs)

      return unless self.user_subscription.class < ActiveRecord::Base && self.user_subscription.user

      self.username = self.user_subscription.user.username
      self.password = self.user_subscription.user.password
    end

    def user
      @user ||= self.class.user_class.by_subject_id(self.subid).by_username_casesensitive(self.username).first
    end

    def subsystem
      @subsystem || self.class.subsystem_class.find(self.subid)
    end

    private

    def check_and_create_user_subscription
      if has_external_data_and_is_user_has_group_with_auth_external?
        # TODO
        #  se buscar una cuenta personalizacion que pertenezca al grupo de usuario y por el username
           # si se encuentra miramos no exista otro usuario con el mismo email en ese caso mantenemos el email de persubscription
        #  sino se buscar una cuenta personalizacion que pertenezca al grupo de usuario y por el email
        #  sino se busca por email y subid

        # then si tenemos perusbscritption actualizamos datos
        # sino se crea la cuenta de personalizacion
      end
    end

    def has_external_data_and_is_user_has_group_with_auth_external?
      external_username && external_email &&  !URI::MailTo::EMAIL_REGEXP.match(external_email).nil? && user.group && user.group.auth_external?
    end

    def should_validate_fields?
      saml_assertion.blank?
    end

    def check_has_arroba?(s)
      !/@/.match(s).nil?
    end

    def validate_user_is_demo_when_login_with_user_subscription
      raise Exception::Login.new(:user_not_permissions, self) if !user_subscription.nil? && user.isdemo
    end

    def validate_presence_fields
      raise Exception::Login.new(:username_required, self) if should_validate_fields? and username.blank?
      raise Exception::Login.new(:password_required, self) if should_validate_fields? and password.blank?
    end

    def validate_user_exists
      raise Exception::Login.new(:invalid_user, self) if user.nil?
    end

    def validate_password
      raise Exception::Login.new(:wrong_password, self) if user.password != self.password
    end

    def validate_datelimit
      raise Exception::Login.new(:user_expired, self) if user.expired?
    end

    def validate_exceed_max_connections
      raise Exception::Login.new(:user_exceed_max_connections, self) if user.exceed_max_connections?
    end

    def validate_referer
      raise Exception::Login.new(:invalid_referer, self) if ticket.nil? and !user.valid_referer?(referer)
    end

    def validate_ips
      raise Exception::Login.new(:invalid_ips, self) unless user.valid_ips?(ips)
    end

    def validate_gmid
      raise Exception::Login.new(:invalid_gmid, self) if !gmid.blank? and !user.gm_usuarios.by_gmid(gmid).exists?
    end

  end

end
