# frozen_string_literal: true

class Esp::Foro < ActiveType::Object
  include ForoConcern

  TOLGEO_SUBID_PREFIX = {
    '0': 'TOL',
    '1': 'TNT',
    '2': 'TAS',
    '3': 'TPH'
  }.freeze

  TOLGEO_SUBID_PERMISOS = {
    '0': 'tol',
    '1': 'tnt',
    '2': 'tase',
    '3': 'tph'
  }.freeze

  TOLGEO_SUBID_STYLES = {
    '0': 'ctol',
    '1': 'ctol',
    '2': 'ctol',
    '3': 'ctol'
  }.freeze

  TOLGEO_PREFIXGRUPO = 'C' unless const_defined?(:TOLGEO_PREFIXGRUPO)
end
