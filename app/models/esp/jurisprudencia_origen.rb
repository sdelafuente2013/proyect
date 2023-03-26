class Esp::JurisprudenciaOrigen < Esp::EspBase
    
  include JurisprudenciaOrigenConcern
  
  ID_AUDIENCIA_NACIONAL = 6

  def self.audiencia_nacional?(id)
    id.to_i == ID_AUDIENCIA_NACIONAL
  end

end
