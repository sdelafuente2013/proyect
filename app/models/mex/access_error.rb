class Mex::AccessError
  include AccessErrorConcern

  store_in database: "tolmex", collection: "access_errors", client: "cached"
  
end

