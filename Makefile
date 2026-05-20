.DEFAULT_GOAL := help

# ── Variables ──────────────────────────────────────────────────────────────────
RUBY_ENV ?= development
PORT     ?= 4567

.PHONY: help install dev test lint seed docker-up docker-down docker-build clean

## help: Show this help message
help:
	@echo ""
	@echo "  Go URL Shortener — available commands:"
	@echo ""
	@grep -E '^## [a-zA-Z_-]+:' Makefile | sed 's/## /  make /' | column -t -s ':'
	@echo ""

## install: Install Ruby dependencies
install:
	bundle install

## dev: Start the development server (auto-reload)
dev:
	bundle exec rerun --background -- rackup -p $(PORT) -o 0.0.0.0

## server: Start the server without auto-reload
server:
	RACK_ENV=$(RUBY_ENV) bundle exec rackup -p $(PORT) -o 0.0.0.0

## test: Run the full test suite
test:
	RACK_ENV=test bundle exec rspec --format documentation

## test-ci: Run tests in CI mode (progress format, JUnit output)
test-ci:
	RACK_ENV=test bundle exec rspec --format progress

## lint: Check for known gem vulnerabilities
lint:
	bundle exec bundle-audit check --update

## seed: Seed the database with initial data
seed:
	RACK_ENV=$(RUBY_ENV) ruby db/seeds.rb

## docker-build: Build the Docker image
docker-build:
	docker build -t sinatra-shortener .

## docker-up: Start the app and MailHog with Docker Compose
docker-up:
	docker compose up

## docker-up-d: Start services in the background
docker-up-d:
	docker compose up -d

## docker-down: Stop and remove containers
docker-down:
	docker compose down

## docker-logs: Follow container logs
docker-logs:
	docker compose logs -f app

## clean: Remove SQLite database files and temp artifacts
clean:
	rm -f db/*.sqlite3 db/*.sqlite3-*
	rm -rf tmp/
	@echo "Cleaned up."
