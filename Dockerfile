# ── Build stage ──────────────────────────────────────────────────────────────
FROM ruby:3.3-slim AS builder

WORKDIR /build

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libsqlite3-dev \
    curl \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile ./
RUN bundle config set --local deployment false && \
    bundle config set --local without 'development' && \
    bundle install --jobs 4 --retry 3

# ── Runtime stage ─────────────────────────────────────────────────────────────
FROM ruby:3.3-slim AS runtime

WORKDIR /app

# Install only runtime libs (no build tools)
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    libsqlite3-0 \
    curl \
  && rm -rf /var/lib/apt/lists/*

# Run as non-root user
RUN groupadd -r app && useradd -r -g app -d /app -s /sbin/nologin app
RUN chown app:app /app

# Copy installed gems from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Copy application source
COPY --chown=app:app . .

# Ensure the database directory is writable
RUN mkdir -p db && chown app:app db

USER app

ENV RACK_ENV=production
ENV DATABASE_URL=sqlite:///app/db/production.sqlite3
ENV PORT=4567

EXPOSE 4567

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -fsS http://localhost:4567/ || exit 1

CMD ["bundle", "exec", "puma", "-p", "4567", "-b", "0.0.0.0", "--preload"]
