# frozen_string_literal: true

class Latam::UserSessionToken
  include UserSessionTokenConcern

  store_in collection: 'user_session_tokens', client: 'sessions_latam'
end
