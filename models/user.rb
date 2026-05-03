require 'sequel'

migration 'create users' do
  database.create_table? :users do
    primary_key :id
    String :username, unique: true, null: true
    String :password_hash, null: true
    String :email, unique: true, null: true
    String :role, default: 'user', null: false
    Boolean :email_notifications_enabled, default: true
    DateTime :created_at
    index :username
    index :email
  end
end

class User < Sequel::Model
  ROLES = %w[admin editor reader].freeze

  one_to_many :oauth_providers
  one_to_many :email_notifications

  def password=(password)
    self.password_hash = BCrypt::Password.create(password) if password
  end

  def authenticate(password)
    return false unless password_hash
    BCrypt::Password.new(self.password_hash) == password
  end

  def oauth_connected?(provider)
    oauth_providers.any? { |op| op.provider == provider }
  end

  def email_notifications_enabled?
    email_notifications_enabled && email.present?
  end

  def validate
    super
    if username && username.to_s.strip.empty?
      errors.add(:username, 'cannot be empty')
    end
    errors.add(:role, "must be one of: #{ROLES.join(', ')}") unless ROLES.include?(role)
  end
end
