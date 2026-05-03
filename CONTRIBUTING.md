# Contributing to Sinatra URL Shortener

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

Please be respectful and constructive in all interactions. We're committed to providing a welcoming and inclusive environment for all contributors.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/Sinatra.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Set up your environment:
   ```bash
   bundle install
   cp .env.example .env
   # Edit .env with your configuration
   ```

## Development Workflow

### Running the Application

```bash
bundle exec rackup
```

The application will be available at `http://localhost:4567`.

### Running Tests

```bash
bundle exec rspec
```

### Database Migrations

Migrations run automatically on application startup. To seed test data:

```bash
ruby db/seeds.rb
```

## Making Changes

1. Create a feature branch from `master`
2. Make your changes with clear, descriptive commits
3. Add tests for new functionality
4. Ensure all tests pass: `bundle exec rspec`
5. Update documentation as needed

## Commit Messages

Use clear, descriptive commit messages:

- `feat: add OAuth login support`
- `fix: resolve email notification bug`
- `docs: update API documentation`
- `test: add integration tests for links`
- `refactor: simplify authentication logic`

## Pull Request Process

1. Update the README.md with any new features or changes
2. Ensure all tests pass
3. Provide a clear description of your changes
4. Reference any related issues
5. Request review from maintainers

## Code Style

- Follow Ruby conventions and best practices
- Use meaningful variable and method names
- Keep methods focused and single-purpose
- Add comments only for non-obvious logic
- Maintain consistent indentation (2 spaces)

## Testing

- Write tests for all new features
- Ensure existing tests continue to pass
- Aim for good test coverage
- Use descriptive test names

## Documentation

- Update README.md for user-facing changes
- Add inline comments for complex logic
- Document API changes in the OpenAPI spec
- Update .env.example for new environment variables

## Reporting Issues

When reporting bugs, please include:

- Clear description of the issue
- Steps to reproduce
- Expected behavior
- Actual behavior
- Environment details (Ruby version, OS, etc.)

## Questions?

Feel free to open an issue or discussion for questions about contributing.

Thank you for helping make this project better!
