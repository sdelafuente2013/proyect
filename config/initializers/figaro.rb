# Required environment variables
# Save config/application_sample.yml as config/application.yml and define your configuration
common_env_vars = [
  "XT_API_BASE_FOROS",
  "XT_API_BASE_FOROS_PASS",
  "REDIS_URL",
  "XT_GD_API_BASE_URI",
  "XT_CLOUDLIBRARY_API_BASE_URI",
  "DEFAULT_CC_EMAIL_ATENCION_CLIENTE",
  "DEFAULT_CC_EMAIL_ATENCION_CLIENTE_MASSIVE",
  "EMAIL_AUTOVENTA_TOL",
  "EMAIL_AUTOVENTA_TASE",
  "EMAIL_AUTOVENTA_TNR",
  "EMAIL_AUTOVENTA_TPH",
  "EMAIL_AUTOVENTA_TOLMEX",
  "EMAIL_AUTOVENTA_COL",
  "EMAIL_AUTOVENTA_CHL",
  "URL_USER_IMAGES"
]
test_env_vars = [
  "test_db_host",
  "test_db_user",
  "test_db_pass",
  "test_db_name",
  "test_db_latam_host",
  "test_db_latam_user",
  "test_db_latam_pass",
  "test_db_latam_name",
  "test_db_mexico_host",
  "test_db_mexico_user",
  "test_db_mexico_pass",
  "test_db_mexico_name",
  "test_db_tirantid_host",
  "test_db_tirantid_user",
  "test_db_tirantid_pass",
  "test_db_tirantid_name",
  "test_mongo_host",
  "test_mongo_latam_host",
  "test_mongo_mexico_host",
  "test_mongo_cached_host",
  "test_mongo_files_esp_dbname",
  "test_mongo_files_esp_hosts",
  "test_mongo_files_mex_dbname",
  "test_mongo_files_mex_hosts",
  "test_mongo_files_latam_dbname",
  "test_mongo_files_latam_hosts"
]
dev_env_vars = [
  "dev_db_host",
  "dev_db_user",
  "dev_db_pass",
  "dev_db_name",
  "dev_db_host_master",
  "dev_db_host_slave",
  "dev_db_latam_host",
  "dev_db_latam_user",
  "dev_db_latam_name",
  "dev_db_latam_pass",
  "dev_db_latam_host_master",
  "dev_db_latam_host_slave",
  "dev_db_mexico_host",
  "dev_db_mexico_user",
  "dev_db_mexico_pass",
  "dev_db_mexico_name",
  "dev_db_mexico_host_master",
  "dev_db_mexico_host_slave",
  "dev_db_tirantid_host",
  "dev_db_tirantid_user",
  "dev_db_tirantid_pass",
  "dev_db_tirantid_name",
  "dev_mongo_host",
  "dev_mongo_latam_host",
  "dev_mongo_mexico_host",
  "dev_mongo_cached_host",
  "dev_mongo_files_esp_dbname",
  "dev_mongo_files_esp_hosts",
  "dev_mongo_files_mex_dbname",
  "dev_mongo_files_mex_hosts",
  "dev_mongo_files_latam_dbname",
  "dev_mongo_files_latam_hosts"
]

prod_env_vars = [
  "prod_db_host",
  "prod_db_user",
  "prod_db_pass",
  "prod_db_name",
  "prod_db_host_master",
  "prod_db_host_slaves",
  "prod_db_latam_user",
  "prod_db_latam_pass",
  "prod_db_latam_name",
  "prod_db_latam_hosts",
  "prod_db_latam_slaves",
  "prod_db_mexico_user",
  "prod_db_mexico_pass",
  "prod_db_mexico_name",
  "prod_db_mexico_hosts",
  "prod_db_mexico_slaves",
  "prod_db_tirantid_host",
  "prod_db_tirantid_user",
  "prod_db_tirantid_pass",
  "prod_db_tirantid_name",
  "prod_db_tirantid_master",
  "prod_db_tirantid_slave",
  "prod_db_tirantid_slave2",
  "prod_mongo_sessions_esp_dbname",
  "prod_mongo_sessions_esp_hosts",
  "prod_mongo_sessions_esp_replicaset",
  "prod_mongo_sessions_mex_dbname",
  "prod_mongo_sessions_mex_hosts",
  "prod_mongo_sessions_mex_replicaset",
  "prod_mongo_sessions_latam_dbname",
  "prod_mongo_sessions_latam_hosts",
  "prod_mongo_sessions_latam_replicaset",
  "prod_rails_max_threads",
  "prod_mongo_cached_hosts",
  "prod_mongo_cached_replicaset",
  "prod_mongo_files_esp_dbname",
  "prod_mongo_files_esp_hosts",
  "prod_mongo_files_esp_replicaset",
  "prod_mongo_files_mex_dbname",
  "prod_mongo_files_mex_hosts",
  "prod_mongo_files_mex_replicaset",
  "prod_mongo_files_latam_dbname",
  "prod_mongo_files_latam_hosts",
  "prod_mongo_files_latam_replicaset",
  'SMTP_SERVER_PROD',
  'ENVIRONMENT_NAME'
]

required_env_vars = common_env_vars
required_env_vars += test_env_vars if Rails.env.test?
required_env_vars += dev_env_vars if Rails.env.development?
required_env_vars += prod_env_vars if Rails.env.production?

missing_env_vars = []
required_env_vars.each do |key|
  unless ENV[key]
    missing_env_vars << key
  end
end
if ENV['skip_figaro'].nil? && !missing_env_vars.empty?
  raise "Missing environment variables. For development and testing, define them in config/application.yml: #{missing_env_vars.inspect}"
end
