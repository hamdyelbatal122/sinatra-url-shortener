# Security Policy

## Reporting Security Vulnerabilities

If you discover a security vulnerability, please email security@hamzi.dev instead of using the issue tracker. Please include:

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

We will acknowledge receipt within 48 hours and provide an estimated timeline for a fix.

## Security Features

### Authentication & Authorization

- **Password Hashing**: BCrypt with salt
- **Session Management**: Secure session cookies with configurable secrets
- **OAuth 2.0**: Support for Google and GitHub authentication
- **Role-Based Access Control**: Admin, Editor, Reader roles
- **CSRF Protection**: Automatic CSRF token validation

### Data Protection

- **Input Validation**: All user inputs are validated and sanitized
- **SQL Injection Prevention**: Parameterized queries via Sequel ORM
- **XSS Prevention**: HTML escaping enabled by default
- **URL Validation**: Strict URL format validation

### Network Security

- **HTTPS**: Enforced in production via security headers
- **CORS**: Configurable cross-origin resource sharing
- **Rate Limiting**: Prevents brute force and DoS attacks
- **Security Headers**: 
  - X-Content-Type-Options: nosniff
  - X-Frame-Options: SAMEORIGIN
  - X-XSS-Protection: 1; mode=block
  - Strict-Transport-Security: max-age=31536000

### API Security

- **Authentication Required**: Most endpoints require login
- **Authorization Checks**: Role-based access control
- **Rate Limiting**: Per-IP rate limits on API endpoints
- **JSON Validation**: Strict JSON parsing

### Audit & Logging

- **Audit Trail**: All sensitive actions are logged
- **User Activity**: Track who did what and when
- **Error Logging**: Detailed error logs for debugging
- **Email Notifications**: Alert users of important events

## Best Practices

### For Administrators

1. **Change Default Credentials**
   ```bash
   # After first run, change admin password
   ```

2. **Set Strong Session Secret**
   ```bash
   SESSION_SECRET=$(openssl rand -hex 32)
   ```

3. **Use HTTPS in Production**
   - Obtain SSL certificate (Let's Encrypt recommended)
   - Configure reverse proxy (Nginx/Apache)
   - Set HSTS headers

4. **Regular Backups**
   ```bash
   # Daily backup
   0 2 * * * cp /app/db/production.sqlite3 /backups/production.sqlite3.$(date +\%Y\%m\%d)
   ```

5. **Monitor Audit Logs**
   - Review audit logs regularly
   - Set up alerts for suspicious activity
   - Archive logs for compliance

6. **Keep Dependencies Updated**
   ```bash
   bundle update
   bundle audit check --update
   ```

7. **Use Environment Variables**
   - Never commit secrets to version control
   - Use `.env` files locally (not in git)
   - Use secure secret management in production

### For Users

1. **Strong Passwords**
   - Minimum 8 characters
   - Mix of uppercase, lowercase, numbers, symbols
   - Unique per service

2. **OAuth Authentication**
   - Prefer OAuth over password authentication
   - Use Google or GitHub accounts
   - Reduces password management burden

3. **Email Notifications**
   - Enable email notifications
   - Review notification emails
   - Report suspicious activity

4. **Session Security**
   - Don't share session cookies
   - Log out when done
   - Use HTTPS only

## Compliance

### GDPR

- User data is stored securely
- Users can request data export
- Users can request account deletion
- Privacy policy available

### OWASP Top 10

1. **Injection**: Parameterized queries, input validation
2. **Broken Authentication**: Secure password hashing, session management
3. **Sensitive Data Exposure**: HTTPS, secure headers
4. **XML External Entities**: Not applicable (JSON only)
5. **Broken Access Control**: Role-based access control
6. **Security Misconfiguration**: Secure defaults, environment variables
7. **Cross-Site Scripting**: HTML escaping, input validation
8. **Insecure Deserialization**: Not applicable
9. **Using Components with Known Vulnerabilities**: Regular updates
10. **Insufficient Logging & Monitoring**: Comprehensive audit logging

## Security Updates

- Security patches are released as soon as possible
- Critical vulnerabilities: within 24 hours
- High severity: within 1 week
- Medium severity: within 2 weeks
- Low severity: included in next release

## Vulnerability Disclosure

We follow responsible disclosure practices:

1. Vulnerability reported
2. Acknowledgment within 48 hours
3. Investigation and fix development
4. Security release published
5. Public disclosure after fix is available

## Security Checklist

- [ ] Change default admin password
- [ ] Set strong SESSION_SECRET
- [ ] Configure OAuth credentials
- [ ] Set up HTTPS/SSL
- [ ] Configure email notifications
- [ ] Enable rate limiting
- [ ] Set up audit log monitoring
- [ ] Configure backups
- [ ] Review security headers
- [ ] Update dependencies regularly
- [ ] Monitor for suspicious activity
- [ ] Test disaster recovery

## Contact

- **Security Issues**: security@hamzi.dev
- **General Questions**: support@hamzi.dev
- **GitHub Issues**: https://github.com/hamdyelbatal122/Sinatra/issues

## References

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [GDPR Compliance](https://gdpr-info.eu/)
- [Ruby Security](https://guides.rubyonrails.org/security.html)
- [Sinatra Security](http://sinatrarb.com/security.html)
