class Latam::UserSubscriptionCase
  include UserSubscriptionCaseConcern

  store_in collection: "user_subscription_cases", client: "files_latam"
  
end

