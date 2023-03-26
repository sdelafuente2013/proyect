# frozen_string_literal: true

module UserSubscriptionCalendarConcern
  extend ActiveSupport::Concern

  include Mongoid::Document
  include Mongoid::Timestamps

  included do
    include Searchable
    searchable_by :id

    index({ user_subscription_id: 1 }, { name: "user_subscription_id_index" })

    default_scope { order(created_at: :desc) }

    validates :name, presence: true
    validates :user_subscription_id, presence: true
    validates :type, presence: true, inclusion: { in: ["data", "ics"] }

    field :name, type: String, default: ""
    field :type, type: String, default: ""
    field :events, type: Array, default: proc { [] }
    field :url, type: String, default: ""
    field :user_subscription_id, type: Integer
    field :color, type: String, default: ""

    scope :by_user_subscription_id, ->(id) { id.blank? ? all : where(user_subscription_id: id) }

    def self.search_scopes(params)
      by_user_subscription_id(params[:user_subscription_id])
    end

    def to_json(options = {})
      as_json(options)
    end
  end
end
