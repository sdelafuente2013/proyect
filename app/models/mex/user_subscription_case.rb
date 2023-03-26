class Mex::UserSubscriptionCase
  include UserSubscriptionCaseConcern

  store_in collection: "user_subscription_cases", client: "files_mex"
  
end

