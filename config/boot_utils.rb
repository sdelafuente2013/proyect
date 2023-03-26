require 'net/ping'
require 'sidekiq/api'

def nearest_ping_host(hosts=[])
  i = 0
  hosts.map do |host_name|
    begin
      i+=1
      p= Net::Ping::External.new(host_name)
      p.ping
      [p.duration || (100+i),host_name]
    rescue => e
      puts e.inspect
      [1000+i,host_name]
    end
  end.min do |h1,h2|
    h1[0] <=> h2[0]
  end[1]
end


def api_pool_size
  defined?(Sidekiq) && (Sidekiq.server?) ? 7 : (ENV.fetch("prod_rails_max_threads") { 20 })
end
