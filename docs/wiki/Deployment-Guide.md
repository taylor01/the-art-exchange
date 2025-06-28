# Deployment Guide

## Overview

The Art Exchange is deployed using **Heroku** with **Kamal deployment system** for streamlined, zero-downtime deployments. This guide covers the complete deployment process, environment configuration, and operational procedures.

*For detailed deployment configuration, see [DEPLOYMENT.md](../blob/main/DEPLOYMENT.md) in the repository.*

## Deployment Architecture

### Production Platform
- **Primary Platform**: Heroku with Kamal deployment tooling
- **Domain**: v2.theartexch.com (production)
- **Database**: Heroku Postgres or DigitalOcean Managed PostgreSQL
- **File Storage**: AWS S3 with CloudFront CDN
- **SSL**: Let's Encrypt certificates via Kamal
- **Background Jobs**: Solid Queue running in Puma process

### Infrastructure Components
```
Production Environment:
├── Web Application (Heroku dyno)
├── Database (Heroku Postgres)
├── File Storage (AWS S3)
├── CDN (CloudFront)
├── Email Service (Action Mailer)
└── Background Processing (Solid Queue)
```

## Environment Configuration

### Required Environment Variables

#### Database Configuration
```bash
# Primary database connection
DATABASE_URL=postgresql://username:password@hostname:port/database_name

# Rails environment
RAILS_ENV=production
RACK_ENV=production
```

#### AWS S3 Storage Configuration
```bash
# S3 storage for images and files
AWS_ACCESS_KEY_ID=your_access_key_id
AWS_SECRET_ACCESS_KEY=your_secret_access_key
AWS_REGION=us-west-2
AWS_BUCKET=your-production-bucket-name

# Optional: CloudFront CDN
AWS_CLOUDFRONT_DISTRIBUTION_ID=your_distribution_id
```

#### AI Integration
```bash
# Anthropic Claude API for visual metadata
ANTHROPIC_API_KEY=your_claude_api_key
```

#### Authentication & OAuth
```bash
# OAuth providers (optional but recommended)
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret

APPLE_CLIENT_ID=your_apple_client_id
APPLE_TEAM_ID=your_apple_team_id
APPLE_KEY_ID=your_apple_key_id
APPLE_PRIVATE_KEY=your_apple_private_key_content
```

#### Email Configuration
```bash
# Email delivery for OTP codes
SMTP_HOST=your_smtp_host
SMTP_PORT=587
SMTP_USERNAME=your_smtp_username
SMTP_PASSWORD=your_smtp_password
SMTP_DOMAIN=theartexch.com
```

#### Application Security
```bash
# Rails security
SECRET_KEY_BASE=your_long_random_secret_key
RAILS_MASTER_KEY=your_master_key

# Session configuration
SESSION_TIMEOUT=7200  # 2 hours in seconds
```

### Secret Management

#### 1Password Vault
All sensitive environment variables are stored in a shared **1Password vault** for the development team:

```
Vault: "The Art Exchange Production"
Items:
├── "Heroku Environment Variables"
├── "AWS S3 Credentials" 
├── "Anthropic API Key"
├── "OAuth Credentials"
└── "Database Credentials"
```

#### Environment Variable Management
```bash
# Local development (.env file)
cp .env.example .env
# Edit .env with development values

# Production (Heroku)
heroku config:set VAR_NAME=value --app your-app-name

# Or bulk upload from file
heroku config:push --file .env.production --app your-app-name
```

## Deployment Process

### Initial Heroku Setup

#### 1. Create Heroku Application
```bash
# Create new Heroku app
heroku create the-art-exchange-prod

# Add PostgreSQL database
heroku addons:create heroku-postgresql:basic --app the-art-exchange-prod

# Add Redis (for caching, optional)
heroku addons:create heroku-redis:mini --app the-art-exchange-prod
```

#### 2. Configure Environment Variables
```bash
# Set required environment variables
heroku config:set RAILS_ENV=production --app the-art-exchange-prod
heroku config:set SECRET_KEY_BASE=$(rails secret) --app the-art-exchange-prod

# Set all other variables from 1Password vault
heroku config:set AWS_ACCESS_KEY_ID=... --app the-art-exchange-prod
heroku config:set AWS_SECRET_ACCESS_KEY=... --app the-art-exchange-prod
# ... (continue with all required variables)
```

#### 3. Deploy Application
```bash
# Deploy from main branch
git push heroku main

# Or deploy specific branch
git push heroku feature-branch:main
```

