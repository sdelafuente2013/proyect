class Mex::UserSubscription < Mex::MexBase
  include UserSubscriptionConcern

  after_create :create_foro
end
