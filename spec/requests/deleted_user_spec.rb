require 'rails_helper'

describe 'Users DeletedUser API', type: :request do
  describe_crud(Esp::DeletedUser, show: false, delete: false, check_attributes: ['username', 'backoffice_user_name', 'subid_name'])
end
