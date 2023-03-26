class Esp::UserSubscription < Esp::EspBase
  include UserSubscriptionConcern

  after_create :create_foro
end
