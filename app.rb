require 'sinatra'
require 'sinatra/sequel'
require 'json'
require 'bcrypt'
require 'dotenv/load'
require 'rack/protection'
require 'rack/cors'
require 'rack/attack'

Dir[File.join(__dir__, 'models', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'helpers', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'services', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'middleware', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'routes', '*.rb')].sort.each { |file| require file }

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end

use Rack::Attack
use SecurityHeaders

configure do
  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { 'supersecret-change-in-production' }
  set :erb, escape_html: true
  set :protection, except: :frame_options

  EmailService.configure
end

error 404 do
  erb :not_found
end

error 500 do
  erb :error
end
