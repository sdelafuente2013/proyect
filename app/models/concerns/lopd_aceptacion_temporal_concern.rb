# frozen_string_literal: true

module LopdAceptacionTemporalConcern
  extend ActiveSupport::Concern

  PERSUBSCRIPTION = "alta_personalizacion"

  included do
    self.table_name = "lopd_aceptacion_temporal"

    scope :by_external, lambda { |external_id, external_type|
      where(external_id: external_id, external_type: external_type)
    }
  end
end
