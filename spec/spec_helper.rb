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
    Sinatra::Application.settings.raise_errors = true
    Sinatra::Application.settings.show_exceptions = false
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

def create_user(username: nil, password: 'password123', role: 'editor', email: nil)
  if username.nil?
    if User[username: 'testuser'].nil?
      username = 'testuser'
    else
      i = 1
      while User[username: "testuser#{i}"]
        i += 1
      end
      username = "testuser#{i}"
    end
  end
  email ||= "#{username}@hamzi.dev"
  user = User.create(username: username, role: role, email: email)
  user.password = password
  user.save
  user
end

def login(username: 'testuser', password: 'password123')
  post '/login', username: username, password: password
end
