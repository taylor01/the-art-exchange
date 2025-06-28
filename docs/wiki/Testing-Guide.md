# Testing Guide

## Overview

The Art Exchange follows a comprehensive testing strategy designed to ensure code quality, security, and reliability. With **345+ passing tests** and **zero tolerance for failing tests**, our testing approach covers unit tests, integration tests, security scanning, and code quality checks.

## Testing Philosophy

### Quality Requirements
- **All tests must pass** - Zero failures allowed in any pull request
- **Comprehensive coverage** - All new code requires test coverage
- **Security first** - Security scanning integrated into test pipeline
- **Fast feedback** - Tests should run quickly for developer productivity

### Testing Pyramid
```
                    /\
                   /  \
                  /    \
                 /  E2E  \    (Few, Critical User Journeys)
                /________\
               /          \
              /Integration \   (API, Feature Tests)
             /______________\
            /                \
           /       Unit       \  (Models, Services, Helpers)
          /____________________\
```

## Test Suite Overview

### Current Test Statistics
```bash
# Run complete test suite
bundle exec rspec

# Current results
345 examples, 0 failures, 0 pending

# Test breakdown:
# Model tests:      188 examples (unit tests)
# Request tests:     89 examples (API tests)  
# System tests:      37 examples (integration)
# Service tests:     31 examples (business logic)
```

### Test Coverage by Component
- **Models**: 100% method coverage
- **Controllers**: All actions tested
- **Services**: Complete business logic coverage
- **System Integration**: Critical user flows
- **Security**: Comprehensive security scanning

## Running Tests

### Complete Test Suite
```bash
# Run all tests
bundle exec rspec

# Run with coverage report
bundle exec rspec --coverage

# Run specific test types
bundle exec rspec spec/models/        # Unit tests
bundle exec rspec spec/requests/      # API tests
bundle exec rspec spec/system/        # Integration tests
```

### Individual Test Files
```bash
# Run specific model tests
bundle exec rspec spec/models/user_spec.rb
bundle exec rspec spec/models/poster_spec.rb

# Run specific feature tests
bundle exec rspec spec/system/poster_management_spec.rb
bundle exec rspec spec/system/user_authentication_spec.rb

# Run with specific format
bundle exec rspec --format documentation spec/models/
```

### Test Debugging
```bash
# Run tests with debugging output
bundle exec rspec --format documentation --backtrace

# Run single test with focus
bundle exec rspec spec/models/user_spec.rb:25

# Run failed tests only
bundle exec rspec --only-failures
```

## Testing Framework & Tools

### Core Testing Stack
```ruby
# Gemfile (test group)
group :test do
  gem 'rspec-rails'           # Primary testing framework
  gem 'factory_bot_rails'     # Test data generation
  gem 'capybara'             # Integration testing
  gem 'selenium-webdriver'   # Browser automation
  gem 'database_cleaner'     # Database cleanup
  gem 'simplecov'            # Coverage reporting
  gem 'webmock'              # HTTP request stubbing
end
```

### Test Configuration
```ruby
# spec/rails_helper.rb
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods
  config.include Capybara::DSL, type: :system
  
  # Database cleanup strategy
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
end
```

## Unit Testing (Models)

### Model Test Structure
```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
    
    it 'validates email format' do
      user = build(:user, email: 'invalid-email')
      expect(user).not_to be_valid
    end
  end
  
  describe 'associations' do
    it 'has many user_posters' do
      association = User.reflect_on_association(:user_posters)
      expect(association.macro).to eq :has_many
    end
  end
  
  describe 'methods' do
    describe '#full_name' do
      it 'returns first and last name' do
        user = build(:user, first_name: 'John', last_name: 'Smith')
        expect(user.full_name).to eq 'John Smith'
      end
    end
  end
end
```

### Factory Bot Usage
```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    terms_accepted_at { 1.day.ago }
    terms_version { 'v1.0' }
    
    trait :admin do
      admin { true }
    end
    
    trait :with_collection do
      after(:create) do |user|
        create_list(:user_poster, 3, user: user, status: 'owned')
      end
    end
  end
end

# Usage in tests
user = create(:user)                    # Create user
admin = create(:user, :admin)           # Create admin user
collector = create(:user, :with_collection) # User with collection
```

### Model Testing Patterns
```ruby
# Testing associations
it 'belongs to venue' do
  poster = create(:poster)
  expect(poster.venue).to be_a(Venue)
end

# Testing scopes
describe '.with_images' do
  it 'returns posters that have images attached' do
    poster_with_image = create(:poster, :with_image)
    poster_without_image = create(:poster)
    
    expect(Poster.with_images).to include(poster_with_image)
    expect(Poster.with_images).not_to include(poster_without_image)
  end
end

# Testing validations with edge cases
it 'validates year is reasonable' do
  poster = build(:poster, year: 1800)
  expect(poster).not_to be_valid
  
  poster.year = Date.current.year + 2
  expect(poster).not_to be_valid
end
```

## Request Testing (Controllers)