### Kamal Deployment Configuration

#### Kamal Setup Files
```yaml
# config/deploy.yml
service: the-art-exchange
image: the-art-exchange

servers:
  web:
    hosts:
      - your-production-server.com
    options:
      "publish":
        - "80:3000"
        - "443:3000"

registry:
  server: registry.digitalocean.com
  username: your-username
  password:
    - KAMAL_REGISTRY_PASSWORD

env:
  clear:
    RAILS_ENV: production
  secret:
    - DATABASE_URL
    - SECRET_KEY_BASE
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - ANTHROPIC_API_KEY
```

#### Kamal Deployment Commands
```bash
# Initial setup
kamal setup

# Deploy updates
kamal deploy

# Check deployment status
kamal app logs

# Rollback deployment
kamal rollback
```

## Database Management

### Production Database Operations

#### Database Migrations
```bash
# Run migrations on Heroku
heroku run rails db:migrate --app the-art-exchange-prod

# Check migration status
heroku run rails db:migrate:status --app the-art-exchange-prod

# Rollback migration (if needed)
heroku run rails db:rollback --app the-art-exchange-prod
```

#### Database Backups
```bash
# Create manual backup
heroku pg:backups:capture --app the-art-exchange-prod

# List available backups
heroku pg:backups --app the-art-exchange-prod

# Download backup
heroku pg:backups:download --app the-art-exchange-prod
```

#### Production Data Migration
```bash
# Execute production migration (from legacy system)
heroku run rake production:migrate_users --app the-art-exchange-prod
heroku run rake production:migrate_posters --app the-art-exchange-prod
heroku run rake production:migrate_images --app the-art-exchange-prod

# Validate migration results
heroku run rake production:validate_migration --app the-art-exchange-prod
```

## File Storage Configuration

### AWS S3 Setup

#### S3 Bucket Configuration
```bash
# Create production bucket
aws s3 mb s3://the-art-exchange-production

# Configure bucket policy for private access
aws s3api put-bucket-policy --bucket the-art-exchange-production --policy file://s3-policy.json
```

