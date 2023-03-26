# frozen_string_literal: true

class Mex::UserSessionToken
  include UserSessionTokenConcern

  store_in collection: 'user_session_tokens', client: 'sessions_mex'
end
