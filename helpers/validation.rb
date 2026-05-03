module InputValidation
  def self.validate_url(url)
    return false if url.blank?
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end

  def self.validate_email(email)
    return false if email.blank?
    email.match?(/\A[^@\s]+@[^@\s]+\.[^@\s]+\z/)
  end

  def self.validate_username(username)
    return false if username.blank?
    username.length >= 3 && username.length <= 50 && username.match?(/\A[a-zA-Z0-9_-]+\z/)
  end

  def self.sanitize_string(str)
    return '' if str.blank?
    str.strip.gsub(/[<>]/, '')
  end
end
