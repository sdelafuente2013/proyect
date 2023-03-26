class Esp::Subsystem < Esp::EspBase
  TIRANTONLINE = 0
  NOTARIOS = 1
  ASESORES = 2
  TPH = 3
  ANALYTICS = 4

  FOROS_NOT_ALLOWED_SUBSYSTEMS = [ANALYTICS]

  include SubsystemConcern
end

