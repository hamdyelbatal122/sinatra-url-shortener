# Quick Reference Guide

## 🚀 Getting Started

### Local Development
```bash
# Clone and setup
git clone https://github.com/hamdyelbatal122/Sinatra.git
cd Sinatra
bundle install
cp .env.example .env

# Run application
bundle exec rackup
# Visit http://localhost:4567
```

### Docker
```bash
# Using Docker Compose (recommended)
docker-compose up

# Using Docker directly
docker build -t sinatra-shortener .
docker run -p 4567:4567 sinatra-shortener
```

## 📝 Default Credentials

After running `ruby db/seeds.rb`:
- **Username**: admin
- **Password**: admin123

## 🔑 Environment Variables

Essential variables in `.env`:
```bash
SESSION_SECRET=your-secret-key
APP_URL=http://localhost:4567
GOOGLE_CLIENT_ID=your-id
GOOGLE_CLIENT_SECRET=your-secret
GITHUB_CLIENT_ID=your-id
GITHUB_CLIENT_SECRET=your-secret
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

## 🧪 Testing

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/integration_spec.rb

# Run with coverage
bundle exec rspec --format documentation
```

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| README.md | Project overview and quick start |
| API.md | Complete API reference |
| DEPLOYMENT.md | Deployment instructions |
| SECURITY.md | Security best practices |
| CONTRIBUTING.md | How to contribute |
| CODE_OF_CONDUCT.md | Community standards |
| PROJECT_SUMMARY.md | Detailed project overview |
| GITHUB_READINESS.md | GitHub readiness checklist |

## 🌐 Key URLs

| URL | Purpose |
|-----|---------|
| `/` | Home page with links |
| `/login` | Login page |
| `/dashboard` | Analytics dashboard |
| `/settings` | Account settings |
| `/api/links` | API endpoint |
| `/api/docs` | OpenAPI specification |
| `/api/docs/ui` | Interactive API documentation |

## 👥 User Roles

| Role | Permissions |
|------|-------------|
| Admin | Full access, manage all links |
| Editor | Create links, view dashboard |
| Reader | View links, access redirects |

## 🔐 Security Features

- ✅ OAuth (Google, GitHub)
- ✅ Password hashing (BCrypt)
- ✅ CSRF protection
- ✅ Rate limiting
- ✅ Input validation
- ✅ SQL injection prevention
- ✅ XSS prevention
- ✅ Security headers
- ✅ Audit logging

## 📊 API Quick Reference

### List Links
```bash
curl http://localhost:4567/api/links
```

### Create Link (Admin)
```bash
curl -X POST http://localhost:4567/api/links \
  -H "Content-Type: application/json" \
  -d '{"name":"docs","url":"https://example.com"}'
```

### Get Link
```bash
curl http://localhost:4567/api/links/1
```

### Delete Link (Admin)
```bash
curl -X DELETE http://localhost:4567/api/links/1
```

## 🛠️ Common Tasks

### Change Admin Password
1. Login as admin
2. Go to `/settings`
3. Enter current and new password
4. Click "Update Password"

### Connect OAuth
1. Go to `/settings`
2. Click "Connect Google" or "Connect GitHub"
3. Authorize the application
4. Account is linked

### Enable Email Notifications
1. Go to `/settings`
2. Check "Enable email notifications"
3. Click "Save Preferences"

### Create a Link
1. Login as Editor or Admin
2. Fill in link name and URL
3. Optionally add category and tags
4. Click "Create Link"

### View Analytics
1. Login as Editor or Admin
2. Go to `/dashboard`
3. View statistics and recent activity

## 🐛 Troubleshooting

### Port Already in Use
```bash
lsof -i :4567
kill -9 <PID>
```

### Database Issues
```bash
# Reset database
rm db/development.sqlite3
bundle exec rackup
```

### Email Not Sending
- Check SMTP credentials in `.env`
- Verify firewall allows SMTP port
- Check email logs in database

### OAuth Not Working
- Verify callback URLs match exactly
- Check client ID and secret
- Ensure environment variables are set

## 📦 Project Structure

```
Sinatra/
├── app.rb              # Main application
├── models/             # Database models
├── routes/             # Route handlers
├── helpers/            # Helper functions
├── services/           # Business logic
├── views/              # Templates
├── spec/               # Tests
├── db/                 # Database
└── docs/               # Documentation
```

## 🚀 Deployment

### Heroku
```bash
heroku create your-app
git push heroku main
```

### Docker
```bash
docker build -t sinatra-shortener .
docker run -p 4567:4567 sinatra-shortener
```

### Traditional VPS
```bash
# Install Ruby, Bundler
bundle install
bundle exec puma -p 4567 -w 4
# Configure Nginx reverse proxy
```

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/hamdyelbatal122/Sinatra/issues)
- **Security**: security@example.com
- **Documentation**: See docs folder

## 🎓 Learning Resources

- [Sinatra Guide](http://sinatrarb.com/)
- [Sequel ORM](https://sequel.jeremyevans.net/)
- [OmniAuth](https://github.com/omniauth/omniauth)
- [RSpec](https://rspec.info/)

## ✅ Checklist for First Run

- [ ] Clone repository
- [ ] Run `bundle install`
- [ ] Copy `.env.example` to `.env`
- [ ] Run `ruby db/seeds.rb`
- [ ] Run `bundle exec rackup`
- [ ] Visit `http://localhost:4567`
- [ ] Login with admin/admin123
- [ ] Create a test link
- [ ] View dashboard
- [ ] Check API at `/api/links`

---

**Version**: 2.0.0 - Professional Edition

**Last Updated**: 2026-05-03
