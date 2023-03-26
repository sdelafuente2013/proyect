class Esp::User < Esp::EspBase
  include UserConcern

  SUBSYSTEM_TIRANTONLINE = 0

  after_create :create_foro
  after_update :update_foro
  before_destroy :destroy_foro, prepend: true

  def iso_code
    'es'
  end

  private

  def specific_updates_offices
    changes = {}
    if has_tirantonline?
      changes[:premium] = has_offices_premium?
      changes[:active] = allow_connections?
    else
      changes[:active] = has_offices_premium? && allow_connections?
    end
    changes
  end

  def has_tirantonline?
    self.subid == SUBSYSTEM_TIRANTONLINE
  end

  def is_consultant_module?(id)
    Esp::Modulo.is_consultoria?(id)
  end
end
