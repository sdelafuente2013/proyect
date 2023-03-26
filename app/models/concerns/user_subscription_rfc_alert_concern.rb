# frozen_string_literal: true

module UserSubscriptionRfcAlertConcern
  extend ActiveSupport::Concern

  include Mongoid::Document
  include Mongoid::Timestamps

  included do
    include Searchable
    searchable_by :id

    index({ user_subscription_id: 1, rfc: 1 })
    default_scope { order(created_at: :desc) }

    validates :name, presence: true
    validates :user_subscription_id, presence: true
    validates :rfc, presence: true
    validates :user_subscription_id, uniqueness: { scope: :rfc }

    field :user_subscription_id, type: Integer
    field :rfc, type: String
    field :name, type: String

    scope :by_user_subscription_id, ->(id) { id.blank? ? all : where(user_subscription_id: id) }
    scope :by_rfc, ->(rfc) { rfc.blank? ? all : where(rfc: { '$in': rfc.is_a?(Array) ? rfc : [rfc] }) }

    def self.search_scopes(params)
      by_user_subscription_id(params[:user_subscription_id])
        .by_rfc(params[:rfc] || params[:rfc_ids])
    end

    def self.searchable_params
      %w[user_subscription_id rfc_ids]
    end

    def to_json(options = {})
      as_json(options)
    end
  end
end
