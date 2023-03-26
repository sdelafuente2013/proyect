module UserScopes
  extend ActiveSupport::Concern

  included do
    searchable_by :username

    scope :by_name, lambda { |name|
      name.blank? ? all : where('nombre LIKE ?', "%#{name}%")
    }

    scope :by_last_name, lambda { |last_name|
      last_name.blank? ? all : where('apellidos LIKE ?', "%#{last_name}%")
    }

    scope :by_email, lambda { |email|
      email.blank? ? all : where('email LIKE ?', "%#{email}%")
    }

    scope :by_nif, lambda { |nif|
      nif.blank? ? all : where('nif LIKE ?', "%#{nif}%")
    }

    scope :by_groups_name, lambda { |group|
      group.blank? ? all : joins(:group).where('grupo.descripcion = ?', group)
    }

    scope :by_group_id, lambda { |group_id|
      group_id.blank? ? all : where('grupoid = ?', group_id)
    }

    scope :by_max_connections, lambda { |max_connections|
      max_connections.blank? ? all : where('maxconexiones = ?', max_connections)
    }

    scope :by_comment, lambda { |comment|
      comment.blank? ? all : where('lower(comentario) LIKE ?', "%#{comment}%")
    }

    scope :by_access_type_id, lambda { |access_type_id|
      access_type_id.blank? ? all : where('tipoaccesoid = ?', access_type_id)
    }

    scope :by_subject_id, lambda { |subject_id|
      subject_id.blank? ? all : where('subid = ?', subject_id)
    }

    scope :by_is_demo, lambda { |is_demo|
      is_demo.blank? ? all : where('isdemo = ?', is_demo.to_s == 'true')
    }

    scope :by_is_collective, lambda { |is_collective|
      is_collective.blank? ? all : where('iscolectivo =  ?', is_collective.to_s == 'true')
    }

    scope :by_user_type_id, lambda { |user_type_id|
      user_type_id.blank? ? all : where('tipousuariogrupoid = ?', user_type_id)
    }

    scope :by_start_created_date, lambda { |start_created_date|
      return all if start_created_date.blank?

      formated_date = Date.parse(start_created_date).to_s+" 00:00:00"
      where('usuario.fechaalta >= ?', formated_date)
    }

    scope :by_end_created_date, lambda { |end_created_date|
      return all if end_created_date.blank?

      formated_date = Date.parse(end_created_date).to_s+" 23:59:59"
      where('fechaalta <= ?', formated_date)
    }

    scope :by_start_revision_date, lambda { |start_revision_date|
      return all if start_revision_date.blank?

      formated_date = Date.parse(start_revision_date).to_s+" 00:00:00"
      where('fecharevision >= ?', formated_date)
    }

    scope :by_end_revision_date, lambda { |end_revision_date|
      return all if end_revision_date.blank?

      formated_date = Date.parse(end_revision_date).to_s+" 23:59:59"
      where('fecharevision <= ?', formated_date)
    }

    scope :by_subsystem, lambda { |subid|
      subid.blank? ? all : joins(:subject_subsystems).where('materia_subsystem.subid = ?', subid)
    }

    scope :by_username_casesensitive, lambda { |username|
       where('username=?', username)
    }

    scope :by_username, lambda { |username|
      username.blank? ? all : where('username LIKE ?', "%#{username}%")
    }

    scope :by_username_without_like, lambda { |username_without_like|
      username_without_like.blank? ? all : where('username LIKE ?', "#{username_without_like}")
    }

    scope :by_filter_user_subsystem, lambda { |subsystem_ids|
      subsystem_ids.blank? ? all : where(:subid => subsystem_ids)
    }

    scope :by_is_active, lambda { |active|
      active.blank? ? all :
            active == 'true' ? where("maxconexiones > 0 and (datelimit is null or datelimit > now())") :
               where("maxconexiones=0 or (datelimit is not null and datelimit < now())")
    }

    scope :by_cloudlibrary_user, lambda { |cloud_user_id|
      cloud_user_id.blank? ? all : where('cloudlibrary_user = ?', cloud_user_id)
    }

    scope :by_modulo_id, lambda { |modulo_id|
      modulo_id.blank? ? all : joins(:user_modulos).where('usuario_modulo.moduloid = ?', modulo_id)
    }

    def self.search_scopes(params)
      by_ids([params[:ids], params[:id]].flatten.reject(&:blank?)).
      autocomplete(params[:q]).
      by_username(params[:username]).
      by_name(params[:nombre]).
      by_last_name(params[:apellidos]).
      by_email(params[:email]).
      by_nif(params[:nif]).
      by_group_id(params[:grupoid]).
      by_groups_name(params[:grupo]).
      by_max_connections(params[:maxconexiones]).
      by_comment(params[:comentario]).
      by_access_type_id(params[:tipoaccesoid]).
      by_subject_id(params[:subid]).
      by_is_demo(params[:isdemo]).
      by_is_collective(params[:iscolectivo]).
      by_user_type_id(params[:tipousuariogrupoid]).
      by_start_created_date(params[:fecha_alta_start]).
      by_end_created_date(params[:fecha_alta_end]).
      by_start_revision_date(params[:fecha_revision_start]).
      by_end_revision_date(params[:fecha_revision_end]).
      by_filter_user_subsystem(params[:user_subsystem_ids]).
      by_is_active(params[:isactivo]).
      by_cloudlibrary_user(params[:cloud_user_id]).
      by_username_without_like(params[:username_without_like]).
      joins(:subsystem).includes(:subsystem).
      by_modulo_id(params[:modulo_id])
    end
  end
end