#### S3 Policy Configuration
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::the-art-exchange-production/*",
      "Condition": {
        "StringNotEquals": {
          "aws:Referer": [
            "https://v2.theartexch.com/*",
            "https://the-art-exchange-prod.herokuapp.com/*"
          ]
        }
      }
    }
  ]
}
```

#### CORS Configuration
```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST", "DELETE"],
    "AllowedOrigins": [
      "https://v2.theartexch.com",
      "https://the-art-exchange-prod.herokuapp.com"
    ],
    "ExposeHeaders": ["ETag"],
    "MaxAgeSeconds": 3000
  }
]
```

### CloudFront CDN (Optional)
```bash
# Create CloudFront distribution
aws cloudfront create-distribution --distribution-config file://cloudfront-config.json

# Set environment variable
heroku config:set AWS_CLOUDFRONT_DISTRIBUTION_ID=your_distribution_id
```

## Monitoring & Logging

### Application Monitoring

#### Heroku Logs
```bash
# Tail production logs
heroku logs --tail --app the-art-exchange-prod

# Filter specific logs
heroku logs --source app --app the-art-exchange-prod
heroku logs --dyno web.1 --app the-art-exchange-prod

# Download log archive
heroku logs --num 1500 --app the-art-exchange-prod > production.log
```

#### Performance Monitoring
```bash
# Check dyno status
heroku ps --app the-art-exchange-prod

# Scale dynos if needed
heroku ps:scale web=2 --app the-art-exchange-prod

# Check resource usage
heroku logs --source heroku --app the-art-exchange-prod
```

### Database Monitoring
```bash
# Database metrics
heroku pg:info --app the-art-exchange-prod

# Connection status
heroku pg:psql --app the-art-exchange-prod

# Query performance
heroku pg:diagnose --app the-art-exchange-prod
```

## Security Configuration

### SSL/TLS Setup
```bash
# Heroku automatically provides SSL
# Verify certificate status
heroku certs:info --app the-art-exchange-prod

# Custom domain setup
heroku domains:add v2.theartexch.com --app the-art-exchange-prod
```

### Security Headers
```ruby
# config/application.rb - Security configuration
config.force_ssl = true if Rails.env.production?

# config/environments/production.rb
config.ssl_options = {
  secure_cookies: true,
  hsts: { expires: 1.year, preload: true }
}
```

### Environment Variable Security
```bash
# Rotate sensitive credentials regularly
heroku config:set SECRET_KEY_BASE=$(rails secret) --app the-art-exchange-prod

# Check for exposed secrets
heroku config --app the-art-exchange-prod | grep -v "=.*"
```

## Deployment Checklist

### Pre-Deployment Verification
- [ ] All tests passing locally (`./bin/checks`)
- [ ] Database migrations reviewed and tested
- [ ] Environment variables updated in 1Password
- [ ] S3 bucket and permissions configured
- [ ] SSL certificate valid and current

### Deployment Steps
```bash
# 1. Create deployment branch
git checkout -b deployment/$(date +%Y-%m-%d)

# 2. Run pre-deployment checks
./bin/checks
bundle exec rspec
bundle exec brakeman

# 3. Deploy to production
git push heroku main
# OR
kamal deploy

# 4. Run post-deployment tasks
heroku run rails db:migrate --app the-art-exchange-prod
heroku restart --app the-art-exchange-prod
```

### Post-Deployment Verification
- [ ] Application responds correctly (https://v2.theartexch.com)
- [ ] Database migrations completed successfully
- [ ] Image uploads working with S3
- [ ] Authentication system functional
- [ ] Error monitoring active

## Rollback Procedures

### Heroku Rollback
```bash
# View recent releases
heroku releases --app the-art-exchange-prod

# Rollback to previous release
heroku rollback v123 --app the-art-exchange-prod

# Check rollback status
heroku logs --tail --app the-art-exchange-prod
```

### Database Rollback
```bash
# Rollback database migration
heroku run rails db:rollback --app the-art-exchange-prod

# Restore from backup (if needed)
heroku pg:backups:restore b001 DATABASE_URL --app the-art-exchange-prod
```

### Kamal Rollback
```bash
# Rollback Kamal deployment
kamal rollback

# Check previous deployments
kamal app version
```

## Scaling & Performance

### Horizontal Scaling
```bash
# Scale web dynos
heroku ps:scale web=3 --app the-art-exchange-prod

# Add worker dynos for background jobs
heroku ps:scale worker=1 --app the-art-exchange-prod
```

### Database Scaling
```bash
# Upgrade database plan
heroku addons:upgrade heroku-postgresql:standard-0 --app the-art-exchange-prod

# Connection pooling
heroku config:set DATABASE_POOL=10 --app the-art-exchange-prod
```

### Performance Optimization
```ruby
# config/environments/production.rb
# Enable caching
config.cache_classes = true
config.action_controller.perform_caching = true
config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }

# Asset optimization
config.assets.compile = false
config.assets.digest = true
```

## Troubleshooting

### Common Deployment Issues

#### Environment Variable Problems
```bash
# Check all environment variables
heroku config --app the-art-exchange-prod

# Test specific variable
heroku run echo $DATABASE_URL --app the-art-exchange-prod
```

#### Database Connection Issues
```bash
# Test database connection
heroku run rails db:version --app the-art-exchange-prod

# Check connection pool
heroku run rails runner "puts ActiveRecord::Base.connection_pool.stat"
```

#### S3 Upload Problems
```bash
# Test S3 connectivity
heroku run rails runner "puts ActiveStorage::Blob.service.bucket.name"

# Check AWS credentials
heroku run rails runner "puts Aws::S3::Client.new.list_buckets.buckets.map(&:name)"
```

#### Performance Issues
```bash
# Check dyno resources
heroku logs --source heroku --app the-art-exchange-prod

# Monitor memory usage
heroku run cat /proc/meminfo --app the-art-exchange-prod
```

## Maintenance Tasks

### Regular Maintenance Schedule

#### Daily
- Monitor application logs for errors
- Check system performance metrics
- Verify backup completion

#### Weekly  
- Review database performance
- Check S3 storage usage and costs
- Rotate log files

#### Monthly
- Update security certificates
- Review and rotate API keys
- Performance optimization review

### Maintenance Commands
```bash
# Database maintenance
heroku pg:maintenance:run --app the-art-exchange-prod

# Clear logs
heroku logs --num 0 --app the-art-exchange-prod

# Restart application
heroku restart --app the-art-exchange-prod
```

---

*For additional operational procedures and configuration details, see [DEPLOYMENT.md](../blob/main/DEPLOYMENT.md) and the 1Password vault for sensitive configuration values.*