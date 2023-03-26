# frozen_string_literal: true

module UserPresubscriptionConcern
  extend ActiveSupport::Concern

  include UserSubscription::PasswordManagementConcern

  included do
    include Searchable
    self.table_name = 'per_presubscription'
    alias_attribute :id, :presubscriptionid
    searchable_by :perusuid

    after_initialize :set_creation_date
    after_create :create_lopd_temporal, :send_email

    attr_accessor :user_candidates, :lopd_comercial, :lopd_grupo, :lopd_privacidad
    attr_reader :password

    validates :password, length: { within: 6..32 }, allow_nil: true
    validates :perusuid, :usuarioid, presence: true
    validate :validate_email_not_exists_in_user_subscription, :on => :create
    validate :validate_password_without_blanks

    belongs_to :user, :foreign_key => 'usuarioid', optional: true

    delegate :subid, to: :user

    scope :by_email, lambda { |email|
      email.blank? ? all : where('perusuid = ?', email)
    }

    scope :by_email_like, lambda { |email|
      email.blank? ? all : where('perusuid LIKE ?', '%' + email + '%')
    }

    scope :by_user_id, lambda { |user_id|
      user_id.blank? ? all : where('usuarioid = ?', user_id)
    }

    scope :by_filter_user_subsystem, lambda { |subsystem_ids|
      subsystem_ids.blank? ? all : where("per_subscription.subid" => subsystem_ids)
    }

    def tolgeo
      self.class.name.deconstantize.downcase
    end

    def lopd_aceptacion
      lopdAceptacionClass.by_external(self.id, lopdAceptacionClass::PERSUBSCRIPTION).first
    end

    def self.search_scopes(params)
      by_email(params[:perusuid]).
      by_email_like(params[:email]).
      by_user_id(params[:usuarioid]).
      by_filter_user_subsystem(params[:user_subsystem_ids]).
      joins(:user).includes(:user)
    end

    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options = {})
      options[:methods] ||= []
      options[:methods] += [:id]
      attrs = super(options)
      attrs[:usuario_username] = self.user.username
      attrs
    end

    def self.create(params)
      presubscription = self.new(params)
      presubscription.save

      if presubscription.errors.messages.present?
        raise ActiveRecord::RecordInvalid, presubscription
      end

      presubscription
    end

    def self.import_users(params)
      changes = params.to_h
      error_message = ''

      # Detect already existing user subscriptions
      sample_presubscription = self.new({usuarioid: changes["usuarioid"]})
      subid = sample_presubscription.user.subid
      user_subscription_class = sample_presubscription.userSubscriptionClass
      changes["user_candidates"].each do |user_candidate|
        if user_subscription_class.search_count(perusuid: user_candidate['perusuid'], subid: subid) != 0
          error_message << ', ' unless error_message.blank?
          error_message << I18n.t("user_presubscription.errors.perusuid.many_exist") if error_message.blank?
          error_message << user_candidate['perusuid']
        end
      end

      # Save data
      if error_message.blank?
        error_message = 'Error de guardado de datos'
        begin
          not_valids = changes["user_candidates"].select{|it|self.new( !it.merge({:usuarioid => changes["usuarioid"]})).valid? }

          # hacemos esto para que todos sean validos al crearlos ya que se envia un email en el callback
          not_valids.first.save! unless not_valids.empty?
          ApplicationRecord.transaction do
            changes["user_candidates"].each do |user_candidate|
              new_user = self.new(user_candidate.merge({:usuarioid => changes["usuarioid"]}))
              new_user.save!
            end
          end

          error_message = ''
        end
      end

      error_message
    end

    def userSubscriptionClass
      ("%s::UserSubscription"  % self.tolgeo.capitalize).constantize
    end

    def send_email
      UserPresubscription::ConfirmationMailJob.perform_later({ user_presubscription: self })
    end

    private

    def set_creation_date
      self.creation_date ||= Time.current if self.new_record?
    end

    def create_lopd_temporal
      return if self.tolgeo == "mex"

      lopdAceptacionClass.create!(external_id: self.id,
                                  external_type: lopdAceptacionClass::PERSUBSCRIPTION,
                                  aceptada_lopd_comercial: self.lopd_comercial,
                                  aceptada_lopd_grupo: self.lopd_grupo,
                                  aceptada_lopd: self.lopd_privacidad)
    end

    def lopdAceptacionClass
      ("%s::LopdAceptacionTemporal"  % self.tolgeo.capitalize).constantize
    end

    def validate_email_not_exists_in_user_subscription
      if self.errors.empty? && self.userSubscriptionClass.search_count(:perusuid => self.perusuid, :subid => self.user.subid) != 0
        self.errors[:base] << I18n.t("user_presubscription.errors.perusuid.exists", email: self.perusuid)
        return false
      end
    end

    def validate_password_without_blanks
      return unless password && password.include?(" ")

      errors[:base] << I18n.t("user_presubscription.errors.perusuid.password_blanks")
    end
  end
end
