module Tirantid

  class LopdLogService

    include Singleton

    DEFAULT_LOG_FILE = './log/lopd_cambios.txt'
    DEFAULT_USE_LOCK = false
    @@mutex = Mutex.new

    mattr_accessor :logger

    attr_accessor :params

    def initialize(params = {})
      @params = params.dup
      if !@@logger
        @@logger = ActiveSupport::Logger.new('/dev/null')
        @@logger.level = 0
      end
    end

    def guardar_cambio_usuario_tirant_app(lopd_user, operacion = '')

      lopd_ambito = lopd_user.lopd_ambito
      lopd_app = lopd_ambito.lopd_app
      updated_at = lopd_user.updated_at.present? ? lopd_user.updated_at.utc.iso8601.to_s : ""
      datos_cambio = operacion == "UPDATE" ? JSON.generate(lopd_user.saved_changes) : ""

      nuevo_cambio = "#{lopd_user.usuario},#{lopd_app.nombre},#{lopd_ambito.nombre},#{updated_at},#{operacion},#{datos_cambio}\n"

      Rails.logger.debug "LOPD LopdLogService >> #{nuevo_cambio}"
      lock_then_append_then_release(current_file_path) { |f|
        f.puts(nuevo_cambio)
      }
    end

    def current_file_path
      Rails.configuration.lopd_cambios_log_path || DEFAULT_LOG_FILE
    end

    def current_lock_log_path
      Rails.application.config.lock_log_path || DEFAULT_USE_LOCK
    end

    def get_ultima_linea(path = nil)
      path = current_file_path if path.nil?
      IO.readlines(path)[-1]
    end

    private

    def lock_then_append_then_release(path)
      # Only one on a time
      @@mutex.synchronize do
        File.write(path, "") unless File.exist?(path)
        # Lock can not work depending on system, then it can be disabled
        File.open(path).flock(File::LOCK_EX)  if current_lock_log_path # We need to check the file exists before we lock it. If not we create it
        File.open(path, 'a') { |f| yield(f) if block_given? } # Carry out the operations with the file open
        File.open(path).flock(File::LOCK_UN)  if current_lock_log_path  # Unlock the file.
      end
    end

  end


end
