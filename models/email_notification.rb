require 'sequel'

migration 'create email_notifications' do
  database.create_table? :email_notifications do
    primary_key :id
    foreign_key :user_id, :users, null: false
    String :event_type, null: false # 'link_created', 'link_deleted'
    String :subject, null: false
    String :body, null: false
    String :status, default: 'pending', null: false # 'pending', 'sent', 'failed'
    DateTime :sent_at, null: true
    DateTime :created_at
    index :user_id
    index :status
  end
end

class EmailNotification < Sequel::Model
  many_to_one :user
end
