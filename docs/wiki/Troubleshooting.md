# Troubleshooting Guide

## Common Development Issues

### Bundle Install Problems

#### Issue: Gem dependencies conflict
```bash
# Error message
Bundler could not find compatible versions for gem "rails"

# Solution
bundle update
# Or for specific gem conflicts:
bundle update rails
```

#### Issue: libvips installation fails
```bash
# macOS solution
brew update && brew reinstall vips

# Ubuntu/Debian solution
sudo apt-get update
sudo apt-get install --reinstall libvips-dev

# Alpine Linux (Docker)
apk add --update vips-dev
```

#### Issue: Bundle install hangs or is very slow
```bash
# Clear bundler cache
bundle clean --force
rm Gemfile.lock
bundle install

# Use faster bundle jobs
bundle install --jobs 4
```

### Database Issues

#### Issue: PostgreSQL connection refused
```bash
# Check if PostgreSQL is running
brew services list | grep postgresql

# Start PostgreSQL
brew services start postgresql@14

# Reset database if corrupted
rails db:drop db:create db:migrate db:seed
```

#### Issue: Database migration failures
```bash
# Check current migration status
rails db:migrate:status

# Rollback problematic migration
rails db:rollback

# Reset database (development only)
rails db:reset
```

#### Issue: "PG::UndefinedTable" errors
```bash
# Usually means migrations haven't run
rails db:migrate

# If in test environment
RAILS_ENV=test rails db:migrate
```

### Image Processing Issues

#### Issue: ActiveStorage variant processing fails
```bash
# Check libvips installation
vips --version

# Verify image file exists and is readable
file path/to/image.jpg

# Test image processing manually
rails console
> image = ActiveStorage::Blob.create_and_upload!(io: File.open("test.jpg"), filename: "test.jpg")
> image.variant(resize: "300x400>").processed
```

#### Issue: S3 upload failures in development
```bash
# Check AWS credentials
aws s3 ls s3://your-bucket-name

# Verify environment variables
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_BUCKET

# Test S3 connection in Rails console
rails console
> ActiveStorage::Blob.service.bucket.name
```

### Testing Issues

#### Issue: Tests failing due to database state
```bash
# Reset test database
RAILS_ENV=test rails db:reset

# Clean test database
RAILS_ENV=test rails db:test:prepare

# Run specific failing test
bundle exec rspec spec/models/user_spec.rb:25
```

#### Issue: System tests failing with browser errors
```bash
# Update Chrome and chromedriver
brew update && brew upgrade chromedriver

# Check browser configuration
bundle exec rspec spec/system/ --format documentation
```

#### Issue: Factory Bot errors
```bash
# Check factory definitions
bundle exec rspec --dry-run

# Test specific factory
rails console
> FactoryBot.create(:user)
```

### Authentication Issues

#### Issue: OTP codes not being sent
```bash
# Check email configuration in development
# Look for emails in logs:
tail -f log/development.log | grep "Delivered mail"

# Test email delivery in console
rails console
> ActionMailer::Base.delivery_method
> UserMailer.otp_code("test@example.com", "123456").deliver_now
```

#### Issue: OAuth authentication failures
```bash
# Check OAuth credentials
echo $GOOGLE_CLIENT_ID
echo $GOOGLE_CLIENT_SECRET

# Verify callback URLs in OAuth provider settings
# Development: http://localhost:3000/users/auth/google_oauth2/callback
# Production: https://your-domain.com/users/auth/google_oauth2/callback
```

### Asset and Frontend Issues

#### Issue: CSS/JavaScript not updating
```bash
# Clear asset cache
rails tmp:clear

# Precompile assets in development (if needed)
rails assets:precompile

# Restart development server
./bin/dev
```

#### Issue: Stimulus controllers not working
```javascript
// Check browser console for errors
// Verify controller is properly registered

// Debug Stimulus in browser console
application.controllers.forEach((controller, identifier) => {
  console.log(identifier, controller)
})
```

#### Issue: Tailwind classes not applying
```bash
# Rebuild Tailwind CSS
rails tailwindcss:build

# Watch for changes
rails tailwindcss:watch

# Check if classes are in your markup correctly
# Look for typos in class names
```

## Environment Setup Issues

### Ruby Version Problems

#### Issue: Wrong Ruby version
```bash
# Check current Ruby version
ruby --version

# Check required version
cat .ruby-version

# Install correct version with rbenv
rbenv install 3.3.0
rbenv local 3.3.0

# Restart terminal and verify
ruby --version
```

### Node.js and npm Issues

#### Issue: npm install failures
```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Use yarn instead if npm problems persist
yarn install
```

### Environment Variables

#### Issue: Missing environment variables
```bash
# Check .env file exists
ls -la .env

# Copy from example
cp .env.example .env

# Edit with required values
# Common required variables:
# DATABASE_URL
# ANTHROPIC_API_KEY
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
```

## Production Issues

### Deployment Problems

