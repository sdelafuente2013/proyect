class Mex::Subsystem < Mex::MexBase
  TOLMEX = 0
  CONTADORES = 1

  FOROS_NOT_ALLOWED_SUBSYSTEMS = []

  include SubsystemConcern
end

