# frozen_string_literal: true

class Esp::UserSessionToken
  include UserSessionTokenConcern

  store_in collection: 'user_session_tokens', client: 'default'
end
