class Latam::User < Latam::LatamBase
  include UserConcern
  

  def specific_updates_offices
    changes = {}
    changes[:active] = has_offices_premium? && allow_connections?
    changes
  end

  def iso_code
    Latam::Pais.find_by(subid: subid).try(:codigo_iso_2digits)
  end

  private

  def is_consultant_module?(id)
    false
  end

end
