
task :start do
  redis_url = ENV['REDIS_URL'] || 'redis://localhost/'
  environment = ENV['RAILS_ENV'] || 'test'
  port = ENV['port'] || '3001'

  p "Starting Rails for #{environment} in port #{port}"
  exec("REDIS_URL=#{redis_url} RAILS_ENV=#{environment} bundle exec rails s -p #{port}")
end
