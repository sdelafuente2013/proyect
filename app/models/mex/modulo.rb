class Mex::Modulo < Mex::MexBase
  CONSULTORIA = 1
  MODULE_ID_GESTION_DESPACHOS_PREMIUM = 7
  
  include ModuloConcern

  def self.consultoria_ids
    [CONSULTORIA]
  end

end
