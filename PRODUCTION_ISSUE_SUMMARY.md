# Production Issue Summary - 2025-06-29

## Problem: Image Processing Failures in Production

**Issue**: Production deployment experiencing persistent `Vips::Error (VipsOperation: class "quality" not found)` when generating image variants with `quality: 30` parameter.

### Current Error Pattern
```
Vips::Error (VipsOperation: class "quality" not found)
```

**Affected URLs**: All blur placeholder image variants
- Path: `/rails/active_storage/representations/redirect/.../eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJqcGciLCJyZXNpemVfdG9fZmlsbCI6WzIwLDI3XSwicXVhbGl0eSI6MzB9...`
- Parameters: `resize_to_fill: [20, 27], quality: 30`
- Status: 500 Internal Server Error

### Root Cause Analysis
The libvips installation in the Docker container lacks complete JPEG quality operation support despite having required packages installed.

### Solutions Attempted

#### ✅ Rate Limiting Fix (RESOLVED)
- **Problem**: Rack::Attack general throttling (300 req/5min) causing "Rate limit exceeded" errors
- **Solution**: Removed general IP-based rate limiting, kept auth-specific limits
- **Files Modified**: `config/initializers/rack_attack.rb`
- **Result**: Users can now browse freely without throttling errors

#### ⚠️ Docker Package Updates (ONGOING)
- **Attempts**: Multiple Dockerfile enhancements
- **Packages Added**: 
  - `libvips-dev` (development headers)
  - `libvips-tools` (command line tools) 
  - `libjpeg-dev` (JPEG development libraries)
- **Files Modified**: `Dockerfile`
- **Verification**: Packages confirmed installed in production container
- **Result**: Issue persists despite complete libvips installation

### Current Production Status
- **✅ Rate limiting resolved** - Normal browsing restored
- **❌ Image variants failing** - All blur placeholder images return 500 errors
- **✅ Core functionality working** - Main poster images and larger variants work
- **✅ Database migration complete** - 772/773 poster images successfully migrated

### Technical Details

#### Production Environment
- **Platform**: DigitalOcean via Kamal deployment
- **Container**: Ubuntu-based with Ruby 3.4.3
- **Image Processing**: ruby-vips 2.2.4 + image_processing 1.14.0
- **Installed Packages**: libvips42, libvips-dev, libvips-tools, libjpeg-dev

#### Affected Code Location
- **File**: `app/models/poster.rb`
- **Method**: `blur_placeholder_image_for_display`
- **Variant**: `image.variant(resize_to_fill: [20, 27], quality: 30)`

#### Error Stack Trace
```
ruby-vips (2.2.4) lib/vips/operation.rb:218:in 'Vips::Operation#initialize'
...
image_processing (1.14.0) lib/image_processing/processor.rb:62:in 'ImageProcessing::Processor#apply_operation'
activestorage (8.0.2) lib/active_storage/transformers/image_processing_transformer.rb:25
```

### Next Steps for Investigation

#### 1. Deep Dive libvips Diagnosis
```bash
# Test libvips operations directly in production container
kamal app exec "ruby -e 'require \"vips\"; puts Vips::Operation.list'"
kamal app exec "ruby -e 'require \"vips\"; img = Vips::Image.new_from_file(\"/path/to/test.jpg\"); puts img.quality(30)'"
```

#### 2. Alternative Solutions
- **Quick Fix**: Remove `quality: 30` parameter from blur placeholder variants
- **Processor Switch**: Change from libvips to ImageMagick processor
- **Variant Redesign**: Use different optimization strategy for blur placeholders

#### 3. libvips Build Investigation
- Check if libvips was compiled without JPEG quality support
- Verify JPEG libraries are properly linked
- Consider building custom libvips with full JPEG support

#### 4. Fallback Implementation
```ruby
# Temporary fix in poster.rb
def blur_placeholder_image_for_display
  return image unless image.attached?
  
  if self.class.variant_processing_available?
    # Remove quality parameter temporarily
    image.variant(resize_to_fill: [20, 27])
  else
    image
  end
end
```

### Files to Review Tomorrow
- `app/models/poster.rb` - Image variant definitions
- `Dockerfile` - Container image configuration  
- `config/initializers/rack_attack.rb` - Rate limiting configuration (resolved)
- Production logs - Pattern analysis of failed requests

### Git Status
- **Branch**: `fix/remove-general-rate-limiting` (merged to main)
- **Recent Commits**:
  - `d53a271` - Add libvips-tools and libjpeg-dev for complete JPEG quality support
  - `52f8377` - Fix libvips JPEG quality support in production Docker image

### Priority Assessment
**High Priority** - Image variants are core functionality for poster browsing experience. Blur placeholders provide visual loading states that enhance UX.

### Success Metrics
- [ ] All image variant URLs return 200 status
- [ ] Blur placeholder images generate successfully  
- [ ] No Vips::Error messages in production logs
- [ ] Image loading performance maintained

---

**Date**: 2025-06-29  
**Status**: Active Investigation Required  
**Next Review**: 2025-06-30