require 'sinatra'
require 'sinatra/sequel'
require 'json'
require 'bcrypt'
require 'dotenv/load'
require 'rack/protection'
require 'rack/cors'
require_relative 'config/rack_attack'

Dir[File.join(__dir__, 'models',     '*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, 'helpers',    '*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, 'services',   '*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, 'middleware', '*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, 'routes',     '*.rb')].sort.each { |f| require f }

use Rack::Cors do
  allow do
    origins ENV.fetch('ALLOWED_ORIGINS', '*')
    resource '/api/*', headers: :any, methods: %i[get post put delete options]
  end
end

use Rack::Attack
use SecurityHeaders

configure do
  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  set :erb, escape_html: true
  set :protection, except: :frame_options
  set :views, File.join(__dir__, 'views')

  EmailService.configure
end

configure :development do
  set :show_exceptions, true
  set :dump_errors, true
end

configure :production do
  set :show_exceptions, false
  set :dump_errors, false
end

error 404 do
  if request.path.start_with?('/api')
    content_type :json
    halt 404, { error: 'Resource not found' }.to_json
  end
  erb :not_found
end

error 500 do
  if request.path.start_with?('/api')
    content_type :json
    halt 500, { error: 'Internal server error' }.to_json
  end
  erb :error
end
