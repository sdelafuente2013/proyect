module AccessTokenConcern
  extend ActiveSupport::Concern
  
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  included do

    index({ created_at: -1 }, { name: "created_at_token_index", expire_after_seconds: 60 })
  
    APPS = ["tol", "cloud"]
  
    validates_presence_of :user_id, :app_from, :app_to
  
    field :user_id, type: Integer
    field :email, type: String
    field :app_from, type: String
    field :app_to, type: String # nube, tol
    field :uri, type: String # uri to redirect (optional)

  end
end
