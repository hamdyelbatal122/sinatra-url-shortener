# Contributing

Thanks for taking the time to contribute. Here's everything you need to get started.

## Setting up

```bash
git clone https://github.com/hamdyelbatal122/Sinatra.git
cd Sinatra
bundle install
cp .env.example .env
ruby db/seeds.rb
bundle exec rackup -p 4567
```

## Workflow

1. Fork the repo and create a branch from `master`

   ```bash
   git checkout -b feat/my-feature
   ```

2. Make your changes, keeping commits focused and atomic

3. Add or update tests for anything behaviour-related

4. Run the suite before pushing

   ```bash
   bundle exec rspec
   ```

5. Open a Pull Request — the template will guide you through the description

## Commit style

Use the conventional commit format:

```
feat: add QR code download button
fix: correct hit counter race condition
docs: update OAuth setup steps
test: add spec for link URL validation
refactor: simplify rate limit store
```

## Code style

- 2-space indentation, no trailing whitespace
- Keep methods short and single-purpose
- Avoid comments that just restate what the code does
- Prefer explicit over clever

## Tests

- Write RSpec examples for all new behaviour
- Keep unit and integration specs separate (`spec/` mirrors `app/` layout)
- Aim for tests that describe intent, not implementation

## Reporting a bug

Use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md). Include:
- Exact steps to reproduce
- What you expected vs what happened
- Your Ruby version and OS

## Questions

Open a [GitHub Discussion](https://github.com/hamdyelbatal122/Sinatra/discussions) rather than an issue for questions.
