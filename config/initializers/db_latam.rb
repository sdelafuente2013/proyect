DB_LATAM= YAML::load(ERB.new(File.read(Rails.root.join("config","database_latam.yml"))).result)[Rails.env]

