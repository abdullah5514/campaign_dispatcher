# Campaign Dispatcher

A real-time campaign management system built with Ruby on Rails.

## Features

- Create and manage email campaigns
- Real-time progress tracking with WebSockets
- Asynchronous email dispatch using Sidekiq
- Live status updates for recipients
- Modern, responsive UI with Tailwind CSS

## Tech Stack

- **Ruby on Rails** 7.2
- **PostgreSQL** - Database
- **Redis** - Action Cable & Sidekiq backend
- **Sidekiq** - Background job processing
- **Turbo/Stimulus** - Real-time updates
- **Tailwind CSS** - Styling

## Prerequisites

- Ruby 3.2.2
- PostgreSQL
- Redis

## Setup

```bash
# Install dependencies
bundle install

# Setup database
rails db:create db:migrate

# Start services
./bin/dev
```

## Development

The application runs three processes:
- Rails server on port 3000
- Sidekiq for background jobs
- Tailwind CSS watcher

All processes can be started with `./bin/dev`.

## Architecture

### Core Components

- **Campaigns** - Manage email campaigns with status tracking
- **Recipients** - Track individual email statuses with error handling
- **Real-time Updates** - Turbo Streams via Action Cable for zero-refresh UX
- **Background Processing** - Sidekiq handles asynchronous email dispatch

## Testing

```bash
# Run all specs
bundle exec rspec

# Run specific test suites
bundle exec rspec spec/models
bundle exec rspec spec/jobs
bundle exec rspec spec/requests
bundle exec rspec spec/system
```

All 49 specs pass with comprehensive coverage of:
- Model validations and associations
- Background job processing
- Request/response cycles
- Real-time UI updates via system tests

