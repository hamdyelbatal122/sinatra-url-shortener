# Deployment Guide

This guide covers deploying the Sinatra URL Shortener to various environments.

## Prerequisites

- Ruby 3.0 or higher
- Bundler
- SQLite3 (or PostgreSQL for production)
- Docker (optional, for containerized deployment)

## Local Development

### Setup

```bash
git clone https://github.com/hamdyelbatal122/Sinatra.git
cd Sinatra
bundle install
cp .env.example .env
```

### Configuration

Edit `.env` with your settings:

```bash
# Essential
SESSION_SECRET=your-random-secret-key
APP_URL=http://localhost:4567

# OAuth (optional)
GOOGLE_CLIENT_ID=your-google-id
GOOGLE_CLIENT_SECRET=your-google-secret
GITHUB_CLIENT_ID=your-github-id
GITHUB_CLIENT_SECRET=your-github-secret

# Email (optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

### Running

```bash
bundle exec rackup
```

Visit `http://localhost:4567`

## Docker Deployment

### Build Image

```bash
docker build -t sinatra-shortener:latest .
```

### Run Container

```bash
docker run -d \
  --name sinatra-app \
  -p 4567:4567 \
  -e SESSION_SECRET=your-secret \
  -e GOOGLE_CLIENT_ID=your-id \
  -e GOOGLE_CLIENT_SECRET=your-secret \
  -v sinatra-data:/app/db \
  sinatra-shortener:latest
```

### Docker Compose

```bash
docker-compose up -d
```

## Production Deployment

### Environment Variables

Set these in your production environment:

```bash
RACK_ENV=production
SESSION_SECRET=<generate-secure-random-key>
DATABASE_URL=sqlite:///app/db/production.sqlite3
APP_URL=https://your-domain.com
GOOGLE_CLIENT_ID=<production-google-id>
GOOGLE_CLIENT_SECRET=<production-google-secret>
GITHUB_CLIENT_ID=<production-github-id>
GITHUB_CLIENT_SECRET=<production-github-secret>
SMTP_HOST=<your-smtp-host>
SMTP_PORT=587
SMTP_USER=<your-email>
SMTP_PASSWORD=<your-password>
MAIL_FROM=noreply@your-domain.com
```

### Heroku Deployment

1. Create a Heroku app:
```bash
heroku create your-app-name
```

2. Set environment variables:
```bash
heroku config:set SESSION_SECRET=your-secret
heroku config:set GOOGLE_CLIENT_ID=your-id
# ... set other variables
```

3. Deploy:
```bash
git push heroku main
```

### AWS Deployment

#### Using Elastic Beanstalk

1. Install EB CLI:
```bash
pip install awsebcli
```

2. Initialize:
```bash
eb init -p ruby-3.2 sinatra-shortener
```

3. Create environment:
```bash
eb create production
```

4. Set environment variables:
```bash
eb setenv SESSION_SECRET=your-secret GOOGLE_CLIENT_ID=your-id
```

5. Deploy:
```bash
eb deploy
```

#### Using ECS

1. Push image to ECR:
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
docker tag sinatra-shortener:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/sinatra-shortener:latest
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/sinatra-shortener:latest
```

2. Create ECS task definition and service

### DigitalOcean App Platform

1. Connect your GitHub repository
2. Create new app from repository
3. Set environment variables in the dashboard
4. Deploy

### Nginx Reverse Proxy

```nginx
upstream sinatra {
  server 127.0.0.1:4567;
}

server {
  listen 80;
  server_name your-domain.com;
  
  location / {
    proxy_pass http://sinatra;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}
```

## Database Migrations

The application uses Sequel with automatic migrations. On first run, all tables are created automatically.

To seed initial data:

```bash
ruby db/seeds.rb
```

## Monitoring

### Health Check

```bash
curl http://localhost:4567/
```

### Logs

```bash
# Docker
docker logs sinatra-app

# Heroku
heroku logs --tail

# Local
tail -f log/sinatra.log
```

### Metrics

Monitor these endpoints:
- `/api/links` - API health
- `/dashboard` - Application health

## Backup & Recovery

### Database Backup

```bash
# SQLite
cp db/production.sqlite3 db/production.sqlite3.backup

# Automated backup (cron)
0 2 * * * cp /app/db/production.sqlite3 /backups/production.sqlite3.$(date +\%Y\%m\%d)
```

### Restore

```bash
cp db/production.sqlite3.backup db/production.sqlite3
```

## Security Checklist

- [ ] Set strong `SESSION_SECRET`
- [ ] Use HTTPS in production
- [ ] Configure OAuth credentials
- [ ] Set up email notifications
- [ ] Enable rate limiting
- [ ] Configure CORS appropriately
- [ ] Use environment variables for secrets
- [ ] Regular security updates
- [ ] Monitor audit logs
- [ ] Set up backups

## Troubleshooting

### Port Already in Use

```bash
lsof -i :4567
kill -9 <PID>
```

### Database Locked

```bash
rm db/production.sqlite3-wal
rm db/production.sqlite3-shm
```

### Email Not Sending

1. Check SMTP credentials
2. Verify firewall allows SMTP port
3. Check email logs: `EmailNotification.where(status: 'failed').all`

### OAuth Not Working

1. Verify callback URLs match exactly
2. Check client ID and secret
3. Ensure environment variables are set
4. Check browser console for errors

## Performance Optimization

### Caching

Add Redis caching for frequently accessed links:

```ruby
# In routes/links.rb
cache_key = "link:#{params[:name]}"
link = REDIS.get(cache_key)
unless link
  link = Link[name: params[:name]]
  REDIS.setex(cache_key, 3600, link.to_json)
end
```

### Database Indexing

Indexes are already configured on:
- `users.username`
- `users.email`
- `links.name`
- `links.category`
- `oauth_providers.provider, uid`

### Load Balancing

Use multiple instances behind a load balancer:

```bash
# Start multiple instances
puma -p 4567 -w 4 -t 5:5
```

## Support

For deployment issues, check:
- [Sinatra Documentation](http://sinatrarb.com/)
- [Sequel Documentation](https://sequel.jeremyevans.net/)
- [GitHub Issues](https://github.com/hamdyelbatal122/Sinatra/issues)
