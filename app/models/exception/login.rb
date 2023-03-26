class Exception::Login < StandardError

  CODES = {"invalid_ips" => 1,
           "invalid_ticket" => 2,
           "wrong_password" => 3,
           "invalid_user" => 4,
           "username_required" => 4,
           "password_required" => 4,
           "invalid_referer" => 5,
           "user_connections_is_zero" => 6,
           "user_exceed_max_connections" => 7,
           "invalid_gmid" => 8,
           "user_expired" => 9,
           "invalid_ticket_auth_external" => 10,
           "unexpected_error" => 11,
           "user_not_permissions" => 12
           }
          
  def initialize(code_key=nil, user_login=nil)
    @user_login = user_login
    @code_key=code_key
    @code = CODES.fetch(code_key.to_s, 11)
    @message = code_to_message
    @access_error=create_access_error unless @user_login.nil?
    super(@message)
  end

  def access_error
    @access_error
  end
  
  def code
    @code
  end
  
  def message
    @message
  end
  
  def code_to_message
    if @code_key.to_s == "user_exceed_max_connections"
      I18n.t("login.exceptions.%s" % @code_key, max_conexiones: @user_login.user.maxconexiones)
    else
      I18n.t("login.exceptions.%s" % @code_key, default: "login.unexpected_error")
    end
  end
  
  def create_access_error
    @user_login.class.access_error_class.create({
    "tipo_error_acceso_id" => @code,
     "usuarioid" => @user_login.user.try(:id), 
     "username" =>  @user_login.username,
     "descripcion" =>  access_error_description,
     "tipo_peticion" => @user_login.class.access_error_class::REQUEST_TYPE_LOGIN,
     "subid" => @user_login.subid
    })
  end
  
  def access_error_description
    ips = @user_login.ips.nil? ? "" : @user_login.ips.join(", ")
    user_ips = @user_login.user.try(:userIps)

    case @code_key.to_s
    when "invalid_ips"
      "Llega desde (%s). Registradas=(%s)" % [ips, user_ips.map{|it| it.to_pretty}.join(", ")]
    when "invalid_ticket"
      "ticket=%s invalido.%s%s" % [@user_login.ticket, 
                                   ips.blank? ? '' : 'LLega desde %s ' % ips,
                                   user_ips.nil? ? '' : user_ips.map{|it| it.to_pretty}.join(", ")
                                  ]
    when "wrong_password"
      "password=#%s#" % @user_login.password
    when "invalid_user"
      "usuario=%s no encontrado en %s" % [@user_login.username, @user_login.subsystem.name]
    when "username_required"
      "username required"
    when "password_required"
      "password required"
    when "invalid_referer"
      "Llega desde (%s). Registrado=(%s)" % [@user_login.referer, @user_login.user.referer]
    when "user_connections_is_zero"
      "numero de conexiones permitidas es cero"
    when "user_exceed_max_connections"
      "num. maximo conexiones alcanzado=%s" % @user_login.user.maxconexiones
    when "invalid_gmid"
      "Grupo materias=%s" % @user_login.user.gm_usuarios.map{|it| it.subject_group.descripcion}.join(", ")
    when "user_expired"
      "Subscripcion caducada. Fecha=%s" % @user_login.user.datelimit.to_date
    when "invalid_ticket_auth_external"
      "Validación externa -- ticket=%s invalido.%s%s" % [@user_login.ticket,
                                   ips.blank? ? '' : 'LLega desde %s ' % ips,
                                   user_ips.nil? ? '' : user_ips.map{|it| it.to_pretty}.join(", ")
                                  ]
    when "unexpected_error"
      "Error inesperado. Para el usuario %s en %s" % [@user_login.username, @user_login.subsystem.try(:name)]
    when "user_not_permissions"
      "Usuario sin permisos %s %s" % [@user_login.username, @user_login.user_subscription ? " personalizado %s" % @user_login.user_subscription.perusuid : '']
    else
      "Error inesperado %s. Para el usuario %s en %s" % [@code_key, @user_login.username, @user_login.subsystem.try(:name)]
    end
  end

  def to_hash
    {
      message: @message,
      code: @code
    }
  end

end

