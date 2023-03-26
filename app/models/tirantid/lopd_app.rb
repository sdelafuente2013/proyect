# BASES_DE_DATOS, LIBRERIA_ESP, GESTION_DE_DESPACHOS, LIBRERIA_MEX ,FORMACION,CLOUDLIBRARY,CONECTA
#frozen_string_literal: true

module Tirantid

  class LopdApp < TirantidBase

    BASES_DE_DATOS = "BASES_DE_DATOS"
    BASES_DE_DATOS_LATAM = "BASES_DE_DATOS_LATAM"
    LIBRERIAS = %w(LIBRERIA_ESP LIBRERIA_MEX)

    self.table_name = 'lopd_apps'

    after_create :create_default_ambito

    has_many :lopd_ambitos, class_name: 'LopdAmbito'

    validates :nombre, presence: true

    scope :by_name, -> (nombre) { where(nombre: nombre) }

    scope :by_db_tolgeo, -> (db_tolgeo) {
      if db_tolgeo == 'esp'
        where(nombre: BASES_DE_DATOS)
      else
        where(nombre: BASES_DE_DATOS_LATAM)
      end
    }

    private

    def create_default_ambito
      self.lopd_ambitos.create(nombre: LopdAmbito::DEFAULT)
    end
  end
end
