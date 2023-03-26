module Tirantid

  class LopdAmbito < TirantidBase

    DEFAULT = 'default'
    PERSONALIZACION = 'personalizacion'
    CONECTA = "conecta"
    CONTACTOS_COMERCIALES = "contactoscomerciales"
    
    self.table_name = 'lopd_ambitos'

    belongs_to :lopd_app, class_name: 'LopdApp'
    has_many :lopd_users, class_name: 'LopdUser'

    validates :nombre, :lopd_app, presence: true

    scope :by_name, lambda { |nombre| where(nombre: nombre.blank? ? DEFAULT : nombre) }
    scope :by_app_name, lambda { |nombre_app| joins(:lopd_app).merge(Tirantid::LopdApp.by_name(nombre_app)) }

  end

end
