class Mex::UserSubscriptionSearch
  include UserSubscriptionSearchConcern

  store_in collection: "user_subscription_search", client: "files_mex"
  
end

