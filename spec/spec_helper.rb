ENV['RACK_ENV'] = 'test'
ENV['DATABASE_URL'] = 'sqlite://db/test.sqlite3'
ENV['SESSION_SECRET'] = 'test-secret'

require 'rack/test'
require 'rspec'
require 'fileutils'

FileUtils.mkdir_p('db')

require_relative '../app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    DB.drop_table?(:email_notifications)
    DB.drop_table?(:oauth_providers)
    DB.drop_table?(:audit_logs)
    DB.drop_table?(:links)
    DB.drop_table?(:users)

    DB.create_table :users do
      primary_key :id
      String :username, unique: true, null: true
      String :password_hash, null: true
      String :email, unique: true, null: true
      String :role, default: 'reader', null: false
      Boolean :email_notifications_enabled, default: true
      DateTime :created_at
    end

    DB.create_table :oauth_providers do
      primary_key :id
      Integer :user_id, null: false
      String :provider, null: false
      String :uid, null: false
      String :email, null: true
      String :name, null: true
      DateTime :created_at
      index [:provider, :uid], unique: true
    end

    DB.create_table :links do
      primary_key :id
      String :name, unique: true, null: false
      String :url, null: false
      String :category
      String :tags
      Integer :hits, default: 0
      DateTime :created_at
    end

    DB.create_table :audit_logs do
      primary_key :id
      String :action, null: false
      String :entity_type, null: false
      Integer :entity_id, null: false
      Integer :user_id
      String :details
      DateTime :created_at
    end

    DB.create_table :email_notifications do
      primary_key :id
      Integer :user_id, null: false
      String :event_type, null: false
      String :subject, null: false
      String :body, null: false
      String :status, default: 'pending', null: false
      DateTime :sent_at, null: true
      DateTime :created_at
    end
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

def create_user(username: 'testuser', password: 'password123', role: 'editor', email: 'test@example.com')
  user = User.create(username: username, role: role, email: email)
  user.password = password
  user.save
  user
end

def login(username: 'testuser', password: 'password123')
  post '/login', username: username, password: password
end
