# frozen_string_literal: true

class Mex::Foro < ActiveType::Object
  include ForoConcern

  TOLGEO_SUBID_PREFIX = {
    '0': 'TOLMEX',
    '1': 'CONMEX'
  }.freeze

  TOLGEO_SUBID_PERMISOS = { 
    '0': 'tolmex',
    '1': 'contadores'
  }.freeze

  TOLGEO_SUBID_STYLES = {
    '0': 'ctolmex',
    '1': 'ccontadores'
  }.freeze

  TOLGEO_PREFIXGRUPO = {
    '0': 'CMEX',
    '1': 'ccontadores'
  }.freeze
end
