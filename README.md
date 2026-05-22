# Sinatra URL Shortener

A self-hosted URL shortener built with Ruby and Sinatra. Designed to be lightweight, fast, and easy to run anywhere — from a Raspberry Pi to a Docker container.

[![CI](https://github.com/hamdyelbatal122/Sinatra/actions/workflows/ci.yml/badge.svg)](https://github.com/hamdyelbatal122/Sinatra/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Ruby](https://img.shields.io/badge/Ruby-3.2%2B-red.svg)](https://www.ruby-lang.org/)

---

## Features

- **Link Management**: Create, edit, and delete shortened links with dynamic URL parameters
- **Hit Tracking**: Track the number of times each link is accessed and generate QR codes
- **Role-based access** — Admin, Editor, Reader
- **OAuth login** — Google and GitHub
- **Email notifications** via SMTP (MailHog for local dev)
- **REST API** with JSON responses
- **Audit log** for all create/delete events
- **Search & filter** by name, URL, category, and tags
- **Docker-ready** — single command to run everything

---

## Quick start

### Requirements

- Ruby 3.2+
- Bundler (`gem install bundler`)
- SQLite3

### Run locally

```bash
git clone https://github.com/hamdyelbatal122/Sinatra.git
cd Sinatra

# Install dependencies
bundle install

# Configure environment
cp .env.example .env
# Edit .env with your settings

# Seed the database (creates admin user)
ruby db/seeds.rb

# Start the server
bundle exec rackup -p 4567
```

Open [http://localhost:4567](http://localhost:4567) in your browser.

**Default credentials:** `admin` / `admin123` — change this immediately.

---

## Docker

### With Docker Compose (recommended)

```bash
docker compose up
```

| Service | URL |
|---------|-----|
| App | http://localhost:4567 |
| MailHog | http://localhost:8025 |

### Standalone container

```bash
docker build -t sinatra-shortener .

docker run -p 4567:4567 \
  -e SESSION_SECRET=$(openssl rand -hex 32) \
  -e RACK_ENV=production \
  -v ./db:/app/db \
  sinatra-shortener
```

---

## Makefile shortcuts

```bash
make install      # Install gems
make dev          # Start dev server with auto-reload
make test         # Run test suite
make seed         # Seed the database
make docker-up    # Start with Docker Compose
make docker-down  # Stop containers
make help         # Show all commands
```

---

## OAuth setup

### Google

1. Open [Google Cloud Console](https://console.cloud.google.com/) → Credentials → Create OAuth 2.0 client
2. Set the redirect URI: `http://localhost:4567/auth/google_oauth2/callback`
3. Add to `.env`:

```
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-client-secret
```

### GitHub

1. GitHub Settings → Developer settings → OAuth Apps → New OAuth App
2. Set the callback URL: `http://localhost:4567/auth/github/callback`
3. Add to `.env`:

```
GITHUB_CLIENT_ID=your-client-id
GITHUB_CLIENT_SECRET=your-client-secret
```

---

## Email

The app sends notifications when links are created or deleted. For local development, [MailHog](https://github.com/mailhog/MailHog) is included in Docker Compose and catches all outgoing mail at `http://localhost:8025`.

For production, configure any SMTP provider in `.env`:

```
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_TLS=true
MAIL_FROM=noreply@yourdomain.com
```

---

## API

The JSON API is available under `/api/`. Authentication uses the same session cookie as the web UI.

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/links` | List all links |
| `GET` | `/api/links/:id` | Get a single link |
| `POST` | `/api/links` | Create a link (Admin/Editor) |
| `DELETE` | `/api/links/:id` | Delete a link (Admin) |

**Example:**

```bash
curl -s http://localhost:4567/api/links | jq
```

---

## Roles

| Role | Capabilities |
|------|-------------|
| Admin | Full access — manage links, users, and view audit log |
| Editor | Create links, view dashboard, edit own links |
| Reader | Browse links and follow redirects |

---

## Project structure

```
├── app.rb                 # Application entry point
├── config.ru              # Rack configuration
├── Gemfile                # Ruby dependencies
├── Makefile               # Dev task shortcuts
├── Dockerfile             # Multi-stage container build
├── docker-compose.yml     # Local dev stack
├── config/
│   └── rack_attack.rb     # Rate limiting rules
├── middleware/
│   └── security_headers.rb
├── models/
│   ├── user.rb
│   ├── link.rb
│   ├── audit_log.rb
│   ├── oauth_provider.rb
│   └── email_notification.rb
├── routes/
│   ├── auth.rb
│   ├── oauth.rb
│   ├── links.rb
│   ├── api.rb
│   ├── dashboard.rb
│   └── settings.rb
├── services/
│   └── email_service.rb
├── helpers/
│   ├── auth.rb
│   ├── audit_helper.rb
│   ├── view_helpers.rb
│   └── qr_helper.rb
├── views/                 # ERB templates
├── spec/                  # RSpec tests
└── db/
    └── seeds.rb
```

---

## Testing

```bash
bundle exec rspec
bundle exec rspec --format documentation   # verbose output
```

Tests run automatically on every push via GitHub Actions (Ruby 3.2 and 3.3).

---

## Contributing

Pull requests are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting.

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/your-feature`)
3. Commit your changes
4. Push and open a Pull Request

---

## License

The MIT License (MIT). Please see [LICENSE.md](LICENSE.md) for more information.
