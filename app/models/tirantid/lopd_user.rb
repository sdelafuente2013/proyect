module Tirantid
  class LopdUser < TirantidBase
    self.table_name = 'lopd_users'
    include Searchable

    before_create :set_fecha_aceptacion_to_now

    after_create :set_create_cambios
    after_update :set_update_cambios

    belongs_to :lopd_ambito, class_name: 'LopdAmbito'

    validates :lopd_ambito, :usuario, presence: true
    validates_uniqueness_of :usuario, scope: :lopd_ambito_id

    attr_accessor :lopd_app_name, :lopd_ambito_name, :lopd_data_encoding

    scope :by_external_id, -> (external_id) { external_id.blank? ? all : (external_id==0 ? none : where(:usuario => external_id)) }
    scope :by_ambito, -> (ambito_id) { ambito_id.nil? ? all : where(lopd_ambito_id: ambito_id) }
    scope :by_email, -> (email) { email.nil? ? all : where(email: email) }

    searchable_by :usuario

    def pretty_detail
      {:id => self.id , :comercial => self.comercial, :grupo => self.grupo, :privacidad => self.privacidad }
    end

    def comercial=(v)
      self[:comercial] = is_true_value(v,'comercial')
    end

    def grupo=(v)
      self[:grupo] = is_true_value(v,'grupo')
    end

    def privacidad=(v)
      self[:privacidad] = is_true_value(v,'privacidad')
    end

    def set_fecha_aceptacion_to_now
      self.fecha_aceptacion ||= Time.current
    end

    def self.search_scopes(params)
      ambito = Tirantid::LopdAmbito.by_app_name(params[:lopd_app]).by_name(params[:lopd_ambito]).first
      by_ids(params[:ids]).
      autocomplete(params[:q]).
      by_external_id(params.key?(:usuarios) && params[:usuarios].empty? ? 0 : params[:usuarios]).
      by_external_id(params.key?(:usuario) && params[:usuario].nil? ? 0 : params[:usuario]).
      by_ambito(ambito)
    end

    def to_json(options={})
      self.as_json(options)
    end

    def as_json(options={})
      super options
    end

    private

    def is_true_value(v,nombre = 'nombre')
      v.present? &&
      ( !(['null','nil','ko','no','false'].include?(v.to_s.downcase)) &&
        ([nombre,'checked','ok','yes','si','true'].include?(v.to_s.downcase) ||
         v.to_s.to_bool)
      )
    end

    def set_create_cambios
      lopd_log_service.guardar_cambio_usuario_tirant_app(self, "CREATE")
    end

    def set_update_cambios
      lopd_log_service.guardar_cambio_usuario_tirant_app(self, "UPDATE")
    end

    def lopd_log_service
      @lopd_log_service ||= Tirantid::LopdLogService.instance
    end

  end

end
