require 'cloudlibrary'

CloudLibrary.setup do |config|
  config.base_uri=ENV['XT_CLOUDLIBRARY_API_BASE_URI'] || 'gaspar.tirant.net:3003'
  config.retries_per_call = 3
  config.wait_between_retries = 0.5
  config.testmode = Rails.env.test?
end
