module UserSubscriptionSearchConcern
  extend ActiveSupport::Concern
  
  include Mongoid::Document
  include Mongoid::Timestamps
  include Searchable
  
  included do
    
    index({user_subscription_id: 1, user_subscription_case_id: 1})
    
    before_create :set_case_name , :set_is_alertable
    
    validates_presence_of :summary, :user_subscription_id, :user_subscription_case_id  

    attr_accessor :token_id
    
    field :alert_period, type: Integer, :default => 0
    field :is_alertable, type: Boolean
    field :last_alert_sent , type: DateTime
    field :summary, type: String
    field :user_subscription_id, type: Integer
    field :user_subscription_case_id, type: String
    field :user_subscription_case_name, type: String
    field :filters, type: Hash, :default => proc { {} }
    field :subid , type: Integer 
    field :paisiso , type: String 
    
    scope :by_summary, -> (summary) { summary.blank? ? all : where(summary: /#{"%s" % summary}/) }
    scope :by_subid, -> (subid) { subid.blank? ? all : where(subid: "%s" % subid) }
    scope :by_alert_period, -> (alert_period) { alert_period.blank? ? all : where(alert_period: "%s" % alert_period) }
    scope :by_user_subscription_id, -> (id) { id.blank? ? all : where(user_subscription_id: id) }
    scope :by_user_subscription_case_id, -> (id) { id.blank? ? all : where(user_subscription_case_id: id) }

    def self.search_scopes(params)
      by_subid(params[:subid]).
      by_alert_period(params[:alert_period]).
      by_summary(params[:summary]).
      by_user_subscription_id(params[:user_subscription_id]).
      by_user_subscription_case_id(params[:user_subscription_case_id])
    end
    
    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options = {})
      attrs = super options
      attrs
    end
    
    def tolgeo
      self.class.name.split('::').first.downcase
    end
    
    def user_subscription
      user_subscription_class.find(self.user_subscription_id) if self.user_subscription_id
    end
  
    private 

    def user_subscription_class
      Objects.tolgeo_model_class(self.tolgeo, 'user_subscription')
    end
    
    def user_subscription_case_class
       Objects.tolgeo_model_class(self.tolgeo,'user_subscription_case')
    end

    def user_subscription_case
      user_subscription_case_class.find(self.user_subscription_case_id) if self.user_subscription_case_id
    end

    def set_case_name
      user_subscription_case_item = user_subscription_case
      unless user_subscription_case_item.nil?
        self.user_subscription_case_name=user_subscription_case_item.namecase
      end
    end

    def set_is_alertable
      self.is_alertable = (alert_period == 'nunca') ? false : true
    end 
    
  end
end
