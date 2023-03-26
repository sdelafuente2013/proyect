class Esp::BackofficeUserSubsystem < Esp::EspBase
  self.table_name = 'backoffice_user_subsystems'
  belongs_to :backoffice_user_tolgeo, :foreign_key => 'backoffice_user_tolgeo_id', inverse_of: :backoffice_user_subsystems
  has_one :tolgeo, through: :backoffice_user_tolgeo, source: :tolgeo
end
