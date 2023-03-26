require 'time'

module UserConcern
  extend ActiveSupport::Concern

  SPAIN_DEFAULT_PERMISSIONS = '00000000000000000000000000000000000'
  MEXICO_DEFAULT_PERMISSIONS = '000000000000000'
  LATAM_DEFAULT_PERMISSIONS = '00000000'
  MEX_TOLGEO = 'mex'
  LATAM_TOLGEO = 'latam'
  WITHOUT_GROUP = 'sin_grupo'

  PERMITTED_ATTR_ACCESSOR = %w(send_user_and_password)

  included do
    include Searchable
    include UserScopes
    include UserForoConcern

    self.table_name = 'usuario'

    before_destroy :nullify_user_subscriptions, :add_to_deleted_user
    before_update :set_has_consultoria_before, prepend: true
    before_save :fill_permission
    before_save :fill_modification_dates
    after_save :update_lopd, :update_acceso_tablet

    attr_accessor :user_candidates, :comercial, :grupo, :privacidad, :modules, :add_perso_account, :backoffice_user, :has_to_send_welcome_email
    PERMITTED_ATTR_ACCESSOR.each{|attr_accessor_name| attr_accessor attr_accessor_name.to_sym }

    has_many :user_subjects, :foreign_key => 'usuarioid', inverse_of: :user, dependent: :delete_all
    has_many :subjects, through: :user_subjects, source: :subject
    has_many :user_modulos, :foreign_key => 'usuarioid', inverse_of: :user, dependent: :delete_all
    has_many :modulos, through: :user_modulos, before_remove: [:set_has_consultoria_before], before_add: [:set_has_consultoria_before]
    has_many :userIps, :foreign_key => 'usuarioid', inverse_of: :user, dependent: :destroy
    has_many :user_subscriptions, :foreign_key => 'usuarioid', inverse_of: :user
    has_many :user_presubscriptions, :foreign_key => 'usuarioid', inverse_of: :user
    has_many :user_products, :foreign_key => 'usuarioid', inverse_of: :user, dependent: :delete_all
    has_many :products, through: :user_products, source: :product
    has_many :userCloudlibraries, :foreign_key => 'usuarioid', inverse_of: :user, dependent: :destroy
    has_many :user_stats, :foreign_key => 'usuario_id', source: :user_stat
    has_many :gm_usuarios, :foreign_key => 'usuarioid', inverse_of: :user, dependent: :destroy
    has_many :commercial_contacts, :foreign_key => 'id_usuario',dependent: :nullify

    belongs_to :access_type, :foreign_key => 'tipoaccesoid'
    belongs_to :user_type_group, :foreign_key => 'tipousuariogrupoid'
    belongs_to :subsystem, :foreign_key => 'subid'
    belongs_to :access_type_tablet, :foreign_key => 'tipoaccesotabletid'
    belongs_to :group, :foreign_key => 'grupoid', optional: true

    validates :password, :maxconexiones, presence: true
    validates :email, presence: true, if: :should_validate_email?

    validates :username, uniqueness: true, presence: true
    validates_format_of :email, :with => /\A([\w+\-].?)+@[a-z\d\-\.]+(\.[a-z]+)*\.[a-z\d]+\z/i, if: :should_validate_email?

    validate :validate_exists_this_email_in_personalization, on: :create, if: :has_create_personalization_account?

    accepts_nested_attributes_for :userIps,
      reject_if: proc { |att| att[:ipfrom].blank? && att[:ipto].blank? },
      :allow_destroy => true

    accepts_nested_attributes_for :userCloudlibraries,
      reject_if: proc { |att| att[:cloud_user].blank? or att[:cloud_password].blank? or att[:moduloid].blank? },
      :allow_destroy => true

    def self.create!(params)
      user = super(params)
    end

    def self.authenticate(params)
      users = self.search_scopes(params)
      users = users.select{ |user| user.password == params[:password] }
    end

    def full_name
      [self.nombre, self.apellidos].select{|it| !it.nil? }.join(" ").strip()
    end

    def get_foroid
      @foroid
    end

    def set_foroid(user_subscription)
      @foroid = "TOL%s" % (user_subscription.oldsubscriptionid.nil? ? user_subscription.id : user_subscription.oldsubscriptionid)
    end

    def self.create_conecta(tolgeo, data, subscription_data)

      user_class = Objects.tolgeo_model_class(tolgeo, 'user')
      subscription_class = Objects.tolgeo_model_class(tolgeo, 'user_subscription')

      ActiveRecord::Base.transaction do
        # user
        attributes = Conecta::User.attributes_for(tolgeo, data)
        user = user_class.by_username(attributes['email']).by_subject_id(attributes['subid']).first
        user = self.new(attributes) unless user
        user.datelimit = Conecta::User.milliseconds_to_time(attributes['datelimit'])
        user.maxconexiones = Conecta::User::MAXCONNECTIONS
        user.comercial = attributes['comercial']
        user.grupo = attributes['grupo']
        user.privacidad = attributes['privacidad']
        user.save

        # subscription
        attributes_subscription = Conecta::User.attributes_for_subscription(tolgeo, user, subscription_data)

        subscription = subscription_class.by_email(attributes['email']).by_subid(attributes['subid']).first
        subscription = subscription_class.new(attributes_subscription) unless subscription

        subscription.assign_attributes(attributes_subscription)
        subscription.save

        user.set_foroid(subscription)

        # DIRECTORIOS ?
        # LOPD ?
        user
      end
    end

    def update_conecta(user_params, subscription_params)
      ActiveRecord::Base.transaction do
        if user_params['datelimit']
          user_params['datelimit'] = Conecta::User.milliseconds_to_time(user_params['datelimit'])
        end

        if user_params['password']
          user_subscription = self.user_subscriptions.first

          user_subscription.update(:password => user_params['password'])
          # LOPD ?
        end

        if !subscription_params['enable_newsletter'].nil?
          self.user_subscriptions.by_email(user_params['email']).first.update(:news => subscription_params['enable_newsletter'])
        end
        user_subscription = self.user_subscriptions.by_email(user_params['email']).first
        user_subscription.user.set_foroid(user_subscription)
        self.update(user_params)

      end
    end

    def modules
      self.modulos.map do |modulo|
        { "id" => modulo.id, "nombre" => modulo.nombre }
      end
    end

    def disable_conecta
      self.maxconexiones = Conecta::User::NO_CONNECTIONS
      self.datelimit = Conecta::User.disable_date
      self.save

      self
    end

    def self.import_users(params, locale=nil)
      changes=params.to_h
      changes_many_keys = ["userIps_attributes", "subject_ids", "modulo_ids", "product_ids"]
      changes_model = changes.reject {|k,v| changes_many_keys.include?(k) or k == "user_candidates" }
      changes_many = changes.reject {|k,v| !changes_many_keys.include?(k) or k == "user_candidates" }
      errors = nil
      usernames = []
      begin

        ApplicationRecord.transaction do

          user_ids=[]
          changes["user_candidates"].each do |user_candidate|
            new_user = new_import_user(changes_model, user_candidate)
            new_user.save!
            user_ids << new_user.id
            send_welcome_email(new_user, locale, ENV['DEFAULT_CC_EMAIL_ATENCION_CLIENTE_MASSIVE'])
            usernames << new_user.username
            # TODO lopd_comercial lopd_grupo
          end

          unless user_ids.empty?

            insert_user_products(changes_many, user_ids)

            insert_user_modulos(changes_many, user_ids)

            insert_user_subjects(changes_many, user_ids)

            insert_user_ips(changes_many, user_ids)

          end

        end

      rescue ActiveRecord::RecordInvalid => e
        errors = e.record.errors
      end

      AdminMailer.with({:usernames => usernames, :errors => errors}).email_massive_import.deliver_later
       # TODO sent email to atencion cliente
    end

    def total_sessions_class
      Objects.tolgeo_model_class(self.class.parent.to_s.downcase, 'user_session')
    end

    def total_sessions
      total_sessions_class.by_user_id(self.id.to_s).count
    end

    def to_json(options={})
      self.as_json(options)
    end

    def as_json(options={})
      if scope_detail?(options)
        options = (options || {}).deep_merge(include: [:userIps, :subjects, :modulos, :products, :userCloudlibraries])
      end

      attrs = super options
      if scope_detail?(options)
        attrs[:total_sessions] = self.total_sessions
        lopd_user = get_lopd_user()
        if !lopd_user.nil?
         attrs[:comercial] = lopd_user.comercial
         attrs[:grupo] = lopd_user.grupo
         attrs[:privacidad] = lopd_user.privacidad
        end
        attrs['foroid'] = self.get_foroid()
      end

      attrs['can_despachos'] = self.subsystem.has_despachos
      attrs['datelimit'] = self.datelimit.strftime('%a %b %d %H:%M:%S UTC %Y') unless self.datelimit.nil?
      attrs['tolgeo'] = self.tolgeo
      attrs
    end

    def tolgeo
      self.class.name.deconstantize.downcase
    end

    def self.tolgeo
      self.name.deconstantize.downcase
    end

    def is_conecta?
      self.tolgeo == "esp" && self.tipousuariogrupoid == Esp::UserTypeGroup::CONECTA
    end

    def only_one_materia?
      self.subjects.count == 1
    end

    def is_premium?
      modulo_premium_ids=Objects.tolgeo_model_class(self.tolgeo, 'modulo').are_premium_by_subid(self.subid).pluck(:id)
      !modulo_premium_ids.blank? ?
          (modulo_premium_ids-self.modulos.pluck(:id)).empty? :
          false
    end

    def is_active?
      self.maxconexiones > 0 && (self.datelimit.nil? or self.datelimit > Date.current)
    end

    def expired?
      !self.datelimit.nil? and self.datelimit < Date.current
    end

    def exceed_max_connections?
      self.maxconexiones == 0 or total_sessions > self.maxconexiones
    end

    def valid_referer?(_refered=nil)
      _refered.nil? or
      self.referer.nil? or
      !_refered.strip().downcase.index(self.referer.strip.downcase).nil?
    end

    def valid_ips?(ips = [])
      userIps.empty? ||
        (
          ips.present? &&
          userIps.any? do |user_ip|
            ips.any? { |ip_address| user_ip.ip_belongs_to_range?(ip_address) }
          end
        )
    end

    def has_consultoria?
      (self.tolgeo == "esp" || self.tolgeo == "mex") && (self.new_record? ? self.modulos.any? {|it| Objects.tolgeo_model_class(self.tolgeo, 'modulo').is_consultoria?(it["id"]) } :
                          self.modulos.merge(Objects.tolgeo_model_class(self.tolgeo, 'modulo').has_consultoria).count() == 1)
    end

    def has_options_per_subscription?
      (is_conecta? or (self.iscolectivo && self.group && self.group.auth_external?)) ? false : true
    end

    def jurisprudencia_origenes
      origen_ids = self.products.map(&:jurisprudencia_origenes).flatten.uniq
      unless origen_ids.empty?
         origen_ids = Objects.tolgeo_model_class(tolgeo, 'jurisprudencia_origen').by_ids(origen_ids).pluck(:id, :padre_id).flatten.uniq
      end
      origen_ids
    end

    def jurisprudencia_jurisdicciones
      self.products.map(&:jurisprudencia_jurisdicciones).flatten.uniq
    end

    def self.insert_user_products(changes_many, user_ids, clean=false)
      user_product = Objects.tolgeo_model_class(self.new.tolgeo, 'user_product')
      if changes_many.key?(:product_ids)
        # products
        items = user_ids.product(changes_many[:product_ids])

        user_product.where(:usuarioid => user_ids).delete_all() if clean
        user_product.import [:usuarioid, :productoid], items, validate:false
      else
        user_product.where(:usuarioid => user_ids).delete_all() if clean
      end

    end

    def self.insert_user_modulos(changes_many, user_ids, clean=false)
      user_modulo = Objects.tolgeo_model_class(self.new.tolgeo, 'user_modulo')
      if changes_many.key?(:modulo_ids)
        # modulos
        items = user_ids.product(changes_many[:modulo_ids])

        user_modulo.where(:usuarioid => user_ids).delete_all() if clean
        user_modulo.import [:usuarioid, :moduloid], items, validate:false
      else
        user_modulo.where(:usuarioid => user_ids).delete_all() if clean
      end
    end

    def self.insert_user_subjects(changes_many, user_ids, clean=false)
      user_subject=Objects.tolgeo_model_class(self.new.tolgeo, 'user_subject')
      if changes_many.key?(:subject_ids)
        # subjects
        items = user_ids.product(changes_many[:subject_ids])

        user_subject.where(:usuarioid => user_ids).delete_all() if clean
        user_subject.import [:usuarioid, :materiaid], items, validate:false
      else
        user_subject.where(:usuarioid => user_ids).delete_all() if clean
      end
    end

    def self.insert_user_ips(changes_many, user_ids, clean=false)
      user_ip=Objects.tolgeo_model_class(self.new.tolgeo, 'user_ip')
      if changes_many.key?(:userIps_attributes)

        items=user_ids.product(changes_many[:userIps_attributes].values.reject {|it|
                                   it["_destroy"] != "0"}.map{|it| [it["ipfrom"], it["ipto"]]}).
                                   map{|it| it.flatten}

        user_ip.where(:usuarioid => user_ids).delete_all() if clean
        user_ip.import [:usuarioid, :ipfrom, :ipto], items, validate:false
      else
        user_ip.where(:usuarioid => user_ids).delete_all() if clean
      end
    end

    def update!(changes)
      result = self.update_attributes!(changes)
      common_updates_user_personalizations(changes)
      TabletPermissionsHelper.update(changes, self)

      unless independent_offices?
        offices_changes = common_updates_offices(changes).merge(specific_updates_offices)
        update_offices_with(offices_changes) unless offices_changes.empty?
      end

      result
    end

    def lopd_app
      Tirantid::LopdApp.by_db_tolgeo(tolgeo).first_or_create
    end

    def lopd_ambito
      (self.is_conecta?)? self.lopd_app.lopd_ambitos.by_name(Tirantid::LopdAmbito::CONECTA).first_or_create :
                            self.lopd_app.lopd_ambitos.by_name(Tirantid::LopdAmbito::DEFAULT).first_or_create
    end

    def get_lopd_user
      self.lopd_ambito.lopd_users.by_external_id(self.id).first
    end

    def destroy!
      deactive_offices unless independent_offices?
      deactivate_user_personalizations

      self.destroy
    end

    def has_consultoria_before
      return false if new_record?

      @has_consultoria
    end

    def has_consultoria_before=(value)
      @has_consultoria = value
    end

    def logo
      user_imagen = self.imagen.blank? ? self.group.try(:imagen) : self.imagen
      user_imagen = user_imagen.present? ? "%s%s" % [ENV["URL_USER_IMAGES"], user_imagen] : nil
      description = self.group.try(:pintanombre) ? self.group.descripcion.capitalize : nil

      {"user_imagen" => user_imagen, "description" => description} if (user_imagen or description)
    end

    def permitted_attr_accessor
      Hash[PERMITTED_ATTR_ACCESSOR.collect { |item| [item, nil] } ]
    end

    def attributes_and_permitted_attr_accessor
      attributes.dup.merge(permitted_attr_accessor)
    end

    private

    def self.searchable_params
      ["grupoid"]
    end

    def fill_modification_dates
      today = Time.now.utc.strftime('%d-%m-%Y %H:%M:%S')

      self.fechaalta = today if self.new_record? && self.fechaalta.nil?
      self.fecharevision = today
    end

    def fill_permission
      permissions = SPAIN_DEFAULT_PERMISSIONS
      permissions = MEXICO_DEFAULT_PERMISSIONS if tolgeo_mex?
      permissions = LATAM_DEFAULT_PERMISSIONS if tolgeo_latam?

      self.permisos = permissions unless has_permissions?
    end

    def has_permissions?
      !self.permisos.nil?
    end

    def tolgeo_mex?
      self.tolgeo == MEX_TOLGEO
    end

    def tolgeo_latam?
      self.tolgeo == LATAM_TOLGEO
    end

    def specific_updates_offices
      {}
    end

    def self.send_welcome_email(user, locale, bcc=ENV['DEFAULT_CC_EMAIL_ATENCION_CLIENTE'])
      all_required_information_present = (locale.present? && user.email.present?)
      send_mail_to_user = all_required_information_present && !user.dont_send_user_and_password
      UserMailer.with(user: user, locale: locale, bcc: bcc).email_user_passwd.deliver_later if send_mail_to_user
    end

    def common_updates_user_personalizations(changes)
      if changes.key?(:maxconexiones)
        deactivate_user_personalizations if changes[:maxconexiones].to_i.zero?
      end

      if changes.key?(:datelimit)
        deactivate_user_personalizations unless allow_connections?
        user_personalization_update_datelimit(changes[:datelimit]) if allow_connections?
      end
    end

    def user_personalization_update_datelimit(datelimit)
      return if personalizations.nil?

      personalizations.each do |personalization|
        personalization.update(datelimit: datelimit)
      end
    end

    def deactivate_user_personalizations
      user_personalization_update_datelimit(DateTime.now)
    end

    def personalizations
      library_connection = CloudLibrary::Connection.new(tolgeo)
      response = CloudLibrary::UserPersonalization.list(library_connection, { usuario_id: self.id })

      response['result']
    end

    def has_offices_premium?
      modulo_ids.include?( Objects.tolgeo_model_class(self.tolgeo, 'modulo').const_get(:MODULE_ID_GESTION_DESPACHOS_PREMIUM) )
    end

    def allow_connections?
      !self.maxconexiones.zero?
    end

    def common_updates_offices(changes)
      new_attributes = {}

      if changes.has_key?(:datelimit)
        new_attributes[:date_limit] = changes[:datelimit] ? Time.parse(changes[:datelimit].to_s).to_date.to_s : nil
      end
      new_attributes[:active] = false if disable_connections?(changes)

      new_attributes
    end

    def disable_connections?(changes)
      !changes[:maxconexiones].nil? && changes[:maxconexiones].to_i.zero?
    end

    def update_offices_with(changes)
      connection = OfficesClient::Connection.new(tolgeo)
      OfficesClient::BackofficeDespacho.updateall(connection, {'usuariotol' => self.id, 'tolgeo' => tolgeo,  'isocode' => iso_code }, changes)
    end

    def deactive_offices
      update_offices_with({ active: false })
    end

    def update_lopd
      lopd_user = get_lopd_user()
      lopd_params = {:comercial => self.comercial,
                     :grupo => self.grupo,
                     :privacidad => self.privacidad}

      if lopd_user.blank?

        Tirantid::LopdUser.create(lopd_params.merge({:lopd_ambito => self.lopd_ambito,
                                                     :subid => self.subid,
                                                     :usuario => self.id,
                                                     :email => self.email,
                                                     :nombre => self.nombre,
                                                     :apellidos => self.apellidos,
                                                     :fax => self.try(:fax),
                                                     :telefono => self.try(:telefono)}))
      else
        changes = lopd_params.select {|i,v| !v.nil? and v != ""}

        (self.saved_changes.keys & ["email", "nombre", "apellidos", "fax", "telefono"]).map {|k| changes[k] = self.send(k) }

        unless changes.empty?
          lopd_user.update(changes)
        end
      end

    end

    def update_acceso_tablet
      if self.saved_change_to_attribute?(:tipoaccesotabletid)
        if self.tipoaccesotabletid == 1 # sin accesso
          self.user_subscriptions.update_all(acceso_tablet: false)
        elsif self.tipoaccesotabletid == 2 # todas las cuentas
          self.user_subscriptions.update_all(acceso_tablet: true)
        elsif self.tipoaccesotabletid == 3 and !self.dominios.blank? # sólo ciertos dominios
          dominios.gsub(' ', '').split(',').each do |domain|
            self.user_subscriptions.where("perusuid like ?", "%"+domain).update_all(acceso_tablet: true)
          end
        else
          self.user_subscriptions.update_all(acceso_tablet: false)
        end
      end
    end

    def nullify_user_subscriptions
      self.user_subscriptions.update_all(
        usuarioid: nil,
        acceso_tablet: false,
        email_alta_tablet: nil,
        token: nil,
        fecha_last_login_tablet: nil,
        fecha_alta_tablet: nil
      )
    end

    def add_to_deleted_user
      attrs={:subid => self.subid,
             :password => self.password,
             :userid => self.id,
             :comentario => self.comentario,
             :fechaalta => self.fechaalta,
             :backoffice_user_id => self.backoffice_user.id,
             :backoffice_user_name => self.backoffice_user.email,
             :username => self.username}
      Objects.tolgeo_model_class(tolgeo, 'deleted_user').create(attrs)
    end

    def scope_detail?(options)
      options.key?(:scope) and options[:scope] == 'detail'
    end

    def format_date(time)
      one_day = 86400
      seconds = time.to_i + one_day

      date = Date.strptime(seconds.to_s, '%s')
      date.strftime('%a %b %d %H:%M:%S UTC %Y')
    end

    def self.new_import_user(changes_model, user_candidate)
      user = self.new(changes_model)
      user.nombre = user_candidate["nombre"]
      user.email = user_candidate["email"]
      user.username = user_candidate["usuario"]
      user.password = user_candidate["password"]

      if !user_candidate["apellido1"].nil? or !user_candidate["apellido2"].nil?
        user.apellidos = [user_candidate["apellido1"], user_candidate["apellido2"]].compact.join(" ")
      end

      user
    end

    def should_validate_email?
      has_create_personalization_account? || (not_collective? && has_consultant?) || has_to_send_welcome_email
    end

    def has_create_personalization_account?
      add_perso_account
    end

    def self.has_to_create_subscription?
      truthy_values = ['true', true]

      truthy_values.include?(params[:add_perso_account])
    end

    def not_collective?
      !iscolectivo
    end

    def has_consultant?
      modulos.any? do |modulo|
        is_consultant_module?(modulo.id)
      end
    end

    def set_has_consultoria_before(_=nil)
      return if new_record?
      return unless @has_consultoria.nil?

      @has_consultoria = has_consultant?
    end

    def validate_exists_this_email_in_personalization
       if self.new_record? && !Objects.tolgeo_model_class(tolgeo, 'user_subscription').by_email(self.email).by_subid(self.subid).first.blank?
         errors.add(:email, I18n.t("user_presubscription.errors.perusuid.exists", email: self.email))
       end
    end
  end

  def dont_send_user_and_password
    false == send_user_and_password
  end
end
