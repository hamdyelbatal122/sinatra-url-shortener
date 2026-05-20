require 'sequel'

DB.create_table? :oauth_providers do
  primary_key :id
  foreign_key :user_id, :users, null: false
  String :provider, null: false # 'google', 'github'
  String :uid, null: false
  String :email, null: true
  String :name, null: true
  DateTime :created_at
  index [:provider, :uid], unique: true
  index :user_id
end

class OAuthProvider < Sequel::Model(:oauth_providers)
  many_to_one :user
end