#### Issue: Heroku deployment failures
```bash
# Check Heroku logs
heroku logs --tail --app your-app-name

# Check build logs
heroku logs --source heroku --app your-app-name

# Force rebuild
git commit --allow-empty -m "Force rebuild"
git push heroku main
```

#### Issue: Database migration errors in production
```bash
# Check migration status
heroku run rails db:migrate:status --app your-app-name

# Run specific migration
heroku run rails db:migrate:up VERSION=20240615120000 --app your-app-name

# Rollback if needed (CAREFUL!)
heroku run rails db:rollback --app your-app-name
```

### Performance Issues

#### Issue: Slow page load times
```bash
# Check database query performance
# Look for N+1 queries in logs
heroku logs --app your-app-name | grep "CACHE"

# Add database indexes for slow queries
# Check app/models for missing includes()
```

#### Issue: Memory usage too high
```bash
# Check dyno memory usage
heroku logs --source heroku --app your-app-name

# Scale up dyno if needed
heroku ps:scale web=1:standard-1x --app your-app-name
```

## Development Workflow Issues

### Git and Branch Issues

#### Issue: Merge conflicts
```bash
# Check conflict status
git status

# Open conflicted files and resolve manually
# Look for <<<<<<< ======= >>>>>>> markers

# After resolving conflicts
git add .
git commit
```

#### Issue: Need to reset branch to main
```bash
# Save current work
git stash

# Reset to main
git checkout main
git pull origin main
git checkout feature/your-branch
git reset --hard main

# Apply stashed changes if needed
git stash pop
```

### Code Quality Issues

#### Issue: RuboCop violations
```bash
# Auto-fix most issues
bundle exec rubocop -A

# Check specific files
bundle exec rubocop app/models/user.rb

# Ignore specific rules (temporarily)
bundle exec rubocop --auto-gen-config
```

#### Issue: Security warnings from Brakeman
```bash
# Get detailed security report
bundle exec brakeman -o brakeman_report.html

# Check specific warning details
bundle exec brakeman --debug

# Review and fix legitimate issues
# Add ignores for false positives in config/brakeman.ignore
```

## AI Integration Issues

### Claude API Problems

#### Issue: API key authentication failures
```bash
# Verify API key is set
echo $ANTHROPIC_API_KEY

# Test API connection
rails console
> AnthropicService.test_connection
```

#### Issue: Image analysis timeouts
```bash
# Check image size and format
file path/to/image.jpg

# Verify image is accessible
rails console
> poster = Poster.find(1)
> poster.images.first.byte_size
```

## Search and Data Issues

### Search Functionality Problems

#### Issue: Search returns no results
```bash
# Check if pg_search is working
rails console
> Poster.search_all("test query")

# Rebuild search index if needed
# (This is automatic in PostgreSQL full-text search)
```

#### Issue: Special characters in search
```bash
# Test search with problematic characters
rails console
> query = "artist's name & venue"
> Poster.search_all(query)
```

## Quick Diagnostic Commands

### System Health Check
```bash
# Complete system check
./bin/checks

# Individual components
bundle exec rspec          # Test health
bundle exec rubocop        # Code quality
bundle exec brakeman       # Security
rails db:migrate:status    # Database state
```

### Development Environment Check
```bash
# Check all versions
ruby --version
rails --version
node --version
npm --version
psql --version

# Check services
brew services list | grep postgresql
brew services list | grep redis

# Check environment variables
env | grep -E "(DATABASE_URL|ANTHROPIC_API_KEY|AWS_)"
```

### Database Diagnostics
```bash
# Connection test
rails console
> ActiveRecord::Base.connection.execute("SELECT 1")

# Check table sizes
rails console
> User.count
> Poster.count
> UserPoster.count

# Check for missing data
rails console
> Poster.includes(:artists).where(artists: { id: nil })
```

## Getting Help

### Internal Resources
1. **Check existing documentation** - README, ARCHITECTURE.md, CLAUDE.md
2. **Search closed issues** - GitHub issues for similar problems
3. **Review recent commits** - Recent changes that might be related

### External Resources
1. **Rails Guides** - https://guides.rubyonrails.org/
2. **Ruby Documentation** - https://ruby-doc.org/
3. **Stack Overflow** - Search for specific error messages
4. **Rails API Documentation** - https://api.rubyonrails.org/

### Creating a Bug Report
If you encounter a new issue:

1. **Search existing issues** first
2. **Gather diagnostic information**:
   - Error messages and stack traces
   - Steps to reproduce
   - Environment details (Ruby, Rails, OS versions)
   - Recent changes or commits
3. **Create detailed issue** using bug report template
4. **Include relevant logs and screenshots**

### Emergency Contacts
For production issues:
1. **Check Heroku status** - status.heroku.com
2. **Review application logs** - `heroku logs --tail`
3. **Follow hotfix process** if critical issue
4. **Document incident** for post-mortem analysis

---

*This troubleshooting guide covers common development and deployment issues. For issues not covered here, please create a GitHub issue with detailed information about the problem.*