# frozen_string_literal: true

class Latam::UserSession
  include UserSessionConcern

  store_in collection: 'sessions', client: 'sessions_latam'
end
