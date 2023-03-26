# frozen_string_literal: true

class Esp::UserSession
  include UserSessionConcern

  store_in collection: 'sessions', client: 'default'
end
