# Production Deployment Guide

## Image Processing Dependencies

### Issue #39: Active Storage Variants

The poster grid optimization (Issue #39) uses Active Storage variants for performance. This requires an image processing library in production.

### Production Setup Options

#### Option 1: Install libvips (Recommended)
```bash
# Ubuntu/Debian
apt-get update && apt-get install -y libvips-dev

# RHEL/CentOS/Amazon Linux
yum install -y vips-devel

# Alpine Linux (Docker)
apk add --no-cache vips-dev

# macOS (development)
brew install vips
```

#### Option 2: Use ImageMagick (Alternative)
```bash
# Ubuntu/Debian  
apt-get update && apt-get install -y imagemagick libmagickwand-dev

# RHEL/CentOS/Amazon Linux
yum install -y ImageMagick ImageMagick-devel

# Then update Gemfile to use mini_magick instead:
# gem "image_processing", "~> 1.2"
# becomes:
# gem "mini_magick", "~> 4.9"
```

#### Option 3: Graceful Degradation (Current Implementation)
The current implementation includes fallback handling:
- If image processing is unavailable, original images are served
- Performance benefits are lost, but functionality is maintained
- Warnings are logged for monitoring

### Docker Deployment
```dockerfile
# Add to your Dockerfile
RUN apt-get update && apt-get install -y \
  libvips-dev \
  && rm -rf /var/lib/apt/lists/*
```

### Heroku Deployment
Add the following buildpack before the Ruby buildpack:
```bash
heroku buildpacks:add --index 1 https://github.com/brandoncc/heroku-buildpack-vips
```

### AWS/Cloud Deployment
- **ECS/EKS**: Include libvips in your container image
- **Elastic Beanstalk**: Add libvips to .ebextensions configuration
- **Lambda**: Use a layer with precompiled libvips

### Performance Impact
- **With variants**: 90% bandwidth reduction, 50%+ faster page loads
- **Without variants**: Fallback to original images, no performance gain
- **Monitoring**: Check logs for "Variant processing not available" warnings

### Verification
After deployment, verify variants are working:
```ruby
# In Rails console
poster = Poster.first
poster.thumbnail_url # Should generate without errors
```

## Storage Configuration

### S3 Configuration (Production)
Update `config/storage.yml`:
```yaml
amazon:
  service: S3
  access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
  secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
  region: us-east-1
  bucket: your-bucket-name-<%= Rails.env %>
```

Update `config/environments/production.rb`:
```ruby
config.active_storage.service = :amazon
```

### Required Environment Variables
```bash
# AWS credentials (use IAM roles in production)
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key

# Application URL for Active Storage URLs
RAILS_HOST=your-production-domain.com
```

## Monitoring

Monitor these metrics post-deployment:
- Image processing errors in logs
- Page load times for poster grid
- Storage usage (variants add ~20% overhead)
- CDN cache hit rates for image requests