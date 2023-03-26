# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
ENV['XT_API_BASE_FOROS'] = 'http://localhost:3001'
ENV['XT_GD_API_BASE_URI'] ||= 'localhost:3033'
ENV['XT_CLOUDLIBRARY_API_BASE_URI'] ||= 'localhost:3003'

require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'mongoid'
require 'webmock/rspec'
require 'faraday'

require 'database_cleaner-mongoid'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include RequestSpecHelper, type: :request
end

ActiveJob::Base.queue_adapter = :test

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

ALL_DATABASES = []

MONBO_DB_NAMES = %i[default files_mex sessions_latam sessions_mex files_esp files_mex files_latam]

def clean_test_data
  MONBO_DB_NAMES.each do |mongodb|
    DatabaseCleaner[:mongoid, db: mongodb].clean
  end
end

def strategy_test_data
  MONBO_DB_NAMES.each do |mongodb|
    DatabaseCleaner[:mongoid, db: mongodb].strategy = :deletion
  end
end

def start_clean_strategy_test_data
  MONBO_DB_NAMES.each do |mongodb|
    DatabaseCleaner[:mongoid, db: mongodb].start
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include FactoryBot::Syntax::Methods

  config.before :suite do
    DatabaseCleaner.clean_with(:deletion)
    DatabaseCleaner.strategy = :deletion
  end

  config.before :suite do
    strategy_test_data
  end

  config.before do
    start_clean_strategy_test_data
  end

  config.before do
    clean_test_data
  end
end

def stub_requests
  stub_request(:any, "%s" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
  stub_request(:any, "%s/crea_usuario.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
  stub_request(:any, "%s/modifica_usuario.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
  stub_request(:any, "%s/borra_usuario.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
  @group_request = stub_request(:any, "%s/crea_grupo.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
  stub_request(:any, "%s/modifica_grupo.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
  stub_request(:any, "%s/borra_grupo.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
  stub_request(:any, "%s/grupo_mueve_a_grupos.php" % ENV['XT_API_BASE_FOROS']).with(query: hash_including({}))
end
