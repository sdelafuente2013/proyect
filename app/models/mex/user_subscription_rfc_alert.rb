# frozen_string_literal: true

class Mex::UserSubscriptionRfcAlert
  include UserSubscriptionRfcAlertConcern

  store_in collection: "user_subscription_rfc_alert", client: "files_mex"
end
