require 'rack/attack'

# Simple thread-safe memory store — no Rails/ActiveSupport needed
class MemoryStore
  def initialize
    @mutex = Mutex.new
    @data  = {}
    @ttls  = {}
  end

  def read(key)
    @mutex.synchronize do
      return nil if expired?(key)
      @data[key]
    end
  end

  def write(key, value, options = {})
    @mutex.synchronize do
      @data[key] = value
      @ttls[key] = Time.now + options[:expires_in] if options[:expires_in]
    end
    value
  end

  def increment(key, amount, options = {})
    @mutex.synchronize do
      @data.delete(key) if expired?(key)
      current = (@data[key] || 0) + amount
      @data[key] = current
      @ttls[key] = Time.now + options[:expires_in] if options[:expires_in] && !@ttls[key]
      current
    end
  end

  def delete(key)
    @mutex.synchronize { @data.delete(key); @ttls.delete(key) }
  end

  private

  def expired?(key)
    ttl = @ttls[key]
    ttl && ttl < Time.now
  end
end

Rack::Attack.cache.store = MemoryStore.new

# Bypass rate limiting in test environment
Rack::Attack.safelist('bypass_in_test') do |req|
  ENV['RACK_ENV'] == 'test'
end

# ── Throttle rules ──────────────────────────────────────────────────────────

# Global: 300 requests per 5 minutes per IP (skip static assets)
Rack::Attack.throttle('global/ip', limit: 300, period: 300) do |req|
  req.ip unless req.path.start_with?('/assets', '/favicon')
end

# Login protection: 10 attempts per 20 minutes per IP
Rack::Attack.throttle('login/ip', limit: 10, period: 1200) do |req|
  req.ip if req.path == '/login' && req.post?
end

# API: 100 requests per minute per IP
Rack::Attack.throttle('api/ip', limit: 100, period: 60) do |req|
  req.ip if req.path.start_with?('/api')
end

# ── Response for throttled requests ─────────────────────────────────────────

Rack::Attack.throttled_responder = lambda do |req|
  match_data = req.env['rack.attack.match_data'] || {}
  now        = match_data[:epoch_time] || Time.now.to_i
  period     = match_data[:period]     || 60
  limit      = match_data[:limit]      || 0

  headers = {
    'Content-Type'          => 'application/json',
    'X-RateLimit-Limit'     => limit.to_s,
    'X-RateLimit-Remaining' => '0',
    'X-RateLimit-Reset'     => (now + period - now % period).to_s,
    'Retry-After'           => period.to_s
  }

  body = { error: 'Too many requests. Please wait before trying again.' }.to_json
  [429, headers, [body]]
end
