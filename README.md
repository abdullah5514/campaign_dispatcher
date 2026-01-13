# Campaign Dispatcher

A proof-of-concept Rails 7 application that automates customer feedback collection by dispatching campaigns to recipients with real-time progress tracking.

## 🎯 Overview

Campaign Dispatcher demonstrates a modern Rails stack with real-time updates, allowing users to create campaigns, add recipients, and watch as messages are dispatched in real-time—all without page refreshes.

### Key Features

- **Campaign Management**: Create, edit, and delete campaigns with multiple recipients
- **Real-time Updates**: Watch campaign progress and recipient status updates live using Hotwire (Turbo Streams)
- **Background Processing**: Asynchronous campaign dispatch using Sidekiq
- **Professional UI**: Clean, responsive interface built with Tailwind CSS
- **Comprehensive Testing**: Full test coverage with RSpec (unit, request, and system specs)

## 🛠 Tech Stack

- **Ruby** 3.2.2
- **Rails** 7.1.2
- **PostgreSQL** (Database)
- **Redis** (Action Cable & Sidekiq)
- **Sidekiq** 7.2 (Background jobs)
- **Hotwire** (Turbo & Stimulus)
- **Tailwind CSS** (Styling)
- **RSpec** (Testing framework)

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- Ruby 3.2.2 (use rbenv or rvm)
- PostgreSQL (>= 12)
- Redis (>= 5.0)
- Node.js (>= 18) and Yarn
- Bundler gem

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd campaign_dispatcher
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Install JavaScript dependencies (if using Yarn)
yarn install
```

### 3. Configure Database

The application expects PostgreSQL to be running with default credentials. You can customize the database configuration in `config/database.yml`.

Default credentials:
- **Username**: `postgres`
- **Password**: `postgres`
- **Host**: `localhost`

To use different credentials, set environment variables:

```bash
export POSTGRES_USER=your_username
export POSTGRES_PASSWORD=your_password
export POSTGRES_HOST=localhost
```

### 4. Setup Database

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Seed sample data (optional)
rails db:seed
```

### 5. Start Redis

Redis is required for Action Cable (real-time updates) and Sidekiq (background jobs).

```bash
# macOS (using Homebrew)
brew services start redis

# Linux
sudo systemctl start redis

# Or run Redis in foreground
redis-server
```

### 6. Start Sidekiq

In a separate terminal window, start Sidekiq to process background jobs:

```bash
bundle exec sidekiq
```

### 7. Start the Rails Server

In another terminal window:

```bash
bin/rails server
# or
rails s
```

The application will be available at `http://localhost:3000`

### 8. Access the Application

Open your browser and navigate to:
```
http://localhost:3000
```

## 🧪 Running Tests

The application includes comprehensive test coverage using RSpec.

### Run All Tests

```bash
bundle exec rspec
```

### Run Specific Test Types

```bash
# Model specs
bundle exec rspec spec/models

# Request specs
bundle exec rspec spec/requests

# Job specs
bundle exec rspec spec/jobs

# System specs (requires Chrome/Chromium)
bundle exec rspec spec/system
```

### Test Coverage

- **Model Specs**: Test associations, validations, and business logic
- **Request Specs**: Test controller actions and HTTP responses
- **Job Specs**: Test DispatchCampaignJob background processing
- **System Specs**: Test full user flows with JavaScript interactions

## 📖 Usage

### Creating a Campaign

1. Click "New Campaign" in the navigation
2. Enter a campaign title (e.g., "Q1 Customer Feedback Request")
3. Add recipients with their names and email addresses
4. Click "Add Recipient" to add more recipients
5. Click "Create Campaign"

### Dispatching a Campaign

1. Navigate to a campaign's detail page
2. Click "Dispatch Campaign"
3. Watch in real-time as:
   - Recipients are processed one by one
   - Status changes from "Queued" to "Sent" or "Failed"
   - Progress bar updates automatically
   - Overall statistics update live

### Real-time Features

The application uses **Turbo Streams** to provide real-time updates:

- **Individual Recipient Updates**: Each recipient's status updates instantly as it's processed
- **Campaign Progress**: Progress bar and statistics update in real-time
- **Campaign List**: Campaign cards on the index page reflect current status

No page refresh required! 🎉

## 🏗 Architecture & Design Decisions

### 1. Database Schema

**Normalized & Efficient Design:**

- `campaigns` table with indexed status field
- `recipients` table with foreign key to campaigns
- Composite index on `(campaign_id, status)` for efficient filtering
- Enum integers for status fields (better performance than strings)

### 2. Background Processing

**Sidekiq for Async Jobs:**

- `DispatchCampaignJob` processes recipients sequentially
- Simulated delays (1-3 seconds) mimic real API calls
- 10% simulated failure rate for realistic error handling
- Each recipient update broadcasts via Turbo Streams

### 3. Real-time Updates

**Hotwire (Turbo Streams) Strategy:**

