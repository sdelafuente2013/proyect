# save stats database settings in global var
DB_TIRANTID = YAML::load(ERB.new(File.read(Rails.root.join("config","database_tirantid.yml"))).result)[Rails.env]
