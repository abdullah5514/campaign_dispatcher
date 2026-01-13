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


### Key Architectural Decisions

#### 1. **Real-time Strategy**
- **Turbo Streams over Stimulus:** Leveraged Turbo Streams for all real-time updates, avoiding unnecessary JavaScript complexity
- **Dual Broadcasting:** Updates both the campaign show page AND index page simultaneously
- **Query Cache Management:** Explicitly clear query cache before broadcasts to ensure fresh data

#### 2. **Background Job Design**
- **Progressive Updates:** Broadcast after each recipient (not just at the end) for true real-time feedback
- **Error Resilience:** Individual recipient failures don't stop the entire campaign
- **Status Tracking:** Three-state campaign lifecycle (pending → processing → completed)

#### 3. **Database Schema**
- **Normalized Design:** Campaigns and Recipients in separate tables with proper foreign keys
- **Enum Efficiency:** Using Rails enums (stored as integers) for status fields
- **No Counter Caches:** Calculated counts on-the-fly

#### 4. **Testing Strategy**
- **Comprehensive Coverage:** 49 specs covering system, request, model, and job layers
- **Job Testing:** Stubbed `sleep` and `rand` for fast, deterministic tests
- **System Tests:** Headless Chrome for full-stack integration testing

### Data Flow

```
User triggers dispatch → DispatchCampaignJob enqueued → Sidekiq processes
↓
Campaign status: processing ← Turbo Stream broadcast ← Each recipient processed
↓
Recipients: queued → sent/failed ← Random delays + failure simulation (10%)
↓
Campaign status: completed ← Final broadcast ← All recipients processed
```

## Future Improvements

Given more time, I would add:

### High Priority
1. **Real Email Integration**
- SendGrid/Mailgun/AWS SES integration
- Email template system with variable substitution
- Bounce and complaint handling

2. **Performance Optimizations**
- Counter cache columns for `sent_count`, `failed_count`
- Background job batching (process 50 recipients at once)
- Database indexes on foreign keys and status columns
- Fragment caching for campaign cards

3. **Enhanced Error Handling**
- Retry logic with exponential backoff
- Dead letter queue for permanently failed sends
- Detailed error categorization (bounced, invalid, rate-limited)
- Admin dashboard for monitoring failed campaigns

### Medium Priority
4. **User Authentication**
- Devise integration
- Multi-tenant support (campaigns scoped to users/organizations)
- Role-based access control

5. **Campaign Scheduling**
- Schedule campaigns for future dispatch
- Recurring campaigns (weekly/monthly feedback requests)
- Time zone handling

6. **Analytics & Reporting**
- Campaign performance metrics dashboard
- Export to CSV/PDF
- Response rate tracking (if integrated with actual email service)

7. **UI Enhancements**
- Campaign templates library
- Bulk recipient import (CSV upload)
- Drag-and-drop recipient management
- Campaign duplication
