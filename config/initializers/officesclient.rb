require 'officesclient'

OfficesClient.setup do |config|
  config.base_uri = ENV['XT_GD_API_BASE_URI'] || 'gaspar.tirant.net:3002'
  config.retries_per_call = 3
  config.wait_between_retries = 0.5
  config.testmode = Rails.env.test?
end
