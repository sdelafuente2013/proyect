task spec: ["tirantid:db:test:prepare"]

namespace :tirantid do
  
  task prepare_for_tests: :environment do
    include ActiveRecord::Tasks
    Rake::Task["tirantid:set_custom_config"].execute
    p 'Setting environment to test TirantID...'
    DatabaseTasks.env = 'test'
    p 'Purging current database TirantID...'
    Rake::Task["tirantid:db:drop"].execute
    Rake::Task["tirantid:db:create"].execute
    p 'Loding schema TirantID...'
    #Rake::Task["tirantid:db:schema:load"].execute (" --schema-file db_tirantid/schema.rb")
    DatabaseTasks.load_schema_current(ActiveRecord::Base.schema_format, "db_tirantid/schema.rb")    
    p 'Loading migrations TirantID...'
    DatabaseTasks.migrations_paths="db_tirantid/migrate/"
    DatabaseTasks.migrate
    p 'db prepared for tests TirantID'
  end
  
  namespace :db do |ns|
    
    task :drop do
      Rake::Task["db:drop"].invoke
    end

    task :create do
      Rake::Task["db:create"].invoke
    end

    task :setup do
      Rake::Task["db:setup"].invoke
    end

    task :migrate do
      Rake::Task["db:migrate"].invoke
    end

    task :rollback do
      Rake::Task["db:rollback"].invoke
    end

    task :seed do
      Rake::Task["db:seed"].invoke
    end

    task :version do
      Rake::Task["db:version"].invoke
    end

    namespace :schema do
      task :load do
        Rake::Task["db:schema:load"].invoke
      end

      task :dump do
        Rake::Task["db:schema:dump"].invoke
      end
    end

    namespace :test do
      task :prepare do
        Rake::Task["db:test:prepare"].invoke
      end
    end

    ns.tasks.each do |task|
      task.enhance ["tirantid:set_custom_config"] do
        Rake::Task["tirantid:revert_to_original_config"].invoke
      end
    end
    
  end

  task :set_custom_config do
    @original_config = {
      env_schema: ENV['SCHEMA'],
      config: Rails.application.config.dup
    }
    #@original_config[:env_schema] = "db_tirantid/schema.rb"
    Rails.application.config.paths['db'] = ["db_tirantid"]
    Rails.application.config.paths['db/migrate'] = ["db_tirantid/migrate"]
    Rails.application.config.paths['db/seeds'] = ["db_tirantid/seeds"]
    Rails.application.config.paths['config/database'] = ["config/database_tirantid.yml"]
  end

  task :revert_to_original_config do
    ENV['SCHEMA'] = @original_config[:env_schema]
    Rails.application.config = @original_config[:config]
  end
  
end

