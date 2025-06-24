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

### Next Session Priorities (Issue #6: User Collections & Image Management)

#### High Priority UI Tasks
1. **Poster Management Interface**
   - Create poster form (new/edit)
   - Poster detail/show pages
   - Basic poster listing/index

2. **Image Upload System**
   - Active Storage integration
   - Image upload forms
   - Image display and management

3. **Collection Management**
   - User collection interface
   - Add posters to collections
   - Collection browsing

#### Technical Considerations
- Use existing Tailwind CSS styling patterns
- Follow Stimulus controller patterns for JavaScript
- Maintain test coverage for new features
- Consider mobile-first responsive design

#### Questions to Address Tomorrow
- Image storage strategy (local vs S3 for development)
- Collection ownership model (individual vs shared)
- Admin vs user poster creation workflow
- Search/filter UI implementation priority

### Future Phase 3: Marketplace Features
#### Sale Tracking & Verification System
- Allow users to mark posters as "sold" with sale price (outside platform sales)
- Track unverified vs verified sales for valuation accuracy
- Verification workflow: seller enters buyer contact, system sends confirmation request
- Verified sales get higher weight in poster valuation algorithms
- Sold items remain in collection but marked as sold (not counted in collection value)

## Documentation References

- Always refer to https://api.rubyonrails.org/ for Rails 8 documentation