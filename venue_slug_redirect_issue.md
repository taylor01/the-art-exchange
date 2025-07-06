# Implement venue slug redirect system for name changes

## Problem

When venue names are updated (e.g., "Staples Center" → "Crypto.com Arena"), the venue slug changes which breaks existing URLs and bookmarks. We need a redirect system to maintain URL compatibility.

## Background

The enhanced venue research system has identified 71 venues with outdated names. When these names are updated, we need to ensure:
- Existing bookmarks continue to work
- Search engine indexed URLs redirect properly  
- Internal links don't break
- SEO value is preserved

## Proposed Solution

Implement a venue slug redirect system with one of these approaches:

### Option 1: Venue Redirects Table
```ruby
# venue_redirects table
venue_id, old_slug, created_at

# Route handling
# When /venues/staples-center is accessed:
# 1. Check if venue exists with that slug
# 2. If not, check VenueRedirect.find_by(old_slug: 'staples-center')  
# 3. If found, 301 redirect to current venue slug
```

### Option 2: Slug History Tracking
```ruby
# Track all historical slugs for each venue
# venue.all_slugs => ['staples-center', 'crypto-com-arena']
# Always redirect old slugs to current canonical slug
```

### Option 3: Immutable Slugs
```ruby
# Never change slugs, only update display names
# /venues/staples-center always works but shows "Crypto.com Arena"
```

## Acceptance Criteria

- [ ] Old venue URLs continue to work after name changes
- [ ] 301 redirects preserve SEO value
- [ ] System tracks slug history for audit purposes
- [ ] Performance impact is minimal
- [ ] Admin interface shows redirect mappings

## Related

- 71 venues currently flagged for name review via enhanced venue research
- Name review system in place with admin-only indicators
- Venue research system will continue flagging new name changes

## Priority

Medium - Not blocking current name updates but important for user experience