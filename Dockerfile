FROM ruby:3.3-slim

WORKDIR /app

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  libsqlite3-dev \
  curl \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile ./
RUN bundle install --jobs 4 --retry 3

COPY . .

ENV RACK_ENV=production
ENV DATABASE_URL=sqlite:///app/db/production.sqlite3
ENV SESSION_SECRET=change-me-in-production

EXPOSE 4567

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:4567/ || exit 1

CMD ["bundle", "exec", "puma", "-p", "4567", "-b", "0.0.0.0"]
