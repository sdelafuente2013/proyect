# save stats database settings in global var
DB_DEFAULT = YAML::load(ERB.new(File.read(Rails.root.join("config","database.yml"))).result)[Rails.env]
