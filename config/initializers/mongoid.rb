# config/initializers/mongoid.rb
module Mongoid
  module Document
    def as_json(options={})
      attrs = super(options)
      id = {"id" => attrs["_id"].to_s}
      attrs.delete("_id")
      id.merge(attrs)
    end
  end
end

# converts object ids from BSON type object id to plain old string
module BSON
  class ObjectId
    alias :to_json :to_s
    alias :as_json :to_s
  end
end