- Three separate Turbo Stream channels:
  - `campaign_{id}_recipients`: Updates individual recipient rows
  - `campaign_{id}_progress`: Updates campaign progress section
  - `campaigns`: Updates campaign cards on index page
- Minimal JavaScript required (Stimulus only for nested forms)
- Server-side rendering maintained

### 4. UI/UX Design

**Tailwind CSS Implementation:**

- Professional SaaS-like interface
- Responsive design (mobile-first)
- Color-coded status badges (yellow=pending, blue=processing, green=complete/sent, red=failed)
- Smooth transitions and hover effects
- Icon-based visual feedback

### 5. Testing Strategy

**Comprehensive RSpec Coverage:**

- **Unit Tests**: Model validations, associations, business logic
- **Request Tests**: Full controller action coverage
- **Job Tests**: Background processing with mocked delays
- **System Tests**: End-to-end user flows with Capybara

### 6. The Rails Way

**Idiomatic Rails Patterns:**

- RESTful routing conventions
- Nested attributes for associated records
- ActiveJob for background processing
- Concerns for shared behavior
- Strong parameters for security
- Database-backed enums

## 🚧 Trade-offs & Future Improvements

### What Would I Do With 40 Hours Instead of 6?

#### 1. **Enhanced Error Handling**
- Retry logic for failed dispatches with exponential backoff
- Dead letter queue for permanently failed jobs
- Detailed error logging and monitoring (Sentry, Honeybadger)

#### 2. **Actual Integration**
- Real email provider integration (SendGrid, Mailgun)
- SMS provider integration (Twilio)
- Webhook support for delivery confirmations

#### 3. **Advanced Features**
- Campaign scheduling (dispatch at specific time)
- Recipient segmentation and filtering
- CSV import/export for bulk recipient management
- Campaign templates
- A/B testing support
- Rate limiting for API compliance

#### 4. **Performance Optimizations**
- Database connection pooling tuning
- Fragment caching for campaign cards
- Redis caching for expensive calculations
- Batch processing for large campaigns
- Pagination for large recipient lists

#### 5. **User Management**
- Authentication (Devise)
- Authorization (Pundit or CanCanCan)
- Multi-tenancy support
- Team collaboration features
- Audit logs

#### 6. **Monitoring & Observability**
- APM integration (New Relic, Scout)
- Sidekiq monitoring dashboard
- Error tracking
- Performance metrics
- Custom dashboards

#### 7. **DevOps**
- Dockerized development environment
- CI/CD pipeline (GitHub Actions, CircleCI)
- Staging environment
- Production deployment guide (Heroku, AWS, Render)
- Infrastructure as Code (Terraform)

#### 8. **Additional Testing**
- Integration tests with real Redis/Sidekiq
- Load testing for concurrent campaigns
- Performance benchmarks
- Security testing (Brakeman)
- Accessibility testing

#### 9. **API Layer**
- RESTful API for campaign management
- API authentication (JWT)
- Rate limiting
- API documentation (Swagger/OpenAPI)
- Webhooks for external integrations

#### 10. **Analytics & Reporting**
- Campaign success metrics
- Delivery rates and trends
- Recipient engagement tracking
- Export reports (PDF, CSV)
- Visual dashboards with charts

## 🎨 Screenshots

(In a production README, add screenshots here showing:)
- Campaign index page
- Campaign creation form
- Real-time dispatch in action
- Campaign detail view with recipients

## 📝 Development Notes

### Project Structure

```
app/
├── assets/          # Stylesheets and static assets
├── channels/        # Action Cable channels
├── controllers/     # Application controllers
├── helpers/         # View helpers
├── javascript/      # Stimulus controllers & JS
├── jobs/            # Background jobs (Sidekiq)
├── models/          # ActiveRecord models
└── views/           # ERB templates with Turbo

config/
├── environments/    # Environment-specific configs
├── initializers/    # App initialization code
├── database.yml     # Database configuration
└── routes.rb        # Route definitions

db/
├── migrate/         # Database migrations
└── seeds.rb         # Seed data

spec/
├── factories/       # FactoryBot factories
├── models/          # Model specs
├── requests/        # Request specs
├── jobs/            # Job specs
└── system/          # System/feature specs
```

### Key Files

- `app/models/campaign.rb` - Campaign model with business logic
- `app/models/recipient.rb` - Recipient model
- `app/jobs/dispatch_campaign_job.rb` - Background job for dispatching
- `app/controllers/campaigns_controller.rb` - Main controller
- `app/javascript/controllers/nested_form_controller.js` - Stimulus controller for dynamic forms
- `config/initializers/sidekiq.rb` - Sidekiq configuration

## 🤝 Contributing

This is a technical assessment project, but suggestions and feedback are welcome!

## 📄 License

This project is created as a technical assessment and is available for evaluation purposes.

## 👨‍💻 Contact

For questions or feedback about this implementation, please reach out!

---

**Built with ❤️ using Ruby on Rails**

