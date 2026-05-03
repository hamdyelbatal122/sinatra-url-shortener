module SecurityHeaders
  def self.set_headers(app)
    lambda do |env|
      status, headers, body = app.call(env)

      headers['X-Content-Type-Options'] = 'nosniff'
      headers['X-Frame-Options'] = 'SAMEORIGIN'
      headers['X-XSS-Protection'] = '1; mode=block'
      headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
      headers['Permissions-Policy'] = 'geolocation=(), microphone=(), camera=()'
      headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains' if ENV['RACK_ENV'] == 'production'

      [status, headers, body]
    end
  end
end
