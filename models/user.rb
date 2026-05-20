require 'sequel'

migration 'create users' do
  database.create_table? :users do
    primary_key :id
    String   :username, unique: true, null: true
    String   :password_hash, null: true
    String   :email, unique: true, null: true
    String   :role, default: 'reader', null: false
    TrueClass :email_notifications_enabled, default: true
    DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    DateTime :updated_at, null: true
    index :username
    index :email
  end
end

class User < Sequel::Model
  ROLES = %w[admin editor reader].freeze

  one_to_many :oauth_providers
  one_to_many :email_notifications

  def before_create
    self.created_at ||= Time.now
    super
  end

  def before_update
    self.updated_at = Time.now
    super
  end

  def password=(password)
    self.password_hash = BCrypt::Password.create(password) if password && !password.empty?
  end

  def authenticate(password)
    return false unless password_hash && password
    BCrypt::Password.new(password_hash) == password
  end

  def oauth_connected?(provider)
    oauth_providers.any? { |op| op.provider == provider.to_s }
  end

  # Pure Ruby check — no Rails .present? dependency
  def email_notifications_enabled?
    email_notifications_enabled == true && !email.to_s.strip.empty?
  end

  def admin?
    role == 'admin'
  end

  def editor?
    role == 'editor'
  end

  def validate
    super
    errors.add(:username, 'cannot be blank') if username && username.to_s.strip.empty?
    errors.add(:role, "must be one of: #{ROLES.join(', ')}") unless ROLES.include?(role.to_s)
    if email && !email.to_s.match?(/\A[^@\s]+@[^@\s]+\z/)
      errors.add(:email, 'is not a valid email address')
    end
  end
end
