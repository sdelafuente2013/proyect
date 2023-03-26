require 'rails_helper'

describe 'Commercial Contacts API', type: :request do
  describe_crud(Esp::CommercialContact, delete: false)
end
