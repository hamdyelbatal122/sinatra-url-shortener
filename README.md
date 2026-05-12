# Sinatra URL Shortener

A professional, production-ready URL shortener built with Ruby and Sinatra. Features OAuth authentication, email notifications, comprehensive API documentation, and advanced analytics.

[![CI/CD](https://github.com/hamdyelbatal122/Sinatra/workflows/CI%2FCD/badge.svg)](https://github.com/hamdyelbatal122/Sinatra/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Features

### Authentication & Security
- **Traditional Login**: Username and password authentication with bcrypt hashing
- **OAuth Integration**: Login with Google and GitHub
- **Role-Based Access Control**: Admin, Editor, and Reader roles
- **Session Management**: Secure session handling with configurable secrets
- **Rate Limiting**: Built-in rate limiting to prevent abuse
- **CSRF Protection**: Automatic CSRF token validation

### Link Management 
- **Create & Manage Links**: Create, edit, and delete shortened links
- **Advanced Search**: Search by name, URL, category, and tags
- **Hit Tracking**: Track the number of times each link is accessed
- **Categories & Tags**: Organize links with categories and tags
- **URL Parameters**: Support for dynamic URL parameters

### Analytics & Dashboard
- **Dashboard Analytics**: View total links, total hits, and top performers
- **Recent Activity**: Track recently created links
- **Audit Logging**: Complete audit trail of all actions
- **Hit Statistics**: Detailed hit tracking per link

### Notifications
- **Email Notifications**: Get notified when links are created or deleted
- **Configurable Preferences**: Enable/disable notifications per user
- **SMTP Support**: Works with any SMTP provider (Gmail, SendGrid, etc.)

### API & Documentation
- **RESTful API**: Complete API for programmatic access
- **OpenAPI 3.0 Spec**: Auto-generated API documentation
- **Swagger UI**: Interactive API documentation at `/api/docs/ui`
- **JSON Responses**: Consistent JSON API responses

### Developer Experience
- **Docker Support**: Containerized deployment with Docker and Docker Compose
- **Comprehensive Tests**: RSpec test suite with good coverage
- **CI/CD Pipeline**: GitHub Actions workflow for automated testing
- **Environment Configuration**: Easy configuration via .env files

## 🚀 Quick Start

### Prerequisites
- Ruby 3.0+
- Bundler
- SQLite3

### Installation

1. Clone the repository:
```bash
git clone https://github.com/hamdyelbatal122/Sinatra.git
cd Sinatra
```

2. Install dependencies:
```bash
bundle install
```

3. Configure environment:
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Run the application:
```bash
bundle exec rackup
```

Visit `http://localhost:4567` in your browser.

### Seed Admin User

```bash
ruby db/seeds.rb
```

Default credentials:
- **Username**: `admin`
- **Password**: `admin123`

## 🐳 Docker Deployment

### Using Docker Compose (Recommended for Development)

```bash
docker-compose up
```

The application will be available at `http://localhost:4567` and MailHog at `http://localhost:8025`.

### Using Docker

Build the image:
```bash
docker build -t sinatra-shortener .
```

Run the container:
```bash
docker run -p 4567:4567 \
  -e SESSION_SECRET=your-secret-key \
  -e GOOGLE_CLIENT_ID=your-google-id \
  -e GOOGLE_CLIENT_SECRET=your-google-secret \
  sinatra-shortener
```

## 🔐 OAuth Setup

### Google OAuth

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project
3. Enable Google+ API
4. Create OAuth 2.0 credentials (Web application)
5. Add authorized redirect URI: `http://localhost:4567/auth/google_oauth2/callback`
6. Set environment variables:
```bash
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-client-secret
```

### GitHub OAuth

1. Go to GitHub Settings > Developer settings > OAuth Apps
2. Create a new OAuth App
3. Set Authorization callback URL: `http://localhost:4567/auth/github/callback`
4. Set environment variables:
```bash
GITHUB_CLIENT_ID=your-client-id
GITHUB_CLIENT_SECRET=your-client-secret
```

## 📧 Email Configuration

Configure SMTP settings in `.env`:

```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_AUTH=plain
SMTP_TLS=true
MAIL_FROM=noreply@shortener.local
```

For Gmail, use an [App Password](https://support.google.com/accounts/answer/185833).

## 📚 API Documentation

### Interactive Documentation

Visit `/api/docs/ui` for interactive Swagger UI documentation.

### API Endpoints

#### List Links
```bash
GET /api/links
```

#### Get Link Details
```bash
GET /api/links/:id
```

#### Create Link (Admin Only)
```bash
POST /api/links
Content-Type: application/json

{
  "name": "docs",
  "url": "https://hamzi.dev/docs",
  "category": "documentation",
  "tags": "help,reference"
}
```

#### Delete Link (Admin Only)
```bash
DELETE /api/links/:id
```

## 👥 Roles & Permissions

| Role | Permissions |
|------|-------------|
| **Admin** | Full access - manage links, view dashboard, manage users |
| **Editor** | Create links, view dashboard, edit own links |
| **Reader** | View links, access redirects, read-only access |

## 🧪 Testing

Run the test suite:
```bash
bundle exec rspec
```

Run tests with coverage:
```bash
bundle exec rspec --format documentation
```

## 📋 Project Structure

```
.
├── app.rb                 # Main application file
├── config.ru              # Rack configuration
├── Gemfile                # Ruby dependencies
├── Dockerfile             # Docker configuration
├── docker-compose.yml     # Docker Compose configuration
├── models/                # Database models
│   ├── user.rb
│   ├── link.rb
│   ├── audit_log.rb
│   ├── oauth_provider.rb
│   └── email_notification.rb
├── routes/                # Route handlers
│   ├── auth.rb
│   ├── oauth.rb
│   ├── links.rb
│   ├── api.rb
│   ├── dashboard.rb
│   ├── settings.rb
│   └── docs.rb
├── helpers/               # Helper functions
│   ├── auth.rb
│   ├── audit_helper.rb
│   ├── view_helpers.rb
│   └── qr_helper.rb
├── services/              # Business logic
│   └── email_service.rb
├── views/                 # ERB templates
├── spec/                  # Tests
└── db/                    # Database files
```

## 🔧 Configuration

All configuration is done via environment variables. See `.env.example` for all available options.

Key variables:
- `SESSION_SECRET`: Session encryption key
- `DATABASE_URL`: Database connection string
- `SMTP_*`: Email configuration
- `GOOGLE_CLIENT_ID/SECRET`: Google OAuth credentials
- `GITHUB_CLIENT_ID/SECRET`: GitHub OAuth credentials
- `RATE_LIMIT_*`: Rate limiting configuration

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Sinatra](http://sinatrarb.com/)
- Database with [Sequel](https://sequel.jeremyevans.net/)
- Authentication with [OmniAuth](https://github.com/omniauth/omniauth)
- Testing with [RSpec](https://rspec.info/)

## 📞 Support

For issues, questions, or suggestions, please open an [issue](https://github.com/hamdyelbatal122/Sinatra/issues) on GitHub.

---

Made with ❤️ by [Hamdy Elbatal](https://github.com/hamdyelbatal122)
