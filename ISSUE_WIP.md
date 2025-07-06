# DMB Setlist Integration - Work in Progress

## STRATEGY CHANGE (2025-01-05)

**Decision: Fix scraper first, then re-import clean data**

After analyzing the root cause of import issues, we determined that **32% of import errors (347/1,084 files) stem from data quality problems in the scraper itself**. Rather than patching symptoms in the importer, we're fixing the source.

## Current Status - Scraper Fix Phase

### ✅ Completed
1. **Issue Tracking**: Created GitHub Issue #88 to track scraper fixes
2. **Clean Workspace**: Deleted all 1,084 JSON files and cleared database
3. **Import Infrastructure**: Working importer with proper venue matching, song deduplication, and PostgreSQL fuzzy matching

### 🔧 Current Work - Single Setlist Testing
**Approach**: Fix one setlist at a time until perfect, then scale up

#### Scraper Issues Identified:
1. **Empty Song Titles** (Critical)
   - `parse_song_line()` strips "(Madman's Eyes)" leaving empty string
   - Causes `undefined method 'map' for false` errors
   
2. **HTML Tags in Venue Names**
   - "Dave & Tim<br>XFINITY Theatre" breaks venue matching
   - Creates duplicate venues
   
3. **Character Encoding Issues**
   - "GravediggerÄ" and similar special characters
   
4. **Encore/Main Set Duplication**
   - Same songs appearing in both arrays
   
5. **Guest Information Parsing**
   - Generic "guest performance" instead of actual names

### 🎯 Next Steps (In Order)
1. **Pick Target Setlist**: Choose recent show with known issues for testing
2. **Modify Scraper**: Fix empty title handling in `parse_song_line()`
3. **Test Single Show**: Generate and validate one perfect JSON file
4. **Iterative Fixes**: Address remaining issues one by one
5. **Small Batch Test**: 5-10 shows to validate fixes
6. **Full Re-scrape**: All historical data with fixed scraper
7. **Clean Import**: Import perfect dataset

### 📊 Success Metrics
- **Zero empty song titles** in generated JSON
- **No HTML tags** in venue names
- **Import error rate <5%** (down from 32%)
- **Venue count ~200-300** for 737 shows (down from 407)

### Previous Work (Still Valid)
- SetlistImportService with cache clearing
- VenueMatchingService with PostgreSQL trigram similarity  
- SongDeduplicationService with DMB patterns
- Show UI pages with poster integration
- Mapbox geocoder configuration

### Files Modified
- `app/services/setlist_import_service.rb` - Cache clearing, existence check fixes
- `app/services/venue_matching_service.rb` - Public find_existing_venue method
- `app/models/venue.rb` - Added has_many :shows association
- `app/controllers/shows_controller.rb` - Poster linking logic
- `app/views/shows/show.html.erb` - Multi-night run poster display
- `config/initializers/geocoder.rb` - Mapbox configuration

### Error Examples to Debug
```
undefined method 'map' for false - affects ~100+ files
Title can't be blank, Slug can't be blank - affects ~50+ files
'festival' is not a valid venue_type - affects ~10+ files
```

### Testing Commands
```bash
# Check import status
bundle exec rails runner "puts \"Shows: #{Show.count}, Songs: #{Song.count}, Venues: #{Venue.count}\""

# Find potential venue duplicates
bundle exec rails runner "venues = Venue.where('name ILIKE ?', '%amphitheatre%'); venues.each { |v| puts \"#{v.name} (#{v.city}, #{v.administrative_area})\" }"

# Test single file import
bundle exec rake "setlists:import_single[filename.json]"

# Full import (takes ~1 minute, 347 errors expected)
bundle exec rake setlists:import
```

### Technical Debt
- Venue matching algorithm needs refinement
- Need automated duplicate detection and merging
- Error handling could be more granular
- Import process needs better validation and rollback capabilities