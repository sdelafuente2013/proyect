class Latam::UserSubscriptionAssumption
  include UserSubscriptionAssumptionConcern

  store_in collection: "user_subscription_assumptions", client: "files_latam"
  
end

