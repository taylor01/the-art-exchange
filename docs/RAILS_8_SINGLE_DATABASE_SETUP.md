# Rails 8 Single Database Setup for DigitalOcean

## Quick Reference Guide

This guide documents the exact steps needed to configure Rails 8 for single database deployment on DigitalOcean (or any provider that gives you one database instead of four).

## The Problem

**Rails 8 defaults to multi-database setup:**
- Primary database (app data)
- Cache database (Solid Cache)
- Queue database (Solid Queue) 
- Cable database (Solid Cable)

**DigitalOcean managed PostgreSQL gives you:**
- One database called `defaultdb`

**Result:** Rails crashes looking for `cache`, `queue`, and `cable` databases that don't exist.

## The Solution: 6 Critical Configuration Changes

### 1. Simplify `config/database.yml`

```yaml
# Replace the entire production section with:
production:
  <<: *default
  url: <%= ENV["DATABASE_URL"] %>
  sslmode: require
```

### 2. Fix Solid Queue in `config/environments/production.rb`

```ruby
# Find this line and comment it out:
# config.solid_queue.connects_to = { database: { writing: :queue } }

# Keep this line:
config.active_job.queue_adapter = :solid_queue
```

### 3. Fix Solid Cache in `config/cache.yml`

```yaml
# Remove the database line:
production:
  <<: *default
  # DELETE: database: cache
```

### 4. Fix Solid Cable in `config/cable.yml`

```yaml
# Remove the connects_to section:
production:
  adapter: solid_cable
  polling_interval: 0.1.seconds
  message_retention: 1.day
  # DELETE the connects_to section
```

### 5. Add Solid Cache config in `config/environments/production.rb`

```ruby
# Add this line after cache_store configuration:
config.solid_cache.connects_to = nil
```

### 6. Remove Schema Files

```bash
# Move these out of the way (Rails auto-detects them):
mv db/cache_schema.rb db/cache_schema.rb.unused
mv db/cable_schema.rb db/cable_schema.rb.unused  
mv db/queue_schema.rb db/queue_schema.rb.unused
```

## Complete Example Files

### `config/database.yml`
```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: the_art_exchange_development

test:
  <<: *default
  database: the_art_exchange_test

production:
  <<: *default
  url: <%= ENV["DATABASE_URL"] %>
  sslmode: require
```

### `config/environments/production.rb` (relevant sections)
```ruby
# Cache configuration
config.cache_store = :solid_cache_store
config.solid_cache.connects_to = nil

# Queue configuration  
config.active_job.queue_adapter = :solid_queue
# config.solid_queue.connects_to = { database: { writing: :queue } }
```

### `config/cache.yml`
```yaml
default: &default
  store_options:
    max_size: <%= 256.megabytes %>
    namespace: <%= Rails.env %>

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
```

### `config/cable.yml`
```yaml
development:
  adapter: async

test:
  adapter: test

production:
  adapter: solid_cable
  polling_interval: 0.1.seconds
  message_retention: 1.day
```

## Verification

After deployment, verify it worked:

```bash
# Should show 13 solid_* tables in your primary database
kamal app exec "bin/rails runner 'puts ActiveRecord::Base.connection.tables.grep(/solid/)'"
```

**Expected output:**
```
solid_queue_claimed_executions
solid_cache_entries
solid_queue_ready_executions
solid_queue_failed_executions
solid_queue_pauses
solid_queue_processes
solid_queue_recurring_executions
solid_queue_recurring_tasks
solid_queue_semaphores
solid_queue_jobs
solid_queue_blocked_executions
solid_queue_scheduled_executions
solid_cable_messages
```

## Common Errors (Before Fix)

```bash
# These errors indicate you need the single database configuration:
❌ "The `cache` database is not configured for the `production` environment"
❌ "The `queue` database is not configured for the `production` environment"  
❌ "The `cable` database is not configured for the `production` environment"
```

## Benefits of Single Database Setup

✅ **Cost effective** - One database instead of four  
✅ **Simpler management** - One connection string  
✅ **Perfect for small-medium apps** - No performance penalty  
✅ **Fewer moving parts** - Less complexity  
✅ **Works great with managed databases** - Most providers give you one database  

## When to Use Multi-Database

Only use Rails 8's default multi-database setup if you have:
- High traffic requiring database isolation
- Multiple servers needing separate connection pools
- Specific performance requirements for each component
- Budget for multiple database instances

For most applications, **single database is the right choice**.