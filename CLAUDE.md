# Claude Development Instructions

## Development Workflow Rules

1. **One feature at a time** - Work on a single feature/fix/hotfix before moving to the next
2. **GitHub issue required** - Create a GitHub issue BEFORE doing any work
3. **Strategy discussion** - Discuss the strategy to address the GitHub issue BEFORE coding
4. **No direct commits to main** - All features use dedicated branches off appropriate base (main, 1.x-dev, 2.x-dev, etc.)
5. **Test coverage required** - All custom written parts of the application must have test coverage
6. **PR merges on GitHub** - All pull request merges occur on GitHub platform
7. **Always pull from origin** - Pull from origin before starting any new branch
8. **Comprehensive testing** - Testing includes functional tests, security reviews, linting, etc.
9. **Deploy after major features** - Deployment occurs after completing major feature sets
10. **Human review required** - User reviews major features and tests from human perspective before merge to main branches
11. **Use sample data** - Work with sample data during development, import real data once schema is solid

## Process Flow

1. Create GitHub issue
2. Discuss implementation strategy 
3. Pull from origin
4. Create feature branch
5. Implement with tests
6. **MANDATORY: Run ALL development checks before PR**
   - `bundle exec rspec` (full test suite)
   - `bundle exec rubocop` (linting)
   - `bundle exec brakeman` (security scan)
7. Create pull request
8. User review and testing
9. Merge on GitHub
10. Deploy (if major feature)

## GitHub Issue Label Structure

### Feature Labels
- `feature` - New functionality
- `enhancement` - Improvements to existing features
- `bug` - Bug fixes
- `security` - Security-related work

### Phase Labels
- `phase-1` - Foundation (auth, core models, collections)
- `phase-2` - Social features (showcases, discovery)
- `phase-3` - Marketplace (sales, transactions)

### Type Labels
- `backend` - Server-side work
- `frontend` - UI/UX work
- `database` - Schema/migration work

### Label Usage Guidelines
- Every issue should have at least one feature label (feature/enhancement/bug/security)
- Phase labels help organize work by development timeline
- Type labels help identify scope of work
- Use multiple labels when appropriate (e.g., `feature`, `phase-1`, `backend`)

## Development Quality Requirements

### Pre-PR Checklist (MANDATORY)
ALL of these must pass before creating any pull request:

1. **Full Test Suite**: `bundle exec rspec` 
   - All tests must pass (0 failures)
   - No skipped tests without justification
   - Verify test coverage for new code

2. **Code Linting**: `bundle exec rubocop`
   - 0 offenses detected
   - Auto-fix with `bundle exec rubocop -a` when possible
   - Manual fixes for complex offenses

3. **Security Scan**: `bundle exec brakeman`
   - No security vulnerabilities detected
   - Review any warnings carefully

### Failure to Run Checks
- **Never create PR without running all checks**
- If checks fail, fix issues before PR creation
- Document any intentional test skips or security exceptions

## Important Reminders

- Do what has been asked; nothing more, nothing less
- NEVER create files unless absolutely necessary for achieving goal
- ALWAYS prefer editing existing files to creating new ones
- NEVER proactively create documentation files unless explicitly requested

## Session Continuation Notes

### Completed Work (Issue #5: Core Models)
✅ **Complete database foundation** - All models implemented and tested
- Enhanced User model with collector profiles
- Venue model with international geocoding
- Artist, Band, Series models with search
- Poster model with complex relationships
- 224 passing tests, 0 security issues, 0 linting offenses

### Completed Work (Issue #18: User Collections & Image Management)
✅ **Complete user collections and image management system** - All features implemented and tested
- UserPoster model with status tracking (owned/wanted/watching)
- Admin poster CRUD interface with image uploads
- Active Storage configuration for local development
- Public poster browsing and detailed views
- User collection management functionality
- Comprehensive test coverage (286 tests passing)
- All quality checks passing (0 security issues, 0 linting errors)

✅ **System Testing Framework** - Integration testing infrastructure established
- Added Capybara + Selenium WebDriver for browser automation
- Created comprehensive admin poster management tests (18/18 passing)
- Created user poster management tests (19/19 passing) 
- Fixed UI vs test expectation mismatches systematically
- Separated collection (owned) from lists (want/watch) conceptually
- All model tests still passing (188), 0 security issues, 0 linting errors

✅ **User Collection Index & Navigation** - Complete user collection dashboard
- Created `app/views/user_posters/index.html.erb` for comprehensive collection overview
- Fixed homepage "Browse Collection" button to link to `/user_posters`
- Added "Collection" and "Artwork" navigation links in header
- Interactive dashboard showing owned/wanted/watching counts and items
- Grid layout for owned posters, list layout for want/watch items
- Empty state handling with links to browse artwork
- 19/19 system tests passing with new collection index tests

