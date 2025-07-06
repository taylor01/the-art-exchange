🚀 Intelligent Setlist Import Implementation Roadmap

  Current Status: Phase 1 Complete ✅ | Phase 2 Ready 🎯 | 88% to
  Compaction Milestone

  📍 Where We Are Now

  Completed Foundation (Phase 1)

  - ✅ Venue Research System: 179+ venues researched with Claude AI
  - ✅ Historical Names Database: venue_names table with date ranges for
  venue name changes
  - ✅ Rails 8 SolidQueue: Background job infrastructure working with
  proper environment variables
  - ✅ Venue Management UI: Complete venues index/show pages with research
   status tracking
  - ✅ Legacy Code Cleanup: Removed VenueMatchingService and
  ClaudeVenueMatchingService
  - ✅ Clean Workspace: Commit d8ce205 marks clean foundation for new
  system

  Current Data State

  - 208 total venues in database (from existing poster data)
  - 179+ venues successfully researched with Claude (85%+ completion rate)
  - Historical venue names discovered: Examples include:
    - PNC Music Pavilion: Blockbuster Pavilion → Verizon Wireless
  Amphitheatre → PNC Music Pavilion
    - Multiple venue name changes across decades tracked with date ranges
  - 1,086 DMB setlist files ready for import in
  tools/dmb_scraper/setlists/
  - Clean database state with proper foreign key relationships

  🎯 Active Phase: Phase 2 - Pre-Import Analysis

  Immediate Next Steps (Next 1-2 Sessions)

  Step 1: Build SetlistVenueAnalyzer Service

  # Location: app/services/setlist_venue_analyzer.rb
  class SetlistVenueAnalyzer
    def analyze_all_setlists
      # Extract unique venue/location combinations from 1,086 JSON files
      # Match against venue_names table (our research data)
      # Categorize by confidence: exact, fuzzy, new, ambiguous
      # Generate venue_mapping_analysis.json
    end

    private

    def extract_venues_from_setlists
      # Parse all JSON files in tools/dmb_scraper/setlists/
      # Extract venue + location combinations
      # Deduplicate and count occurrences
    end

    def match_against_venue_research
      # Query venue_names table for exact matches
      # Use PostgreSQL trigram similarity for fuzzy matches
      # Categorize by confidence levels
    end
  end

  Step 2: Implement Venue Matching Logic

  - Tier 1: Exact match against venue_names.name + city/state
  - Tier 2: Trigram similarity matching (80%+ confidence threshold)
  - Tier 3: Flag for Claude consultation (ambiguous cases)
  - Tier 4: Mark as new venue creation needed

  Step 3: Generate Venue Mapping JSON

  - Output file: venue_mapping_analysis.json
  - Structure: As detailed in previous response
  - Content: Complete mapping for all 1,086 setlists to venue decisions

  Expected Phase 2 Deliverables

  1. SetlistVenueAnalyzer service - Complete venue analysis capability
  2. Venue mapping JSON file - Definitive import plan for all setlists
  3. Analysis report - Statistics on match confidence distribution
  4. Manual review queue - Ambiguous cases requiring human/Claude review

  🔄 Upcoming Phases (Next 3-5 Sessions)

  Phase 3: Intelligent Venue Matching Service

  # Location: app/services/intelligent_venue_matching_service.rb
  class IntelligentVenueMatchingService
    def find_venue_for_setlist(setlist_venue_name, location, show_date)
      # Use pre-generated venue mapping for instant lookups
      # Handle edge cases not covered by pre-analysis
      # Provide consistent interface for import service
    end
  end

  Phase 4: Staged Import Process

  # Location: app/services/staged_setlist_import_service.rb  
  class StagedSetlistImportService
    def import_all_with_intelligence
      # Stage 1: Parallel import of exact matches (~800 setlists)
      # Stage 2: Parallel import of fuzzy matches (~150 setlists) 
      # Stage 3: Sequential import with new venue creation (~100 setlists)
      # Stage 4: Sequential import with Claude consultation (~36 setlists)
    end
  end

  Phase 5: Database Safety & Race Condition Prevention

  - Unique constraints: Prevent duplicate venue creation
  - Advisory locks: City-based locking for venue creation
  - Upsert operations: Safe concurrent venue creation

  Phase 6: Testing & Validation

  - Dry-run capability: Test import without database changes
  - Performance benchmarks: Target <30 minutes for full import
  - Data validation: Verify no duplicate venues created
  - Manual verification: Sample accuracy checking

  💾 Critical Context & Data

  Database Schema Dependencies

  -- Core tables for venue intelligence
  venues(id, name, city, administrative_area, research_status,
  research_confidence)
  venue_names(venue_id, name, start_date, end_date, current)
  shows(band_id, venue_id, show_date)
  setlist_songs(show_id, song_id, set_type, position)

  -- Indexes for performance
  CREATE INDEX ON venue_names USING gin(name gin_trgm_ops);
  CREATE INDEX ON venues(city, administrative_area);

  Key Configuration Files

  - SolidQueue: config/solid_queue.yml - Background job processing
  - Procfile.dev: jobs: op run --env-file=.env -- bin/rails 
  solid_queue:start
  - Environment: 1Password integration for Claude API access
  - Routes: Venue management at /venues with research status

  File Locations & Structure

  app/
  ├── services/
  │   ├── setlist_import_service.rb           # Legacy, needs refactoring
  │   └── setlist_venue_analyzer.rb           # Next to build
  ├── jobs/
  │   ├── venue_research_job.rb               # Working Claude research
  │   └── claude_venue_matching_job.rb        # Temporarily disabled
  ├── models/
  │   ├── venue.rb                            # Core venue model
  │   ├── venue_name.rb                       # Historical names
  │   └── show.rb                             # Setlist show data
  └── controllers/
      └── venues_controller.rb                # Venue management UI

  tools/dmb_scraper/setlists/                 # 1,086 JSON files ready

  🧠 Technical Knowledge & Patterns

  Venue Research System Architecture

  - VenueResearchJob: Comprehensive Claude research with confidence
  ratings
  - venue_names table: Historical venue names with date ranges
  - Research status tracking: pending/in_progress/completed/failed
  - Claude API integration: Using claude-3-haiku-20240307 model

  Import Strategy Insights

  - Poster date matching: If setlist date = poster.release_date, use
  poster.venue
  - Historical name priority: Match against venue_names first, then
  current venue names
  - Race condition scenarios: Multiple setlists referencing same
  historical venue name
  - Performance targets: <30 minutes total, >95% accuracy, zero duplicates

  Rails 8 & SolidQueue Specifics

  - Background job command: bin/rails solid_queue:start (not bundle exec)
  - Environment variable inheritance: Works with op run --env-file=.env
  wrapper
  - Job processing: Currently 179+ venue research jobs completed
  successfully
  - Queue monitoring: Available at venues UI with real-time status

  🔧 Development Environment Setup

  Required Tools & Access

  - 1Password CLI: For Claude API key access (op run --env-file=.env)
  - PostgreSQL: With pg_trgm extension for fuzzy matching
  - Claude API: Anthropic API key in 1Password environment
  - Rails 8: With SolidQueue, Solid Cache, Solid Cable
  - Git branch: feature/dmb-setlist-integration

  Critical Commands

  # Start development environment
  op run --env-file=.env -- bin/dev

  # Test venue research system
  op run --env-file=.env -- bin/rails runner 'puts 
  Venue.where(research_status: "completed").count'

  # Monitor background jobs
  op run --env-file=.env -- bin/rails runner 'puts 
  SolidQueue::ReadyExecution.count'

  # Run venue research manually
  op run --env-file=.env -- bin/rails runner
  'VenueResearchJob.perform_now(venue_id)'

  📋 GitHub Issue Tracking

  Active Issue

  - Issue #89: "Implement Intelligent Setlist Import with Venue Knowledge
  Base Integration"
  - URL: https://github.com/taylor01/the-art-exchange/issues/89
  - Status: Phase 1 complete, Phase 2 in progress

  Commit History

  - Latest: d8ce205 - Phase 1: Remove legacy venue matching services
  - Foundation: 64e9abc - Implement comprehensive venue research system

  🎯 Success Metrics & Targets

  Phase 2 Success Criteria

  - All 1,086 setlist files analyzed and categorized
  - Venue mapping JSON generated with <5% ambiguous cases
  - 80%+ setlists have exact historical name matches
  - Clear import execution plan with time estimates

  Overall Project Success

  - Zero duplicate venues created during import
  - 95%+ venue matching accuracy validated
  - <30 minutes total import time for 1,086 setlists
  - All shows properly associated with correct venues

  🚨 Risks & Mitigation Strategies

  Technical Risks

  1. Claude API rate limiting: Only use for ambiguous cases (<5% of
  setlists)
  2. Database performance: Proper indexing on venue_names for fast lookups
  3. Race conditions: Pre-analysis prevents most issues, database
  constraints as backup

  Data Quality Risks

  1. Historical name accuracy: Date range validation in venue_names
  2. Fuzzy match false positives: Conservative confidence thresholds
  (80%+)
  3. New venue identification: Manual review queue for edge cases

  🔄 Context Preservation Strategy

  What You Need to Remember

  1. Current momentum: Successfully completed complex venue research
  system
  2. Clean foundation: Legacy code removed, new architecture ready
  3. Data richness: 179+ venues with comprehensive historical names
  4. Technical approach: Pre-analysis → mapping → staged import
  5. Performance focus: Parallel processing with race condition safety

  Key Patterns Established

  - Plan → Analyze → Document → Confirm → Implement step-by-step
  - Validate application boots after each change
  - Use venue research data as primary source of truth
  - Prioritize exact matches for speed, sequential processing for safety

  Next Session Starter

  "Continue with Phase 2: Pre-Import Analysis. Build the 
  SetlistVenueAnalyzer service to analyze all 1,086 setlist files and 
  generate the venue mapping JSON. We have 179+ venues researched with 
  historical names in the venue_names table ready to match against."

  ---
  🎯 Current Status: 88% to Compaction | Phase 1 Complete | Phase 2 Active
   | Momentum Strong

  This document captures everything needed to maintain momentum on the
  intelligent setlist import system. The foundation is solid, the path is
  clear, and the next steps are well-defined. 🚀