DB_MEXICO= YAML::load(ERB.new(File.read(Rails.root.join("config","database_mexico.yml"))).result)[Rails.env]