### Controller Test Structure
```ruby
# spec/requests/posters_spec.rb
RSpec.describe 'Posters', type: :request do
  describe 'GET /posters' do
    it 'returns successful response' do
      create_list(:poster, 3)
      
      get '/posters'
      
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Browse Artwork')
    end
    
    it 'filters by search query' do
      matching_poster = create(:poster, title: 'Red Rocks Concert')
      other_poster = create(:poster, title: 'Blue Note Jazz')
      
      get '/posters', params: { search: 'red rocks' }
      
      expect(response.body).to include(matching_poster.title)
      expect(response.body).not_to include(other_poster.title)
    end
  end
  
  describe 'GET /posters/:id' do
    it 'shows poster details' do
      poster = create(:poster, :with_image)
      
      get "/posters/#{poster.id}"
      
      expect(response).to have_http_status(:success)
      expect(response.body).to include(poster.title)
    end
    
    it 'handles non-existent poster' do
      get '/posters/9999'
      
      expect(response).to have_http_status(:not_found)
    end
  end
end
```

### Authentication Testing
```ruby
# spec/requests/user_posters_spec.rb
RSpec.describe 'UserPosters', type: :request do
  let(:user) { create(:user) }
  
  describe 'GET /user_posters' do
    context 'when authenticated' do
      before { sign_in user }
      
      it 'shows user collection' do
        create(:user_poster, user: user, status: 'owned')
        
        get '/user_posters'
        
        expect(response).to have_http_status(:success)
        expect(response.body).to include('My Collection')
      end
    end
    
    context 'when not authenticated' do
      it 'redirects to login' do
        get '/user_posters'
        
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
```

## System Testing (Integration)

### System Test Configuration
```ruby
# spec/system/poster_management_spec.rb
RSpec.describe 'Poster Management', type: :system do
  let(:admin) { create(:user, :admin) }
  
  before do
    driven_by(:selenium, using: :headless_chrome, screen_size: [1400, 1400])
    login_as(admin, scope: :user)
  end
  
  describe 'creating a poster' do
    it 'allows admin to create poster with image' do
      visit '/admin/posters/new'
      
      fill_in 'Title', with: 'Test Poster'
      fill_in 'Description', with: 'A test poster description'
      select 'Red Rocks Amphitheatre', from: 'Venue'
      attach_file 'Images', Rails.root.join('spec', 'fixtures', 'test_poster.jpg')
      
      click_button 'Create Poster'
      
      expect(page).to have_content('Poster was successfully created')
      expect(page).to have_content('Test Poster')
      
      # Verify image was attached
      poster = Poster.find_by(title: 'Test Poster')
      expect(poster.images).to be_attached
    end
  end
  
  describe 'browsing posters' do
    it 'shows search functionality' do
      create(:poster, title: 'Searchable Poster')
      
      visit '/posters'
      
      fill_in 'search', with: 'Searchable'
      click_button 'Search'
      
      expect(page).to have_content('Searchable Poster')
    end
  end
end
```

### User Authentication System Tests
```ruby
# spec/system/user_authentication_spec.rb
RSpec.describe 'User Authentication', type: :system do
  describe 'OTP login process' do
    let(:user) { create(:user) }
    
    it 'completes OTP authentication flow' do
      visit '/users/sign_in'
      
      fill_in 'Email', with: user.email
      click_button 'Send Code'
      
      expect(page).to have_content('Check your email for a login code')
      
      # Simulate entering OTP code
      otp_code = user.generate_otp_code!
      fill_in 'Code', with: otp_code
      click_button 'Sign In'
      
      expect(page).to have_content('Successfully signed in')
      expect(page).to have_link('Sign Out')
    end
  end
  
  describe 'OAuth authentication' do
    it 'handles Google OAuth signup' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          email: 'test@gmail.com',
          first_name: 'Test',
          last_name: 'User'
        }
      })
      
      visit '/users/sign_in'
      click_link 'Sign in with Google'
      
      expect(page).to have_content('Successfully signed in')
      expect(User.find_by(email: 'test@gmail.com')).to be_present
    end
  end
end
```

## Security Testing

### Brakeman Security Scanning
```bash
# Run security scan
bundle exec brakeman

# Expected output:
# No warnings found
# Security Warnings: 0
# Confidence Level: High

# Generate detailed report
bundle exec brakeman -o brakeman_report.html
```

### Bundle Audit (Dependency Security)
```bash
# Check for vulnerabilities in dependencies
bundle exec bundle-audit

# Update vulnerability database
bundle exec bundle-audit update

# Expected output:
# No vulnerabilities found.
```

