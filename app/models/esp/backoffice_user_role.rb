class Esp::BackofficeUserRole < Esp::EspBase
  self.table_name = 'backoffice_user_roles'
  belongs_to :backoffice_user
  belongs_to :role
end

