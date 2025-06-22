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
6. Run full test suite (functional, security, linting)
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

## Important Reminders

- Do what has been asked; nothing more, nothing less
- NEVER create files unless absolutely necessary for achieving goal
- ALWAYS prefer editing existing files to creating new ones
- NEVER proactively create documentation files unless explicitly requested