### Custom Security Tests
```ruby
# spec/security/authentication_security_spec.rb
RSpec.describe 'Authentication Security', type: :request do
  describe 'rate limiting' do
    it 'limits OTP requests per email' do
      email = 'test@example.com'
      
      # Make multiple requests rapidly
      6.times do
        post '/users/send_otp', params: { email: email }
      end
      
      expect(response).to have_http_status(:too_many_requests)
    end
  end
  
  describe 'CSRF protection' do
    it 'requires CSRF token for state-changing requests' do
      post '/user_posters', params: { user_poster: { poster_id: 1 } }
      
      expect(response).to have_http_status(:forbidden)
    end
  end
  
  describe 'SQL injection protection' do
    it 'safely handles malicious search input' do
      malicious_input = "'; DROP TABLE users; --"
      
      get '/posters', params: { search: malicious_input }
      
      expect(response).to have_http_status(:success)
      expect(User.count).to be > 0  # Users table still exists
    end
  end
end
```

## Performance Testing

### Load Testing Setup
```ruby
# spec/performance/poster_search_spec.rb
RSpec.describe 'Poster Search Performance', type: :request do
  before do
    create_list(:poster, 1000)  # Create realistic data set
  end
  
  it 'responds quickly to search queries' do
    start_time = Time.current
    
    get '/posters', params: { search: 'concert' }
    
    response_time = Time.current - start_time
    expect(response_time).to be < 1.0  # Less than 1 second
    expect(response).to have_http_status(:success)
  end
  
  it 'handles pagination efficiently' do
    start_time = Time.current
    
    get '/posters', params: { page: 10 }
    
    response_time = Time.current - start_time
    expect(response_time).to be < 0.5  # Less than 500ms
  end
end
```

## Quality Assurance Script

### Pre-Commit Checks
```bash
#!/bin/bash
# bin/checks - Comprehensive quality check script

echo "🧪 Running comprehensive quality checks..."

echo "📊 Running RSpec tests..."
bundle exec rspec
if [ $? -ne 0 ]; then
  echo "❌ Tests failed!"
  exit 1
fi

echo "🎨 Running RuboCop linting..."
bundle exec rubocop
if [ $? -ne 0 ]; then
  echo "❌ Linting failed!"
  exit 1
fi

echo "🔒 Running Brakeman security scan..."
bundle exec brakeman --quiet
if [ $? -ne 0 ]; then
  echo "❌ Security scan failed!"
  exit 1
fi

echo "🔍 Running Bundle Audit..."
bundle exec bundle-audit
if [ $? -ne 0 ]; then
  echo "❌ Dependency security check failed!"
  exit 1
fi

echo "✅ All checks passed! Ready for commit."
```

### Usage in Development Workflow
```bash
# Before creating any pull request
./bin/checks

# Quick test run during development
bundle exec rspec spec/models/user_spec.rb

# Run system tests for UI changes
bundle exec rspec spec/system/
```

## Test Data Management

### Factory Patterns
```ruby
# Complex factory relationships
factory :poster do
  title { Faker::Music.album }
  description { Faker::Lorem.paragraph }
  year { rand(1990..Date.current.year) }
  
  association :venue
  association :band
  
  after(:build) do |poster|
    poster.artists << build(:artist)
  end
  
  trait :with_image do
    after(:create) do |poster|
      poster.images.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'test_poster.jpg')),
        filename: 'test_poster.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
  
  trait :with_metadata do
    visual_metadata do
      {
        visual: {
          color_palette: ['black', 'white', 'red'],
          art_style: 'modern'
        },
        thematic: {
          primary_themes: ['music', 'concert'],
          mood: ['energetic']
        }
      }
    end
  end
end
```

### Test Database Cleanup
```ruby
# spec/support/database_cleaner.rb
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  
  config.after(:each, type: :system) do
    # Clean up uploaded files after system tests
    FileUtils.rm_rf(Rails.root.join('tmp', 'storage'))
  end
end
```

## Continuous Integration

### GitHub Actions Configuration
```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup Ruby
      uses: ruby/setup-ruby@v1
      with:
        bundler-cache: true
    
    - name: Setup Database
      run: |
        bundle exec rails db:create
        bundle exec rails db:migrate
      env:
        DATABASE_URL: postgres://postgres:postgres@localhost:5432/test
    
    - name: Run Tests
      run: bundle exec rspec
    
    - name: Run Security Scan
      run: bundle exec brakeman --quiet
    
    - name: Run Linting
      run: bundle exec rubocop
```

## Testing Best Practices

### Test Organization
- **Group related tests** - Use `describe` and `context` effectively
- **Clear test descriptions** - Test names should explain what they verify
- **DRY principle** - Use shared examples and helpers for common patterns
- **Fast tests** - Keep tests focused and quick to run

### Test Maintenance
- **Regular updates** - Keep tests current with code changes
- **Remove obsolete tests** - Delete tests for removed features
- **Refactor test code** - Apply same quality standards to test code
- **Document complex tests** - Explain non-obvious test scenarios

### Common Pitfalls to Avoid
- **Testing implementation details** - Focus on behavior, not internals
- **Overly complex test setup** - Keep test data simple and focused
- **Ignoring test failures** - Never commit code with failing tests
- **Missing edge cases** - Test boundary conditions and error cases

---

*Testing is a critical component of our development process. Every developer is responsible for maintaining test quality and ensuring comprehensive coverage of new features.*