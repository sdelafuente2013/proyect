class Mex::User < Mex::MexBase
  include UserConcern

  after_create :create_foro
  after_update :update_foro
  before_destroy :destroy_foro, prepend: true

  def iso_code
    'mx'
  end

  private

  def specific_updates_offices
    changes = {}
    changes[:active] = has_offices_premium? && allow_connections?
    changes
  end

  def is_consultant_module?(id)
    Mex::Modulo.is_consultoria?(id)
  end

end
