FROM ruby:3.3-slim

WORKDIR /app

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  libsqlite3-dev \
  git \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY . .

ENV RACK_ENV=production
ENV DATABASE_URL=sqlite:///app/db/production.sqlite3
ENV SESSION_SECRET=change-me-in-production
ENV PUMA_WORKERS=4
ENV PUMA_THREADS=5

EXPOSE 4567

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:4567/ || exit 1

CMD ["bundle", "exec", "puma", "-p", "4567", "-b", "0.0.0.0", "-w", "4", "-t", "5:5"]
