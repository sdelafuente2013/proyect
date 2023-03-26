class Esp::AccessToken
  include AccessTokenConcern

  store_in database: "access_tokens", collection: "tokens", client: "default"
  
end

