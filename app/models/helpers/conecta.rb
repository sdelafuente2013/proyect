module Conecta
  module User
    SUBSYSTEM = 0
    ACCESS_TYPE = 1
    USER_TYPE_GROUP = 24
    MAXCONNECTIONS = 5
    ACCESS_TYPE_TABLET = 2
    SUBJECT = 23
    MODULO = 5
    PRODUCT = 21
    PERMITS = '00011100001110000111000011100001110'
    NO_CONNECTIONS = 0

    class << self
      def attributes_for(tolgeo, params)
        attributes = {
          maxconexiones: MAXCONNECTIONS,
          username: params['email'],
          access_type: access_type(tolgeo),
          user_type_group: user_type_group(tolgeo),
          subsystem: subsystem(tolgeo),
          access_type_tablet: access_type_tablet(tolgeo),
          subjects: subjects(tolgeo),
          modulos: modulos(tolgeo),
          products: products(tolgeo),
          permisos: PERMITS,
          comentario: comentario(params),
          datelimit: params['datelimit']
        }

        params.merge(attributes)
      end
      
      def attributes_for_subscription(tolgeo, user, params)
        attributes = {
          perusuid: user.email,
          acceso_tablet: true,
          fecha_alta_tablet: Date.today,
          change_date: Date.today,
          user: user,
          password: user.password,
          subsystem: user.subsystem
        }

        params.merge(attributes)
      end  

      def disable_date
        Date.today
      end

      def milliseconds_to_time(milliseconds)
        seconds = (milliseconds.to_f / 1000)
        date = Time.strptime(seconds.to_s, '%s')

        Time.parse(date.to_s).getutc.iso8601(3)
      end

      private

      def access_type(tolgeo)
        Objects.tolgeo_model_class(tolgeo, 'access_type').find(ACCESS_TYPE)
      end

      def user_type_group(tolgeo)
        Objects.tolgeo_model_class(tolgeo, 'user_type_group').find(USER_TYPE_GROUP)
      end

      def subsystem(tolgeo)
        Objects.tolgeo_model_class(tolgeo, 'subsystem').find(SUBSYSTEM)
      end

      def access_type_tablet(tolgeo)
        Objects.tolgeo_model_class(tolgeo, 'access_type_tablet').find(ACCESS_TYPE_TABLET)
      end

      def subjects(tolgeo)
        [Objects.tolgeo_model_class(tolgeo, 'subject').find(SUBJECT)]
      end

      def modulos(tolgeo)
        [Objects.tolgeo_model_class(tolgeo, 'modulo').find(MODULO)]
      end

      def products(tolgeo)
        [Objects.tolgeo_model_class(tolgeo, 'product').find(PRODUCT)]
      end

      def comentario(data)
        "#{data['nif']} #{data['direccion']} #{data['telefono']}"
      end
    end
  end
end
