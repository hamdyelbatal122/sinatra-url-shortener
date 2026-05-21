ENV['RACK_ENV'] = 'test'
ENV['DATABASE_URL'] = 'sqlite://db/test.sqlite3'
ENV['SESSION_SECRET'] = 'a' * 64

require 'rack/test'
require 'rspec'
require 'fileutils'

FileUtils.mkdir_p('db')

require_relative '../app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    # DB is already configured in app.rb and tables are created when models are loaded
  end

  config.before do
    EmailNotification.dataset.delete
    OAuthProvider.dataset.delete
    Link.dataset.delete
    User.dataset.delete
    AuditLog.dataset.delete
  end
end

def app
  Sinatra::Application
end

def create_user(username: 'testuser', password: 'password123', role: 'editor', email: 'test@hamzi.dev')
  user = User.create(username: username, role: role, email: email)
  user.password = password
  user.save
  user
end

def login(username: 'testuser', password: 'password123')
  post '/login', username: username, password: password
end
