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