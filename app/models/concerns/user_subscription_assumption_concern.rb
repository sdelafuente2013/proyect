module UserSubscriptionAssumptionConcern
  extend ActiveSupport::Concern
  
  include Mongoid::Document
  include Mongoid::Timestamps
  include Searchable
  
  included do
    
    index({user_subscription_id: 1, user_subscription_case_id: 1})
    
    before_create :set_case_name
    before_update :set_case_name
    before_update :set_filters_by_token
    after_create :update_token_with_assumption_id
    
    validates_presence_of :title, :user_subscription_id, :user_subscription_case_id
    validates_uniqueness_of :title, :scope => :user_subscription_case_id
    
    attr_accessor :token_id
    
    field :title, type: String
    field :summary, type: String
    field :user_subscription_id, type: Integer
    field :user_subscription_case_id, type: String
    field :user_subscription_case_name, type: String
    field :filters, type: Hash, :default => proc { {} }
    
    scope :by_title, -> (title) { title.blank? ? all : where(title: /#{"%s" % title}/) }
    scope :by_user_subscription_id, -> (id) { id.blank? ? all : where(user_subscription_id: id) }
    scope :by_user_subscription_case_id, -> (id) { id.blank? ? all : where(user_subscription_case_id: id) }

    def self.search_scopes(params)
      by_title(params[:title]).
      by_user_subscription_id(params[:user_subscription_id]).
      by_user_subscription_case_id(params[:user_subscription_case_id])
    end
    
    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options = {})
      attrs = super options
    end
    
    def tolgeo
      self.class.name.split('::').first.downcase
    end
    
    def user_subscription
      user_subscription_class.find(self.user_subscription_id) if self.user_subscription_id
    end
  
    private 
    
    def set_filters_by_token
      self.filters=user_session_token_class.find(token_id).filters unless self.token_id.blank?
    end  

    def user_subscription_class
      Objects.tolgeo_model_class(self.tolgeo, 'user_subscription')
    end

    def user_session_token_class
      @item_class = Objects.tolgeo_model_class(self.tolgeo, "user_session_token")
    end
    
    def user_subscription_case_class
       Objects.tolgeo_model_class(self.tolgeo,'user_subscription_case')
    end

    def user_subscription_case
      user_subscription_case_class.find(self.user_subscription_case_id) if self.user_subscription_case_id
    end

    def update_token_with_assumption_id
      update_attrs=self.filters.merge({:assumption_id => self.id.to_s})
      user_session_token_class.where(:id => self.token_id).update(filters: update_attrs) unless self.token_id.blank?
    end

    def set_case_name
      user_subscription_case_item = user_subscription_case
      unless user_subscription_case_item.nil?
        self.user_subscription_case_name=user_subscription_case_item.namecase
      end
    end
  end
end
