module CommercialContactConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'contactos_comerciales'

    include Searchable

    validates_presence_of :nombre, :apellidos, :email, :telefono , :subid

    validates :lopd_privacidad, presence: true, on: :create, if: :tolgeo_esp?

    belongs_to :user, :foreign_key => 'id_usuario', optional: true
    belongs_to :subsystem, foreign_key: "subid", inverse_of: :commercial_contacts

    after_create :create_lopd, if: :tolgeo_esp?
    after_update :update_lopd, if: :tolgeo_esp?

    attr_accessor :lopd_privacidad, :lopd_comercial, :lopd_grupo

    scope :by_email, lambda { |email|
      email.blank? ? all : where('email LIKE ?', '%' + email + '%')
    }

    scope :by_user ,lambda { |id_usuario|
    id_usuario.blank? ? all : where('id_usuario = ?',id_usuario)
  }

    scope :by_created_at, lambda { |created_at|
      created_at.blank? ? all : where('fecha_alta=?', created_at)
    }

    scope :by_fechas_interval, lambda { |fecha_ini, fecha_end|
      fecha_ini = Date.parse(fecha_ini) unless fecha_ini.blank?
      fecha_end = Date.parse(fecha_end) unless fecha_end.blank?

      if fecha_ini.blank? && !fecha_end.blank?
        where('fecha_alta <= ?', fecha_end)
      elsif !fecha_ini.blank? && fecha_end.blank?
        where('fecha_alta >= ?', fecha_ini)
      elsif !fecha_ini.blank? && !fecha_end.blank?
        where('fecha_alta between ? and ?', fecha_ini, fecha_end)
      else
        all
      end
    }

    scope :by_phone, lambda { |phone|
      phone.blank? ? all : where('telefono like ?', '%' + phone + '%')
    }

    scope :by_subid, lambda { |subid|
      subid.blank? ? all : where('subid=?', subid)
    }

    scope :by_origin, lambda { |origin|
      origin.blank? ? all : where('origen=?', origin)
    }


    def self.search_scopes(params)
      by_email(params[:email]).
      by_user(params[:id_usuario]).
      by_phone(params[:telefono]).
      by_subid(params[:subid]).
      by_origin(params[:origin]).
      by_fechas_interval(params[:fecha_alta_start], params[:fecha_alta_end])
    end

    def to_json(options={})
      self.as_json(options)
    end

    def as_json(options = {})
      attrs = super options

      attrs[:usuario_username] = self.user.try(:username)
      attrs[:subid_name] = self.subsystem.try(:name)
      attrs
    end

    def self.list_origins
      distinct("origen").pluck(:origen).map{|it| {"origen" => it}}
    end

    def create_lopd
      Tirantid::LopdUser
        .by_email(email)
        .first_or_create
        .update(
          lopd_ambito: lopd_ambito,
          usuario: id,
          nombre: nombre,
          apellidos: apellidos,
          telefono: telefono,
          comercial: lopd_comercial,
          grupo: lopd_grupo,
          privacidad: lopd_privacidad
        )
    end

    def update_lopd
      lopd_user = Tirantid::LopdUser.by_email(self.email).first
      lopd_user.update({
        :lopd_ambito => lopd_ambito,
        :subid => self.subid,
        :usuario => self.id,
        :nombre => self.nombre,
        :apellidos => self.apellidos,
        :telefono => self.telefono,
        :comercial => self.lopd_comercial,
        :grupo => self.lopd_grupo,
        :privacidad => self.lopd_privacidad
      })
    end

    def lopd_app
      Tirantid::LopdApp.by_name(tolgeo).first_or_create
    end

    def lopd_ambito
      self
        .lopd_app
        .lopd_ambitos
        .by_name(Tirantid::LopdAmbito::CONTACTOS_COMERCIALES)
        .first_or_create
    end

    def tolgeo
      self.class.to_s.split('::').first.downcase
    end

    def tolgeo_esp?
      tolgeo == 'esp'
    end
  end
end
