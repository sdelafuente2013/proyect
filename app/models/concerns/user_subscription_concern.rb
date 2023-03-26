# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Rails/ActiveRecordAliases

module UserSubscriptionConcern
  extend ActiveSupport::Concern

  include UserSubscription::PasswordManagementConcern

  DIRECTORY_TYPE_DOCUMENT = 0
  DIRECTORY_TYPE_INDEX = 1
  DIRECTORY_TYPE_SEARCH = 2

  included do
    include Searchable

    self.table_name = 'per_subscription'
    alias_attribute :id, :subscriptionid
    searchable_by :perusuid
    self.inheritance_column = :_type_disabled

    before_create :fill_creation_date
    after_save :upsert_lopd_user, unless: :tolgeo_mex?

    belongs_to :user, foreign_key: 'usuarioid', optional: true
    belongs_to :subsystem, foreign_key: 'subid'

    has_many :alerts, as: :alertable
    has_many :user_directories,
             foreign_key: 'persubscription_id',
             inverse_of: :user_subscription,
             dependent: :delete_all

    validates :perusuid, presence: true, uniqueness: { scope: :subid, case_sensitive: false }
    validates_format_of :perusuid, with: /\A([\w+\-].?)+@[a-z\d\-\.]+(\.[a-z]+)*\.[a-z\d]+\z/i

    attr_accessor :enable_newsletter, :comercial, :grupo, :privacidad
    attr_reader :password

    scope :by_email, lambda { |email|
      email.blank? ? all : where(perusuid: email)
    }

    scope :by_subid, lambda { |sub_id|
      sub_id.blank? ? all : where('per_subscription.subid': sub_id)
    }

    scope :by_user_id, lambda { |user_id|
      user_id.blank? ? all : where(usuarioid: user_id)
    }

    scope :by_access_tablet, lambda { |access_tablet|
      access_tablet.blank? ? all : where(acceso_tablet: access_tablet)
    }

    scope :by_iscolectivo, lambda { |iscolectivo|
      colectivo = iscolectivo == 'true' ? '1' : '0'
      iscolectivo.blank? ? all : joins(:user).where(usuario: { iscolectivo: colectivo })
    }

    scope :by_filter_user_subsystem, lambda { |subsystem_ids|
      subsystem_ids.blank? ? all : where('per_subscription.subid': subsystem_ids)
    }

    scope :by_news_enabled, lambda { |news_enabled|
      news_enabled.blank? ? all : where('per_subscription.news': news_enabled == 'true')
    }

    def self.get_authenticated_subscriptions(params)
      subscriptions = by_ids(params[:ids]).by_email(params[:perusuid]).by_subid(params[:subid])
      subscriptions.select { |subscription| subscription.valid_password?(params[:password]) }
    end

    def self.authenticate(params)
      subscriptions = get_authenticated_subscriptions(params)
      subscriptions.present? ? subscriptions.first : {}
    end

    def self.search_scopes(params)
      by_ids(params[:ids])
        .autocomplete(params[:q])
        .by_email(params[:perusuid])
        .by_subid(params[:subid])
        .by_user_id(params[:usuarioid])
        .by_access_tablet(params[:acceso_tablet])
        .by_filter_user_subsystem(params[:user_subsystem_ids])
        .by_iscolectivo(params[:iscolectivo])
        .by_news_enabled(params[:news])
        .joins('left join usuario as u on u.id=per_subscription.usuarioid').includes(:user)
        .joins(:subsystem).includes(:subsystem)
    end

    def enable_newsletter=(enable_newsletter)
      self.news = enable_newsletter unless enable_newsletter.nil?
    end

    def self.create!(attributes)
      new_attributes = attributes.dup
      if attributes.key?(:usuarioid)
        user = find_owner(attributes[:usuarioid])
        TabletPermissionsHelper.update_attributes(new_attributes, user)
      end

      send_email = new_attributes[:sent_email_creation]
      new_attributes.delete('sent_email_creation')
      new_attributes.delete(:sent_email_creation)

      subscription = create_subscription(new_attributes)
      create_user_directories_for(subscription)

      if send_email
        UserSubscription::SendAccessDataJob.perform_later({
          user_subscription: subscription
        })
      end

      subscription
    end

    def update!(attributes)
      result = super(attributes)

      upsert_lopd_user

      result
    end

    def to_json(options = {})
      as_json(options)
    end

    def as_json(options = {})
      options[:methods] ||= []
      options[:methods] += [:id]
      attrs = super options

      if scope_detail?(options) && !lopd_user.nil?
        attrs[:comercial] = lopd_user.comercial
        attrs[:grupo] = lopd_user.grupo
        attrs[:privacidad] = lopd_user.privacidad
      end

      attrs[:usuario_username] = user.try(:username)
      attrs[:subid_name] = subsystem.try(:name)
      attrs
    end

    def self.import_users(params)
      changes = params.to_h

      error_message = ''

      # Detect already existing user subscriptions
      sample_subscription = new({ usuarioid: changes['usuarioid'] })
      subid = sample_subscription.user.subid
      changes['user_candidates'].each do |user_candidate|
        next unless search_count(perusuid: user_candidate['perusuid'], subid: subid) != 0

        error_message << ', ' if error_message.present?
        if error_message.blank?
          error_message << I18n.t('user_presubscription.errors.perusuid.many_exist')
        end
        error_message << user_candidate['perusuid']
      end

      # Save data
      if error_message.blank?
        error_message = 'Error de guardado de datos'
        begin
          not_valids = changes['user_candidates'].select do |it|
            new(
              !it.merge({ usuarioid: changes['usuarioid'] })
            ).valid?
          end

          # esto es para que todos sean validos al crearlos ya que se envia un email en el callback
          not_valids.first.save! unless not_valids.empty?
          ApplicationRecord.transaction do
            changes['user_candidates'].each do |user_candidate|
              create!({
                usuarioid: changes['usuarioid'],
                perusuid: user_candidate['perusuid'],
                subid: subid,
                nombre: user_candidate['nombre'],
                apellidos: user_candidate['apellidos'],
                comercial: user_candidate['lopd_comercial'],
                grupo: user_candidate['lopd_grupo'],
                privacidad: true,
                sent_email_creation: true
              })
            end
          end

          error_message = ''
        end
      end

      error_message
    end

    def scope_detail?(options)
      options.key?(:scope) and options[:scope] == 'detail'
    end

    def cases
      user_subscription_case_class.search({ user_subscription_id: id })
    end

    def tolgeo
      self.class.name.deconstantize.downcase
    end

    def session_has_different_user_then_assign_new_user(user_session)
      return unless user.blank? || user.id != user_session.userId.to_i

      new_attributes = {
        usuarioid: user_session.userId.to_i,
        perusuid: perusuid
      }
      TabletPermissionsHelper.update_attributes(new_attributes, user_session.user)
      update(new_attributes)
    end

    def self.updates_after_login_accepted_from(user_subscription, user_session)
      # update user_subscription if user session is distinct ?
      user_subscription.session_has_different_user_then_assign_new_user(user_session)
      # update session attributes
      user_session.set_attributes_from_user_subscription(user_subscription)

      user_session.update!

      user_subscription.password = nil
    end

    private

    def user_subscription_case_class
      Objects.tolgeo_model_class(tolgeo, 'user_subscription_case')
    end

    def fill_creation_date
      date = Time.now.utc.strftime('%d-%m-%Y %H:%M:%S')

      self.creation_date = date
    end

    def upsert_lopd_user
      lopd_params = {
        comercial: comercial,
        grupo: grupo,
        privacidad: privacidad
      }

      if lopd_user.blank?
        Tirantid::LopdUser.create(
          lopd_params.merge({
            lopd_ambito: lopd_ambito,
            subid: subid,
            usuario: id,
            email: perusuid,
            nombre: nombre,
            apellidos: apellidos,
            telefono: telefono
          })
        )
      else
        changes = lopd_params.select { |_, v| !v.nil? and v != '' }
        (saved_changes.keys & ['email', 'nombre', 'apellidos', 'telefono']).map do |k|
          changes[k] = send(k)
        end

        lopd_user.update(changes) unless changes.empty?
      end
    end

    def lopd_app
      Tirantid::LopdApp.by_db_tolgeo(tolgeo).first_or_create
    end

    def lopd_ambito
      lopd_app.lopd_ambitos.by_name(Tirantid::LopdAmbito::PERSONALIZACION).first_or_create
    end

    def lopd_user
      @lopd_user ||= lopd_ambito.lopd_users.by_external_id(id).first
    end

    def self.create_user_directories_for(subscription)
      create_directory(DIRECTORY_TYPE_DOCUMENT, subscription)
      create_directory(DIRECTORY_TYPE_INDEX, subscription)
      create_directory(DIRECTORY_TYPE_SEARCH, subscription)
    end

    def self.create_directory(type, subscription)
      directory = user_directory.new(
        type: type,
        parentdirectoryid: nil,
        childcount: 0,
        description: 'Carpeta Principal',
        user_subscription: subscription
      )

      directory.save
      directory
    end

    def self.create_subscription(attributes)
      subscription = new(attributes)
      subscription.save
      if attributes[:password].present?
        unless attributes[:password].length.between?(6, 32)
          subscription.errors.add(:password, 'Password is not valid')
        end
      end
      raise ActiveRecord::RecordInvalid, subscription unless subscription.errors.messages.empty?

      subscription
    end

    def self.find_owner(id)
      user_class = Objects.tolgeo_model_class(tolgeo, 'user')
      user_class.find(id)
    end

    def self.tolgeo
      name.deconstantize.downcase
    end

    def self.user_directory
      Objects.tolgeo_model_class(tolgeo, 'user_directory')
    end

    def create_foro
      check_foro_is_ok(foro, 'create')
    end

    def check_foro_is_ok(foro, method)
      return if foro.nil?

      return if foro.send(method)

      foro.errores.each do |e|
        errors[:base] << e
      end
    end

    def foro
      return unless allowed_subsystem?

      tolgeo_foro_class.new(
        user_name: foro_username,
        user_email: perusuid,
        user_pass: 'fakePass', # patch for foros's user. BDD-1243
        user_groups: foro_groups,
        user_style: foro_user_style
      )
    end

    def allowed_subsystem?
      subsystem.class::FOROS_NOT_ALLOWED_SUBSYSTEMS.exclude?(subid)
    end

    def foro_username
      username = oldsubscriptionid
      username = id if oldsubscriptionid.nil?
      "#{prefix}#{username}"
    end

    def foro_groups
      return "#{foro_group_name},#{prefix_grupo}#{user.username}" if user_consultant_and_collective?

      foro_group_name
    end

    def foro_group_name
      tolgeo_foro_class::TOLGEO_SUBID_PERMISOS[subid.to_s.to_sym]
    end

    def user_consultant_and_collective?
      return false if user.nil?

      user.has_consultoria? && user.iscolectivo
    end

    def foro_user_style
      tolgeo_foro_class::TOLGEO_SUBID_STYLES[subid.to_s.to_sym]
    end

    def prefix
      tolgeo_foro_class::TOLGEO_SUBID_PREFIX[subid.to_s.to_sym]
    end

    def prefix_grupo
      return tolgeo_foro_class::TOLGEO_PREFIXGRUPO[subid.to_s.to_sym] if tolgeo == 'mex'

      tolgeo_foro_class::TOLGEO_PREFIXGRUPO
    end

    def tolgeo_mex?
      tolgeo == 'mex'
    end

    def tolgeo_latam?
      tolgeo == 'latam'
    end

    def tolgeo_foro_class
      "#{tolgeo.capitalize}::Foro".constantize
    end
  end
end

# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Rails/ActiveRecordAliases
