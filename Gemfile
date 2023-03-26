# frozen_string_literal: true

# rubocop:disable Layout/LineLength

source 'https://rubygems.org'

ruby '2.5.5'

gem 'net-ping', '~>2.0.5'
gem 'makara'
gem 'rails', '~> 5.1.5'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.7'
gem 'kaminari'
gem 'redis-namespace' , '~> 1.6'
gem 'sidekiq', '5.1.3'

# TODO Allow mongoid to be updated.
# Currently updating to 7.3 breaks our app because Boolean type (at least)
# https://docs.mongodb.com/mongoid/current/tutorials/mongoid-upgrade/#boolean-removed
gem "mongoid", "7.1.2"

gem 'kaminari-mongoid', '~> 1.0.1'
gem 'activerecord-import', '~> 0.22'
gem 'composite_primary_keys'
gem 'bcrypt', '~> 3.1.7'
gem 'figaro', '~> 1.1.1'
gem 'config', '~> 2.0.0'
gem 'rsolr', '~> 2.2.1'
gem 'attr_extras', '~> 6.2.4'
gem 'factory_trace'

gem "cloudlibrary", "0.0.13", git: "https://oauth2:d7bQueBzQdzdb3qsctkF@git.tirant.net/xt/cloudlibraryclient.git", branch: "master"
gem "officesclient", "0.0.18", git: "https://oauth2:d7bQueBzQdzdb3qsctkF@git.tirant.net/xt/OfficesClient.git", branch: "master"
gem "tol-bbdd-style", "0.2.4", git: "https://oauth2:d7bQueBzQdzdb3qsctkF@git.tirant.net/xt/tol-bbdd-style.git", branch: "master"
gem "xtbaseclient", "0.0.38", git: "https://oauth2:d7bQueBzQdzdb3qsctkF@git.tirant.net/xt/xtbaseclient.git", branch: "master"

# Run one-time scripts
gem 'after_party', '~> 1.11.2'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails', '~> 0.3.9'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'rspec-rails', '~> 4.1.0'
  gem 'faker', '~> 1.8.7'

  gem "pronto", "~> 0.11.0"
  gem "pronto-flay", "~> 0.11.0", require: false
  gem "pronto-rubocop", "~> 0.11.1", require: false
end

group :test do
  gem 'database_cleaner'
  gem 'database_cleaner-mongoid'
  gem 'shoulda-matchers'
  gem 'timecop', '~> 0.9.4'
  gem 'webmock'
end

group :development do
  gem "capistrano", "3.11", require: false
  gem "capistrano-bundler"
  gem "capistrano-puma"
  gem 'capistrano-sidekiq'
  gem 'capistrano-rvm'
  gem 'letter_opener_web', '~> 1.4.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'exception_notification'
end

# rubocop:enable Layout/LineLength
