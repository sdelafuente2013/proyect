# frozen_string_literal: true

class Mex::UserSubscriptionCalendar
  include UserSubscriptionCalendarConcern

  store_in collection: "user_subscription_calendars", client: "files_mex"
end
