require 'rest-client'

module ForoGroupConcern
  extend ActiveSupport::Concern

  included do

    include ForoConcern

    def create
      validate_required_fields(["user_group", "permis"])
      send_request("create_group")
    end

    def update
      validate_required_fields(["group_name"])
      send_request("update_group")
    end

    def destroy
      validate_required_fields(["user_group"])
      send_request("destroy_group")
    end

    def move
      validate_required_fields(["user_group", "user_groups","user_style"])
      send_request("move_group")
    end

  end

end