### Completed Work (Issue #30: Poster Visual Metadata Framework)
✅ **Complete AI-ready metadata system** - Extensible framework for poster analysis
- Added `visual_metadata` JSON column to posters table
- Comprehensive metadata structure (visual, thematic, technical, collectibility, market_appeal)
- PosterMetadataService with sample analysis framework
- Model accessor methods for nested JSON metadata access
- Rake tasks for poster analysis and batch processing
- Ready for Claude API integration (Issue #32)
- 345 tests passing, 0 security issues, 0 linting offenses

### Current Status 

#### Development Quality (All Passing)
**Current Status:** ✅ **100% Complete** - All development requirements met

- ✅ **Full Test Suite**: 345 tests passing, 0 failures
- ✅ **System Tests**: 37/37 integration tests passing
- ✅ **Linting**: 0 offenses detected
- ✅ **Security Scan**: 0 security warnings

#### Phase 1 Foundation Complete
**All Core Features Implemented:**
- User collections system (owned/wanted/watching)
- Admin poster management with image uploads
- Public poster browsing and detailed views
- Collection dashboard with comprehensive overview
- Homepage and navigation integration
- Production migration system with price normalization
- Visual metadata framework ready for AI integration
- Complete test coverage and quality assurance

#### Future Deployment Tasks
**Production Infrastructure Setup:**
- **S3 Configuration** for production image storage
  - Update `config/storage.yml` with S3 bucket configuration
  - Add AWS credentials environment variables
  - Switch production config from `:local` to `:amazon` storage
  - Add `aws-sdk-s3` gem to Gemfile
  - Configure CORS policy for direct uploads (if needed)
- **Production deployment** after Phase 2 completion

### Future Phase 3: Marketplace Features
#### Sale Tracking & Verification System
- Allow users to mark posters as "sold" with sale price (outside platform sales)
- Track unverified vs verified sales for valuation accuracy
- Verification workflow: seller enters buyer contact, system sends confirmation request
- Verified sales get higher weight in poster valuation algorithms
- Sold items remain in collection but marked as sold (not counted in collection value)

## Poster Visual Metadata System

### Overview
The poster metadata system enables AI-powered analysis and categorization of poster visual characteristics. Currently uses sample data framework, ready for Claude API integration.

### Database Schema
```ruby
# Posters table includes:
add_column :posters, :visual_metadata, :json

# JSON structure:
{
  "visual": {
    "color_palette": ["black", "white", "blue"],
    "dominant_colors": ["#000000", "#ffffff", "#4a90e2"], 
    "art_style": "minimalist",
    "composition": "centered_focal_point",
    "complexity": "simple",
    "text_density": "minimal"
  },
  "thematic": {
    "primary_themes": ["celestial", "night_sky"],
    "mood": ["peaceful", "dreamy"],
    "elements": ["moon", "clouds", "stars"],
    "genre": "nature_abstract"
  },
  "technical": {
    "layout": "portrait",
    "typography_style": "modern_sans_serif", 
    "design_era": "contemporary",
    "print_quality_indicators": ["clean_lines", "high_contrast"]
  },
  "collectibility": {
    "visual_rarity": "common_style",
    "artistic_significance": "medium",
    "design_complexity": "low", 
    "iconic_elements": ["distinctive_design"]
  },
  "market_appeal": {
    "demographic_appeal": ["millennials", "music_fans"],
    "display_context": ["bedroom", "office"],
    "frame_compatibility": "high",
    "wall_color_match": ["white", "gray", "dark_walls"]
  }
}
```

### Rake Commands
```bash
# Analyze specific poster by ID
rake "posters:analyze[1076]"

# Analyze all posters with images (batch processing)
rake posters:analyze_all

# Show stored metadata for a poster
rake "posters:show_metadata[1076]"

# Display analysis statistics and coverage
rake posters:stats
```

### Model Usage
```ruby
# Access metadata through model methods
poster = Poster.find(1076)
poster.has_metadata?              # => true/false
poster.metadata_art_style         # => "minimalist"
poster.metadata_color_palette     # => ["black", "white", "blue"]
poster.metadata_mood              # => ["peaceful", "dreamy"]
poster.metadata_themes            # => ["celestial", "night_sky"]
poster.metadata_display_context   # => ["bedroom", "office"]
poster.metadata_wall_colors       # => ["white", "gray", "dark_walls"]
```

### Service Architecture
```ruby
# Current framework (sample data)
PosterMetadataService.analyze_poster(poster)
PosterMetadataService.analyze_all_posters

# Future: Claude API integration (Issue #32)
# Will replace sample data with real AI analysis
```

### Future Features Enabled
- Visual similarity recommendations ("Find posters like this one")
- Color scheme matching for room decoration
- Mood-based browsing ("Show me calming artwork")
- Art style categorization and filtering
- Market appeal insights for collectors
- Advanced search by visual characteristics

## Documentation References

- Always refer to https://api.rubyonrails.org/ for Rails 8 documentation