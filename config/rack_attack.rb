require 'rack/attack'

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.throttle('req/ip', limit: 300, period: 5.minutes) do |req|
  req.ip
end

Rack::Attack.throttle('logins/ip', limit: 5, period: 20.minutes) do |req|
  req.ip if req.path == '/login' && req.post?
end

Rack::Attack.throttle('api/ip', limit: 100, period: 1.minute) do |req|
  req.ip if req.path.start_with?('/api')
end
