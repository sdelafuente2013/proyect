class Esp::BackofficeUser < Esp::EspBase
  include Searchable
  self.table_name = 'backoffice_users'

  validates :email, { presence: true, uniqueness: true }

  after_save :check_default_tolgeo

  has_many :backoffice_user_tolgeos, foreign_key: 'backoffice_user_id', class_name: "Esp::BackofficeUserTolgeo", dependent: :destroy, inverse_of: :backoffice_user
  has_many :tolgeos, through: :backoffice_user_tolgeos, class_name: "Esp::Tolgeo", source: :tolgeo
  has_many :backoffice_user_subsystems, through: :backoffice_user_tolgeos, class_name: "Esp::BackofficeUserSubsystem", source: :backoffice_user_subsystems
  has_many :backoffice_user_roles, dependent: :destroy
  has_many :roles, through: :backoffice_user_roles
  belongs_to :tolgeo_default, class_name: "Esp::Tolgeo", foreign_key: 'tolgeo_default_id'

  scope :authentificate, lambda { |email, password| where('email = ? and password = ?', email, password) }

  accepts_nested_attributes_for :backoffice_user_roles,
                                reject_if: proc { |attrs| attrs[:role_id].blank? },
                                allow_destroy: true
  accepts_nested_attributes_for :backoffice_user_tolgeos,
                                reject_if: proc { |attrs| attrs[:tolgeo_id].blank? },
                                allow_destroy: true

  has_secure_password

  searchable_by :email

  def to_json(options = {})
    self.as_json(options)
  end

  def as_json(options = {})
    options = options.deep_merge(include: { backoffice_user_roles: { include: { role: {} } },
                                            backoffice_user_tolgeos: {include: {backoffice_user_subsystems: {}, tolgeo: {}} },
                                            tolgeo_default: {} } )
    attrs = super options

    attrs[:available_tolgeos] = tolgeos.pluck(:name)
    attrs[:available_subsystems] = {}
    backoffice_user_tolgeos.each do |backoffice_user_tolgeo|
      unless backoffice_user_tolgeo.backoffice_user_subsystems.empty?
        attrs[:available_subsystems][backoffice_user_tolgeo.tolgeo.name] = backoffice_user_tolgeo.backoffice_user_subsystems.pluck(:subsystem_id)
      end
    end
    attrs[:available_roles] = backoffice_user_roles.pluck(:role_id)

    attrs.delete('password_digest')
    attrs
  end

  def subsystems_by_tolgeo(tolgeo)
    tolgeo_id = tolgeos.find_by(name: tolgeo).id
    backoffice_user_tolgeos.find_by(tolgeo_id: tolgeo_id).backoffice_user_subsystems.pluck(:subsystem_id)
  rescue NoMethodError
    []
  end

  def check_default_tolgeo
    tolgeos_ids = self.backoffice_user_tolgeos.pluck(:tolgeo_id)
    changes={}
    if !tolgeos_ids.blank? && !tolgeos_ids.include?(self.tolgeo_default_id)
      changes[:tolgeo_default_id]=tolgeos_ids.first
    end

    if tolgeos_ids.empty?
      changes[:active]=false
    else
      changes[:active]=true
    end

    self.update_columns(changes) unless changes.empty?
  end

end

