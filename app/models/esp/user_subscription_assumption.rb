class Esp::UserSubscriptionAssumption
  include UserSubscriptionAssumptionConcern

  store_in collection: "user_subscription_assumptions", client: "files_esp"
  
end

