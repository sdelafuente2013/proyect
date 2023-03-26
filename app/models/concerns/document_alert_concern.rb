# frozen_string_literal: true

module DocumentAlertConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'alerts'

    include Searchable

    before_validation :set_alert_date

    belongs_to :alertable, polymorphic: true

    validates_presence_of :document_id, :document_tolgeo, :alertable, :alert_date

    scope :by_app_id, ->(app_id) { app_id.blank? ? all : where(app_id: app_id) }
    scope :by_email, ->(email) do
      if email.blank?
        all
      else
        joins('INNER JOIN alert_users ON alert_users.id = alerts.alertable_id')
          .where('alert_users.email=?', email)
          .where(alertable_type: alert_user_model_class)
      end
    end
    scope :by_docid, ->(docid) { docid.blank? ? all : where(document_id: docid) }
    scope :by_document_tolgeo, ->(tolgeo) { tolgeo.blank? ? all : where(document_tolgeo: tolgeo) }
    scope :by_alert_date_gt, ->(from_date) do
      if from_date.blank?
        all
      else
        date = from_date.respond_to?(:getutc) ? from_date : Date.parse(from_date)
        where('alert_date >= ?', date.beginning_of_day)
      end
    end
    scope :by_subscriptionid, ->(subscriptionid) do
      if subscriptionid.blank?
        all
      else
        where({ alertable_id: subscriptionid, alertable_type: user_subscription_model_class })
      end
    end

    def securityKeyParam
      Digest::MD5.hexdigest("#{email}#{document_id}#{alertable&.id}TNRT")
    end

    def securityKeyDestroyParam
      Digest::MD5.hexdigest("#{id}TNRT")
    end

    alias_method :sk, :securityKeyParam
    alias_method :dsk, :securityKeyDestroyParam

    def email
      if alertable.respond_to?(:email)
        alertable&.email
      else
        alertable&.perusuid
      end
    end

    def as_json(options={})
      options = (options || {}).deep_merge(methods:[:tolgeo, :email, :sk, :dsk, :locale] )
      super(options)
    end

    def to_json(options={})
      self.as_json(options)
    end

    def self.create_with_alert_user(alert_params)
      if !alert_params[:alertable_id].blank?
        user_subscription = user_subscription_model_class.find(alert_params[:alertable_id])
        create(
          alert_params
            .slice(:app_id, :document_id, :document_tolgeo)
            .merge(alertable: user_subscription)
        )
      elsif !alert_params[:email].blank?
        alert_user = alert_user_model_class.find_or_create_by(
          app_id: alert_params[:app_id],
          email: alert_params[:email]
        )
        create(
          alert_params
            .slice(:app_id, :document_id, :document_tolgeo)
            .merge(alertable: alert_user)
        )
      else
        raise ActiveRecord::RecordInvalid.new(
          new(alert_params.slice(:app_id, :document_id, :document_tolgeo))
        )
      end
    end

    def self.find_alert(alert_params)
      search_scopes(alert_params)&.first
    end

    def tolgeo
      self.class.name.deconstantize.downcase
    end

    def self.tolgeo
      self.name.deconstantize.downcase
    end

    def self.search_scopes(params)
      by_app_id(params[:app_id])
        .by_subscriptionid(params[:alertable_id])
        .by_email(params[:email])
        .by_docid(params[:document_id])
        .by_document_tolgeo(params[:document_tolgeo])
        .by_alert_date_gt(params[:alert_date])
    end

    def locale
      return unless alertable_type != self.class.alert_user_model_class.name &&
                    alertable.respond_to?(:lang)

      lang = alertable.lang
      lang.blank? ? nil : (Settings.lang_to_locale[lang.to_s.to_sym] || lang)
    end

    private

    def set_alert_date
      self.alert_date ||= Time.current
    end

    def self.user_subscription_model_class
      Objects.tolgeo_model_class(self.tolgeo, 'user_subscription')
    end

    def self.alert_user_model_class
      Objects.tolgeo_model_class(self.tolgeo, 'alert_user')
    end
  end
end
