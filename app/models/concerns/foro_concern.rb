require 'foros_client'

module ForoConcern
  extend ActiveSupport::Concern
  include ::Foros::Client

  included do

    validate :errors_are_empty

    attr_accessor :errores

    REQUIRED_FIELD_FOR_CREATE = ["user_name", "user_email", "user_pass", "user_style", "user_groups"]
    REQUIRE_ERROR = " is required"

    attribute :user_name, :string, :default => nil
    attribute :user_email, :string, :default => nil
    attribute :user_pass, :string, :default => nil
    attribute :user_group, :string, :default => nil
    attribute :user_groups, :string, :default => nil
    attribute :user_style, :string, :default => nil
    attribute :new_user_name, :string, :default => nil
    attribute :new_group_name, :string, :default => nil
    attribute :permis, :string, :default => nil
    attribute :disable_users, :integer, :default => nil
    attribute :group_name, :default => nil

    def create
      validate_required_fields_for_create
      send_request('create')
    end

    def update
      validate_username
      send_request('update')
    end

    def destroy
      validate_username
      send_request('destroy')
    end

    protected

    def validate_required_fields_for_create
      validate_required_fields(REQUIRED_FIELD_FOR_CREATE)
    end

    def validate_username
      validate_required_fields(["user_name"])
    end

    def validate_required_fields(fields)
      self.errores=[]

      empty_fields = select_empty_from(fields)
      fill_errors_with(empty_fields)
    end

    def select_empty_from(fields)
      fields.select do |field|
        self.send(field).blank?
      end
    end

    def fill_errors_with(fields)
      fields.each do |field|
        require_error_message = field + REQUIRE_ERROR

        self.errores << require_error_message
      end
    end

    def errors_are_empty
      fill_base_errors unless errors_are_empty?
    end

    def fill_base_errors
      self.errores.each do |error|
        self.errors[:base] << error
      end
    end

    def errors_are_empty?
      self.errores.blank?
    end
  end
end
