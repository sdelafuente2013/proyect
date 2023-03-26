# frozen_string_literal: true

class Mex::UserSession
  include UserSessionConcern

  store_in collection: 'sessions', client: 'sessions_mex'
end
