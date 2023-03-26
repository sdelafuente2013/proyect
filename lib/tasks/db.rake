namespace :db do
  desc "Prepares all test databases for testing from binding gems"
  task prepare_for_binding_tests: :environment do
    prepare_db_for_binding
    prepare_db_for_binding('tirantid')
    seed_dbs
  end

  desc "Prepares all test databases for testing local API"
  task prepare_for_tests: :environment do
    p 'Preparing tolpro for tests'
    system('RAILS_ENV=test bundle exec rake db:drop db:create db:schema:load db:migrate')
    prepare_db_for_api
    prepare_db_for_api('tirantid')
    prepare_db_for_api('latam')
    prepare_db_for_api('mexico')
  end

  def prepare_db_for_binding(db_name = '')
    prepare_db('binding', db_name)
  end

  def prepare_db_for_api(db_name = '')
    prepare_db('API', db_name)
  end

  def prepare_db(context, db_name = '')
    db_title = db_name.blank? ? 'tolpro' : db_name
    db_prefix = db_name.blank? ? '' : "#{db_name}:"
    p "Preparing #{db_title} for #{context} tests"
    command = "RAILS_ENV=test bundle exec rake #{db_prefix}db:drop #{db_prefix}db:create #{db_prefix}db:schema:load #{db_prefix}db:migrate"
    system(command)
  end

  def seed_dbs
    p 'Seeding databases for binding tests'
    command = 'RAILS_ENV=test bundle exec rake db:seed'
    system(command)
  end

  task clean_db_tests: :environment do
    if ENV['RAILS_ENV'] == 'test'
      p 'Cleaning DB for tests'
      require 'database_cleaner'

      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean
      p 'Cleaned DB for tests'
    end
  end
end
