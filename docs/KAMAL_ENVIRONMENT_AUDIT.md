# Kamal Environment Audit Tools

This directory contains comprehensive tools for auditing and managing environment variables in your Kamal deployment setup.

## Overview

The Kamal Environment Audit tools help ensure your DigitalOcean deployment won't fail due to missing environment variables. They provide:

1. **Environment Discovery** - Find all environment variables used in your Rails application
2. **Configuration Audit** - Compare your needs with current Kamal configuration  
3. **1Password Integration** - Validate and manage secrets from 1Password vault
4. **Deployment Testing** - Simulate the deployment environment before deploying
5. **Auto-Fix Capabilities** - Automatically update configuration files

## Tools

### 1. `bin/kamal-env-audit.rb` - Main Audit Tool

The primary tool for auditing your Kamal environment configuration.

#### Commands

```bash
# Discover all environment variables in your Rails app
./bin/kamal-env-audit.rb discover

# Audit current Kamal configuration
./bin/kamal-env-audit.rb audit

# Validate 1Password vault access
./bin/kamal-env-audit.rb validate

# Test deployment environment simulation  
./bin/kamal-env-audit.rb test

# Auto-fix missing configuration
./bin/kamal-env-audit.rb fix

# Full pre-deployment check
./bin/kamal-env-audit.rb deploy-check
```

#### Example Output

```
🔍 Kamal Environment Auditor
==================================================

📋 Environment Variables Discovered in Rails Application:
------------------------------------------------------------
DATABASE_URL              | REQUIRED | PostgreSQL connection URL
RAILS_MASTER_KEY          | REQUIRED | Rails application master key
AWS_ACCESS_KEY_ID         | REQUIRED | AWS S3 access key
ANTHROPIC_API_KEY         | REQUIRED | Anthropic Claude API key
GOOGLE_CLIENT_ID          | OPTIONAL | Google OAuth client ID

📊 Summary:
   Required variables: 9
   Optional variables: 14
   Total variables: 23
```

### 2. `bin/kamal-setup-helper.rb` - Setup Assistant

Helps with initial setup and ongoing maintenance of your Kamal environment.

#### Commands

```bash
# Set up 1Password integration from scratch
./bin/kamal-setup-helper.rb init

# Test 1Password secrets access
./bin/kamal-setup-helper.rb test-secrets

# Update secrets file to match deploy.yml
./bin/kamal-setup-helper.rb update-secrets

# Test Rails application boot with production config
./bin/kamal-setup-helper.rb validate-rails

# Test environment with Docker
./bin/kamal-setup-helper.rb docker-test
```

## Environment Variables Discovered

The audit tool has discovered the following environment variables in your Rails application:

### Required Variables (9)
- `DATABASE_URL` - PostgreSQL connection URL
- `RAILS_MASTER_KEY` - Rails application master key  
- `RAILS_ENV` - Rails environment
- `AWS_ACCESS_KEY_ID` - AWS S3 access key
- `AWS_SECRET_ACCESS_KEY` - AWS S3 secret key
- `AWS_REGION` - AWS S3 region
- `AWS_S3_BUCKET` - AWS S3 bucket name
- `ANTHROPIC_API_KEY` - Anthropic Claude API key
- `KAMAL_REGISTRY_PASSWORD` - Docker registry password

### Optional Variables (14)
- `RAILS_MAX_THREADS` - Database connection pool size
- `RAILS_LOG_LEVEL` - Rails logging level
- `PORT` - Puma server port
- `PIDFILE` - Puma PID file location
- `WEB_CONCURRENCY` - Number of Puma workers
- `SOLID_QUEUE_IN_PUMA` - Run Solid Queue in Puma process
- `GOOGLE_CLIENT_ID` - Google OAuth client ID
- `GOOGLE_CLIENT_SECRET` - Google OAuth client secret
- `FACEBOOK_APP_ID` - Facebook OAuth app ID
- `FACEBOOK_APP_SECRET` - Facebook OAuth app secret
- `APPLE_CLIENT_ID` - Apple OAuth client ID
- `APPLE_TEAM_ID` - Apple OAuth team ID
- `APPLE_KEY_ID` - Apple OAuth key ID
- `APPLE_PRIVATE_KEY` - Apple OAuth private key

## Current Configuration Status

Based on your current `config/deploy.yml` and `.kamal/secrets`:

✅ **All required variables are properly configured**
⚠️  **13 optional variables are missing** (OAuth credentials for social login)

## 1Password Integration

Your application uses 1Password for secure secret management:

- **Account ID**: `EDM2HXLJBJBWLAD4MSSMVVEYVQ`
- **Vault**: `Kamal-Deployment-Secrets/the-art-exchange-production`
- **Secrets Managed**: 8 required environment variables

## Workflow

### Initial Setup
1. Run `./bin/kamal-setup-helper.rb init` to set up 1Password integration
2. Add all required secrets to your 1Password vault
3. Run `./bin/kamal-env-audit.rb validate` to test access

### Before Each Deployment
1. Run `./bin/kamal-env-audit.rb deploy-check` for full validation
2. Fix any issues reported
3. Deploy with confidence using `kamal deploy`

### Adding New Environment Variables
1. Add the variable to your Rails application code
2. Run `./bin/kamal-env-audit.rb discover` to see new variables
3. Add to `config/deploy.yml` in the appropriate section
4. Run `./bin/kamal-setup-helper.rb update-secrets` to update extraction
5. Add the secret value to your 1Password vault

## Troubleshooting

### Common Issues

1. **"1Password CLI not found"**
   ```bash
   brew install 1password-cli
   op signin
   ```

