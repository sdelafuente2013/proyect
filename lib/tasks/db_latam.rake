task spec: ["latam:db:test:prepare"]

namespace :latam do
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

    namespace :migrate do
      task :status do
        Rake::Task["db:migrate:status"].invoke
      end

      task :down do
        Rake::Task["db:migrate:down"].invoke
      end
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
      task.enhance ["latam:set_custom_config"] do
        Rake::Task["latam:revert_to_original_config"].invoke
      end
    end
  end

  task :set_custom_config do
    @original_config = {
      env_schema: ENV['SCHEMA'],
      config: Rails.application.config.dup
    }

    ENV['SCHEMA'] = "db_latam/schema.rb"
    Rails.application.config.paths['db'] = ["db_latam"]
    Rails.application.config.paths['db/migrate'] = ["db_latam/migrate"]
    Rails.application.config.paths['db/seeds'] = ["db_latam/seeds"]
    Rails.application.config.paths['config/database'] = ["config/database_latam.yml"]
  end

  task :revert_to_original_config do
    ENV['SCHEMA'] = @original_config[:env_schema]
    Rails.application.config = @original_config[:config]
  end
end

