module InputValidation
  def self.blank?(val)
    val.nil? || val.to_s.strip.empty?
  end

  def self.validate_url(url)
    return false if blank?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end

  def self.validate_email(email)
    return false if blank?(email)
    email.match?(/\A[^@\s]+@[^@\s]+\.[^@\s]+\z/)
  end

  def self.validate_username(username)
    return false if blank?(username)
    username.length >= 3 && username.length <= 50 && username.match?(/\A[a-zA-Z0-9_-]+\z/)
  end

  def self.sanitize_string(str)
    return '' if blank?(str)
    str.strip.gsub(/[<>]/, '')
  end
end
