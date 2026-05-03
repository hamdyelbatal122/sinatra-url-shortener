require 'mail'

class EmailService
  def self.configure
    Mail.defaults do
      delivery_method :smtp, {
        address: ENV.fetch('SMTP_HOST', 'localhost'),
        port: ENV.fetch('SMTP_PORT', 587).to_i,
        user_name: ENV.fetch('SMTP_USER', nil),
        password: ENV.fetch('SMTP_PASSWORD', nil),
        authentication: ENV.fetch('SMTP_AUTH', 'plain'),
        enable_starttls_auto: ENV.fetch('SMTP_TLS', 'true') == 'true'
      }
    end
  end

  def self.send_link_created_notification(user, link)
    return unless user.email_notifications_enabled?

    subject = "New Link Created: #{link.name}"
    body = <<~HTML
      <h2>New Link Created</h2>
      <p>A new link has been created in your URL shortener:</p>
      <ul>
        <li><strong>Name:</strong> #{link.name}</li>
        <li><strong>URL:</strong> #{link.url}</li>
        <li><strong>Category:</strong> #{link.category || 'N/A'}</li>
        <li><strong>Created:</strong> #{link.created_at}</li>
      </ul>
      <p><a href="#{ENV.fetch('APP_URL', 'http://localhost:4567')}/dashboard">View Dashboard</a></p>
    HTML

    send_email(user, subject, body, 'link_created')
  end

  def self.send_link_deleted_notification(user, link_name)
    return unless user.email_notifications_enabled?

    subject = "Link Deleted: #{link_name}"
    body = <<~HTML
      <h2>Link Deleted</h2>
      <p>A link has been deleted from your URL shortener:</p>
      <ul>
        <li><strong>Name:</strong> #{link_name}</li>
        <li><strong>Deleted:</strong> #{Time.now}</li>
      </ul>
      <p><a href="#{ENV.fetch('APP_URL', 'http://localhost:4567')}/dashboard">View Dashboard</a></p>
    HTML

    send_email(user, subject, body, 'link_deleted')
  end

  private

  def self.send_email(user, subject, body, event_type)
    notification = EmailNotification.create(
      user_id: user.id,
      event_type: event_type,
      subject: subject,
      body: body,
      status: 'pending'
    )

    begin
      mail = Mail.new do
        from ENV.fetch('MAIL_FROM', 'noreply@shortener.local')
        to user.email
        subject subject
        html_part do
          content_type 'text/html; charset=UTF-8'
          body body
        end
      end

      mail.deliver!
      notification.update(status: 'sent', sent_at: Time.now)
    rescue => e
      notification.update(status: 'failed')
      puts "Email delivery failed: #{e.message}"
    end
  end
end
