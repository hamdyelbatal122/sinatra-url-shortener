class SecurityHeaders
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    headers['X-Content-Type-Options']  = 'nosniff'
    headers['X-Frame-Options']         = 'SAMEORIGIN'
    headers['X-XSS-Protection']        = '0'  # Deprecated; rely on CSP instead
    headers['Referrer-Policy']         = 'strict-origin-when-cross-origin'
    headers['Permissions-Policy']      = 'geolocation=(), microphone=(), camera=()'

    if ENV['RACK_ENV'] == 'production'
      headers['Strict-Transport-Security'] = 'max-age=63072000; includeSubDomains; preload'
    end

    # Content-Security-Policy — relaxed for inline styles used in ERB views
    headers['Content-Security-Policy'] = [
      "default-src 'self'",
      "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net",
      "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
      "font-src 'self' https://fonts.gstatic.com",
      "img-src 'self' data: https:",
      "connect-src 'self'",
      "frame-ancestors 'none'"
    ].join('; ')

    [status, headers, body]
  end
end
