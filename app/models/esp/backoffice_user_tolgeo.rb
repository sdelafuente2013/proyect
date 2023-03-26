class Esp::BackofficeUserTolgeo < Esp::EspBase
  self.table_name = 'backoffice_user_tolgeos'

  has_many :backoffice_user_subsystems, foreign_key: 'backoffice_user_tolgeo_id', class_name: 'Esp::BackofficeUserSubsystem', dependent: :destroy, inverse_of: :backoffice_user_tolgeo
  belongs_to :backoffice_user, :foreign_key => 'backoffice_user_id', inverse_of: :backoffice_user_tolgeos
  belongs_to :tolgeo
  
  accepts_nested_attributes_for :backoffice_user_subsystems,
                                reject_if: proc { |attrs| attrs[:subsystem_id].blank? },
                                allow_destroy: true

  def to_json(options = {})
    self.as_json(options)
  end

  def as_json(options = {})
    options = options.deep_merge(include: [:backoffice_user_subsystems])
    super options
  end
end