2. **"Missing secrets in 1Password vault"**
   - Add the missing secrets to your vault
   - Use the exact variable names shown in the audit

3. **"Secrets extraction syntax errors"** 
   ```bash
   ./bin/kamal-setup-helper.rb test-secrets
   ```

4. **"Docker environment simulation failed"**
   - Check that all required environment variables are set
   - Verify Docker is running and accessible

### Getting Help

Each script includes built-in help:
```bash
./bin/kamal-env-audit.rb help
./bin/kamal-setup-helper.rb help
```

## Security Notes

- Never commit actual secret values to git
- The `.kamal/secrets` file only contains extraction commands, not values
- All actual secrets are stored securely in 1Password
- Scripts include syntax validation to prevent credential exposure

## Rails 8 Single Database Configuration

### Critical Configuration Changes Required

When deploying Rails 8 to DigitalOcean with a single database (instead of the default multi-database setup), several configuration files must be modified:

#### 1. **Database Configuration (`config/database.yml`)**
```yaml
# BEFORE (Rails 8 default - multi-database)
production:
  primary: &primary_production
    <<: *default
    url: <%= ENV["DATABASE_URL"] %>
    database: the_art_exchange_production
    sslmode: require
  cache:
    <<: *primary_production
    database: the_art_exchange_cache
    migrations_paths: db/cache_migrate
  queue:
    <<: *primary_production
    database: the_art_exchange_queue
    migrations_paths: db/queue_migrate
  cable:
    <<: *primary_production
    database: the_art_exchange_cable
    migrations_paths: db/cable_migrate

# AFTER (Single database setup)
production:
  <<: *default
  url: <%= ENV["DATABASE_URL"] %>
  sslmode: require
```

#### 2. **Solid Queue Configuration (`config/environments/production.rb`)**
```ruby
# BEFORE
config.active_job.queue_adapter = :solid_queue
config.solid_queue.connects_to = { database: { writing: :queue } }

# AFTER
config.active_job.queue_adapter = :solid_queue
# Use primary database for Solid Queue (single database setup)
# config.solid_queue.connects_to = { database: { writing: :queue } }
```

#### 3. **Solid Cache Configuration (`config/cache.yml`)**
```yaml
# BEFORE
production:
  database: cache
  <<: *default

# AFTER  
production:
  <<: *default
```

#### 4. **Solid Cable Configuration (`config/cable.yml`)**
```yaml
# BEFORE
production:
  adapter: solid_cable
  connects_to:
    database:
      writing: cable
  polling_interval: 0.1.seconds
  message_retention: 1.day

# AFTER
production:
  adapter: solid_cable
  polling_interval: 0.1.seconds
  message_retention: 1.day
```

#### 5. **Solid Cache Environment Configuration (`config/environments/production.rb`)**
```ruby
# ADD THIS LINE
config.solid_cache.connects_to = nil
```

#### 6. **Remove Separate Schema Files**
```bash
# Move these files out of the way (Rails auto-detects them and tries to configure separate databases)
mv db/cache_schema.rb db/cache_schema.rb.unused
mv db/cable_schema.rb db/cable_schema.rb.unused  
mv db/queue_schema.rb db/queue_schema.rb.unused
```

### Why This Is Necessary

**Rails 8 Default Behavior:**
- Expects separate databases for cache, queue, and cable
- Optimized for high-traffic, multi-server deployments
- Each component gets isolated database connections

**DigitalOcean Managed PostgreSQL:**
- Provides single database (`defaultdb`)
- Additional databases cost extra
- Single database is perfect for small-to-medium applications

**Single Database Benefits:**
- ✅ Lower cost (one database vs four)
- ✅ Simpler management
- ✅ Fewer connections to manage
- ✅ All data in one place
- ✅ Perfect for single-server deployments

### Verification Commands

After deployment, verify all Solid components are using the primary database:

```bash
# Check all Solid tables exist in primary database
kamal app exec "bin/rails runner 'puts ActiveRecord::Base.connection.tables.grep(/solid/)'"

# Should show 13 tables:
# solid_queue_* (9 tables)
# solid_cache_entries (1 table)  
# solid_cable_messages (1 table)
```

### Common Gotchas

1. **Installer Commands Revert Changes**
   ```bash
   # These commands will recreate separate database configurations:
   bin/rails solid_queue:install
   bin/rails solid_cache:install  
   bin/rails solid_cable:install
   
   # Re-apply single database fixes after running installers
   ```

2. **Schema Files Auto-Detection**
   - Rails detects `db/*_schema.rb` files and assumes separate databases
   - Move them out of the way to prevent auto-configuration

3. **Multiple Configuration Locations**
   - Check both `config/environments/production.rb` AND component-specific YAML files
   - Installers may add configurations in multiple places

## Integration with Development Workflow

These tools integrate with your existing development workflow:

1. **GitHub Issues** - Create issues for missing environment variables
2. **Pull Requests** - Run audit before merging configuration changes  
3. **Deployment** - Use deploy-check as part of deployment process
4. **Monitoring** - Regular audits ensure configuration drift doesn't occur

## Advanced Usage

### Custom Environment Variables

To add custom environment variables:

1. Add them to the `DISCOVERED_ENV_VARS` hash in `kamal-env-audit.rb`
2. Mark as required or optional
3. Add source information for documentation

### Multiple Environments

For staging/development environments:
- Create separate 1Password vaults
- Modify the vault path in scripts
- Use different Kamal configuration files

### CI/CD Integration

The audit script can be used in CI/CD pipelines:
```bash
# In your GitHub Actions or similar
./bin/kamal-env-audit.rb deploy-check
if [ $? -ne 0 ]; then
  echo "Environment audit failed"
  exit 1
fi
```