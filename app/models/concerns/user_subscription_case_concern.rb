module UserSubscriptionCaseConcern
  extend ActiveSupport::Concern
  
  include Mongoid::Document
  include Mongoid::Timestamps
  include Searchable
  
  included do

    index({ user_subscription_id: 1 }, { name: "user_subscription_id_index" })
    
    after_save :update_namecase_in_assumptions
    after_save :update_namecase_in_searches
    
    default_scope { order(created_at: :desc) }
    
    validates_presence_of :namecase, :user_subscription_id
    
    field :namecase, type: String
    field :summary, type: String
    field :documents, type: Array
    field :annotations, type: Array
    field :user_subscription_id, type: Integer
    field :folderContent, type: String
    field :downloadUrl, type: String
    field :downloadUrlDate, type: DateTime
    
    scope :by_namecase, -> (namecase) { namecase.blank? ? all : where(namecase: namecase) }
    scope :by_user_subscription_id, -> (id) { id.blank? ? all : where(user_subscription_id: id) }
    scope :by_folderContent, -> (regex) { regex.blank? ? all : where(folderContent:Regexp.new(regex)) }

    def self.search_scopes(params)
      by_namecase(params[:namecase]).
      by_user_subscription_id(params[:user_subscription_id]).
      by_folderContent(params[:folderContent])
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
      user_subscription_class.find(self.user_subscription_id)
    end
    
    def assumptions
      user_subscription_assumption_class.by_user_subscription_case_id(self.id)
    end

    def searches
      user_subscription_search_class.by_user_subscription_case_id(self.id)
    end
    
    private 

    def user_subscription_class
      Objects.tolgeo_model_class(self.tolgeo, 'user_subscription')
    end
    
    def user_subscription_assumption_class
      Objects.tolgeo_model_class(self.tolgeo, 'user_subscription_assumption')
    end

    def user_subscription_search_class
      Objects.tolgeo_model_class(self.tolgeo, 'user_subscription_search')
    end
    
    def update_namecase_in_assumptions
      if self.changed_attributes.key?("namecase")
        assumptions.update_all({:user_subscription_case_name => self.namecase})
      end
    end

    def update_namecase_in_searches
      if self.changed_attributes.key?("namecase")
        searches.update_all({:user_subscription_case_name => self.namecase})
      end
    end
    
  end
end
