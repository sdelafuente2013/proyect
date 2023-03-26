class Esp::AccessError
  include AccessErrorConcern

  store_in database: "tolpro", collection: "access_errors", client: "cached"
  
end

