
# Donde se guarda el fichero de logs de cambios de LOPD
Rails.application.config.lopd_cambios_log_path = './log/lopd_cambios.txt'
Rails.application.config.lock_log_path = false

if Rails.env.test?
  Rails.application.config.lopd_cambios_log_path = './log/_TEST_lopd_cambios.txt'
elsif Rails.env.production?
  Rails.application.config.lock_log_path = false
  Rails.application.config.lopd_cambios_log_path = './log/lopd_cambios.txt'
end
