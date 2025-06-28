# Getting Started - Developer Guide

## Prerequisites

Before setting up The Art Exchange locally, ensure you have the following installed:

### Required Software
- **Ruby**: 3.3.0 (see `.ruby-version`)
- **Rails**: 8.0+ 
- **PostgreSQL**: 14+
- **Node.js**: 18+ with npm/yarn
- **libvips**: For image processing

### Installation Commands

#### macOS (using Homebrew)
```bash
# Install Ruby (using rbenv recommended)
brew install rbenv
rbenv install 3.3.0
rbenv global 3.3.0

# Install PostgreSQL
brew install postgresql@14
brew services start postgresql@14

# Install Node.js
brew install node

# Install libvips for image processing
brew install vips
```

#### Ubuntu/Debian
```bash
# Install Ruby dependencies
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev libreadline-dev zlib1g-dev

# Install PostgreSQL
sudo apt-get install -y postgresql postgresql-contrib libpq-dev

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install libvips
sudo apt-get install -y libvips-dev
```

## Local Development Setup

### 1. Clone the Repository
```bash
git clone https://github.com/taylor01/the-art-exchange.git
cd the-art-exchange
```

### 2. Install Dependencies
```bash
# Install Ruby gems
bundle install

# Install JavaScript packages
npm install
# or
yarn install
```

### 3. Environment Configuration
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your local settings
# Required variables:
#   DATABASE_URL
#   ANTHROPIC_API_KEY (for AI features)
#   AWS_ACCESS_KEY_ID (for S3 storage)
#   AWS_SECRET_ACCESS_KEY
#   AWS_REGION
#   AWS_BUCKET
```

### 4. Database Setup
```bash
# Create and setup database
rails db:create
rails db:migrate
rails db:seed

# Optional: Load sample data
rails db:sample_data
```

### 5. Start Development Server
```bash
# Start all services (Rails, Webpack, etc.)
./bin/dev

# Or start Rails server only
rails server

# Application will be available at:
# http://localhost:3000
```

## Development Tools

### Code Quality Checks
Run the comprehensive check script before committing:
```bash
./bin/checks
```

This runs:
- **RSpec tests**: `bundle exec rspec`
- **RuboCop linting**: `bundle exec rubocop`
- **Brakeman security scan**: `bundle exec brakeman`
- **Bundle audit**: `bundle exec bundle-audit`

### Individual Commands
```bash
# Run tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run linting
bundle exec rubocop

# Auto-fix linting issues
bundle exec rubocop -A

# Security scan
bundle exec brakeman

# Check for vulnerabilities
bundle exec bundle-audit
```

## Development Workflow

### 1. Branch Creation
Always work on feature branches off the main branch:
```bash
# Pull latest changes
git pull origin main

# Create feature branch
git checkout -b feature/your-feature-name

# Or for fixes
git checkout -b fix/your-fix-name
```

### 2. Development Process
1. **Create GitHub Issue** - Document what you're working on
2. **Implement changes** - Write code with tests
3. **Run checks** - `./bin/checks` before committing
4. **Commit changes** - Clear, descriptive commit messages
5. **Push branch** - `git push origin feature/your-feature-name`
6. **Create Pull Request** - Reference the GitHub issue

### 3. Testing Requirements
- **All new code must have test coverage**
- **Models**: Unit tests with RSpec
- **Controllers**: Request specs
- **Features**: Integration tests where appropriate
- **Security**: No new Brakeman warnings

## Common Development Tasks

### Adding New Models
```bash
# Generate model with migration
rails generate model ModelName attribute:type

# Run migration
rails db:migrate

# Don't forget to add tests!
```

### Adding New Routes
```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :your_resource
end
```

### Working with Images
The app uses Active Storage with S3. For local development:
```ruby
# In models
has_many_attached :images

# In views
image_tag url_for(poster.images.first) if poster.images.attached?
```

### AI Integration Development
```ruby
# Example Claude API call
response = AnthropicService.analyze_poster_image(image_blob)
metadata = JSON.parse(response)
```

## Environment Variables Reference

### Required for Basic Functionality
```bash
DATABASE_URL=postgresql://username:password@localhost/the_art_exchange_development
RAILS_ENV=development
```

### Required for Full Features
```bash
# AI Integration
ANTHROPIC_API_KEY=your_claude_api_key

# AWS S3 Storage
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-west-2
AWS_BUCKET=your-bucket-name

# OAuth (optional for local development)
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
APPLE_CLIENT_ID=your_apple_client_id
APPLE_TEAM_ID=your_apple_team_id
APPLE_KEY_ID=your_apple_key_id
APPLE_PRIVATE_KEY=your_apple_private_key
```

## Troubleshooting

### Common Issues

#### libvips Installation Problems
```bash
# macOS: Update Homebrew and reinstall
brew update && brew reinstall vips

# Ubuntu: Install dev headers
sudo apt-get install -y libvips-dev
```

#### Database Connection Issues
```bash
# Check PostgreSQL is running
brew services list | grep postgresql

# Reset database if needed
rails db:drop db:create db:migrate db:seed
```

#### Bundle Install Failures
```bash
# Clean bundle cache
bundle clean --force
rm Gemfile.lock
bundle install
```

#### JavaScript/Node Issues
```bash
# Clear npm cache
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

## Next Steps

Once you have the application running locally:

1. **Explore the codebase** - Check out the [Application Architecture](Application-Architecture) page
2. **Review development rules** - See [Development Workflow](Development-Workflow) 
3. **Run the test suite** - `bundle exec rspec` should show 224+ passing tests
4. **Check available routes** - `rails routes` to see all endpoints
5. **Review open issues** - Find something to contribute to on GitHub

## Additional Resources

- **[Development Workflow](Development-Workflow)** - Complete development process
- **[Testing Guide](Testing-Guide)** - Testing philosophy and practices
- **[Troubleshooting](Troubleshooting)** - Common problems and solutions
- **[Application Architecture](Application-Architecture)** - Technical deep dive

For questions or issues, check the [Troubleshooting](Troubleshooting) page or create a GitHub issue.