module UserStatConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'usuario_stats'
    searchable_by :usuarioid

    belongs_to :user, :foreign_key => 'usuario_id'

    attr_accessor :email, :username, :nif

    validates :user, :fecha, presence: true
    validates_uniqueness_of :user, scope: :fecha

    scope :by_fechas_interval, lambda { |fecha_ini, fecha_end|
      if fecha_ini.blank? && !fecha_end.blank?
        where('fecha <= ?', fecha_end)
      elsif !fecha_ini.blank? && fecha_end.blank?
        where('fecha >= ?', fecha_ini)
      elsif !fecha_ini.blank? && !fecha_end.blank?
        where('fecha between ? and ?', fecha_ini, fecha_end)
      else
        all
      end
    }

    scope :by_user_id, lambda { |user_id|
      user_id.blank? ? all : where('usuario_id = ?', user_id)
    }

    scope :by_user_nif, lambda { |user_nif|
      user_nif.blank? ? all : joins(:user).where('usuario.nif like ?', "%#{user_nif}%")
    }

    scope :by_subid, lambda { |subid|
      subid.blank? ? all : joins(:user).where('usuario.subid = ?', subid)
    }

    scope :by_check_numbers, lambda { |num_sessions, num_documents, not_grouped|

      if !not_grouped.blank? && not_grouped
        query_fields = 'usuario_id, sesiones, documentos, fecha'
      else
        query_fields = 'usuario_id, sum(sesiones) as sesiones, sum(documentos) as documentos, fecha'
      end

      if num_sessions.blank? && num_documents.blank?
        select(query_fields)
      elsif !num_sessions.blank? && num_documents.blank?
        select(query_fields).having("sum(sesiones) < ?", num_sessions)
      elsif num_sessions.blank? && !num_documents.blank?
        select(query_fields).having("sum(documentos) < ?", num_documents)
      else
        select(query_fields).having("sum(sesiones) < ? or sum(documentos) < ?", num_sessions, num_documents)
      end
    }

    scope :not_grouped, lambda { |not_grouped|
      group(:usuario_id) unless not_grouped
    }

    scope :by_start_created_date, lambda { |start_created_date|
      return all if start_created_date.blank?

      formated_date = Date.parse(start_created_date)
      joins(:user).where('usuario.fechaalta >= ?', formated_date)
    }

    scope :by_end_created_date, lambda { |end_created_date|
      return all if end_created_date.blank?

      formated_date = Date.parse(end_created_date)
      joins(:user).where('usuario.fechaalta <= ?', formated_date)
    }

    scope :by_subsystem_id, lambda { |sub_id|
      sub_id.blank? ? all : joins(:user).where('usuario.subid = ?', sub_id)
    }

    scope :by_user_type_id, lambda { |user_type_id|
      user_type_id.blank? ? all : joins(:user).where('usuario.tipousuariogrupoid = ?', user_type_id)
    }

    scope :by_filter_user_subsystem, lambda { |subsystem_ids|
      subsystem_ids.blank? ? all : where(:subid => subsystem_ids)
    }

    scope :by_is_active, lambda { |active|
      active.blank? ? all :
            active == 'true' ? joins(:user).where("maxconexiones > 0 and (datelimit is null or datelimit > now())") :
               where("maxconexiones=0 or (datelimit is not null and datelimit < now())")
    }

    def self.search_scopes(params)
      set_date_interval_from_num_month_ago(params)
      by_user_id(params[:user_id]).
      by_user_nif(params[:nif]).
      by_user_nif(params[:cif]).
      by_fechas_interval(params[:fecha_start], params[:fecha_end]).
      by_subid(params[:subid]).
      by_check_numbers(params[:num_sessions], params[:num_documents], params[:not_grouped]).
      not_grouped(params[:not_grouped]).
      by_start_created_date(params[:fecha_alta_start]).
      by_end_created_date(params[:fecha_alta_end]).
      by_subsystem_id(params[:subid]).
      by_user_type_id(params[:tipousuariogrupoid]).
      by_filter_user_subsystem(params[:user_subsystem_ids]).
      by_is_active(params[:isactivo]).
      order(fecha: :desc)
    end

    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options={})
      if scope_detail?(options)
        options = (options || {}).deep_merge(include: [:userIps, :subjects, :modulos, :products, :userCloudlibraries])
      end

      attrs = super options

      if scope_detail?(options)
        attrs[:total_sessions] = self.total_sessions

        if !self.lopd_user.nil?
         attrs[:comercial] = self.lopd_user.comercial
         attrs[:grupo] = self.lopd_user.grupo
         attrs[:privacidad] = self.lopd_user.privacidad
        end
      end
      attrs['datelimit'] = format_date(attrs['datelimit'])

      attrs
    end

    def as_json(options = {})
      options = (options || {}).deep_merge(include: [:user])
      super(options)
    end

    def email=(email)
      self[:email] = email
    end

    def username=(username)
      self[:username] = username
    end

    def nif=(nif)
      self[:nif] = nif
    end

    private

    def self.set_date_interval_from_num_month_ago(params)
      unless params[:period].blank?
        params[:fecha_start] = params[:period].to_i.month.ago.to_date
        params[:fecha_end] = Date.today
      end
    end
  end
end
