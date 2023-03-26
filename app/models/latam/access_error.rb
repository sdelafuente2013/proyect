class Latam::AccessError
  include AccessErrorConcern

  store_in database: "latampro", collection: "access_errors", client: "cached"
  
end

