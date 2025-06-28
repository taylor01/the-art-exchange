# Development Workflow

## Overview

The Art Exchange follows a structured, quality-focused development workflow designed to ensure code stability, comprehensive testing, and maintainable growth. This workflow emphasizes **one feature at a time**, **comprehensive testing**, and **human review** before any code reaches production.

*For complete rules and guidelines, see [CLAUDE.md](../blob/main/CLAUDE.md) in the repository.*

## Core Development Rules

### 1. Feature-Driven Development
- **One feature at a time** - Complete each feature before starting the next
- **GitHub issue required** - Create and document every piece of work
- **Strategy discussion** - Plan the implementation approach before coding
- **Test coverage required** - All custom code must have comprehensive tests

### 2. Branch Management
- **No direct commits to main** - All work uses dedicated feature branches
- **Always pull from origin** - Start each branch from the latest main
- **Never do dev work on main branch** - Always use feature/fix/hotfix branches

### 3. Quality Assurance
- **Comprehensive testing** - Functional tests, security reviews, linting
- **Human review required** - All features reviewed before merge to main
- **PR merges on GitHub** - All merges happen on the GitHub platform

## Complete Development Process

### Step 1: Issue Creation
Every piece of work starts with a GitHub issue:

```bash
# Before any code work
1. Create GitHub issue documenting:
   - Problem or feature description
   - Acceptance criteria
   - Implementation approach
   - Testing requirements
```

### Step 2: Strategy Discussion
Before writing code, discuss the implementation strategy:
- Review the issue requirements
- Confirm technical approach
- Identify potential challenges
- Plan testing strategy

### Step 3: Branch Setup
```bash
# Always start from main
git checkout main
git pull origin main

# Create appropriate branch
git checkout -b feature/descriptive-feature-name
git checkout -b fix/specific-bug-description
git checkout -b hotfix/critical-issue-name
```

### Step 4: Implementation with Tests
Write code following our quality standards:
- **Follow existing patterns** - Match the codebase conventions
- **Write tests first or alongside** - Don't skip test coverage
- **Use existing libraries** - Check what's already available
- **Security first** - Never introduce vulnerabilities

### Step 5: Mandatory Quality Checks
**CRITICAL**: Run all checks before creating any PR:

```bash
# Use the comprehensive check script
./bin/checks

# OR run individually:
bundle exec rspec        # All tests must pass (0 failures)
bundle exec rubocop      # 0 linting offenses
bundle exec brakeman     # 0 security warnings
bundle exec bundle-audit # 0 vulnerability warnings
```

**❌ NEVER create a PR without running these checks**
**❌ If any check fails, fix issues before PR creation**

### Step 6: Create Pull Request
```bash
# Push your branch
git push origin feature/your-feature-name

# Create PR via GitHub with:
# - Clear title referencing the issue
# - Description linking to GitHub issue
# - Summary of changes made
# - Testing notes
```

### Step 7: Review Process
- **User review required** - All features get human review
- **Test from user perspective** - Verify functionality works as expected
- **Code review** - Check implementation quality and patterns

### Step 8: Merge and Deploy
- **Merge on GitHub** - Use GitHub's merge functionality
- **Deploy after major features** - Production deployment for feature sets
- **Monitor deployment** - Verify production functionality

## GitHub Issue Management

### Label Structure

#### Feature Labels (Required)
- `feature` - New functionality
- `enhancement` - Improvements to existing features  
- `bug` - Bug fixes
- `security` - Security-related work

#### Phase Labels (Development Timeline)
- `phase-1` - Foundation (auth, core models, collections)
- `phase-2` - Social features (showcases, discovery)
- `phase-3` - Marketplace (sales, transactions)

#### Type Labels (Work Scope)
- `backend` - Server-side work
- `frontend` - UI/UX work
- `database` - Schema/migration work

### Label Usage Guidelines
```
Every issue should have:
✅ At least one feature label (feature/enhancement/bug/security)
✅ Phase label for development timeline organization
✅ Type labels to identify scope of work
✅ Multiple labels when appropriate

Example: feature + phase-2 + backend + frontend
```

## Pre-PR Quality Requirements

### 1. Full Test Suite ✅
```bash
bundle exec rspec
# Required: All tests passing (0 failures)
# Required: No skipped tests without justification
# Required: Test coverage for all new code
```

### 2. Code Linting ✅
```bash
bundle exec rubocop
# Required: 0 offenses detected
# Use: bundle exec rubocop -a (auto-fix when possible)
# Manual fixes required for complex offenses
```

### 3. Security Scan ✅
```bash
bundle exec brakeman
# Required: No security vulnerabilities detected
# Required: Review any warnings carefully
# Document any intentional security exceptions
```

### 4. Dependency Security ✅
```bash
bundle exec bundle-audit
# Required: No known vulnerabilities in dependencies
# Update gems if vulnerabilities found
```

## Branch Naming Conventions

### Feature Branches
```bash
feature/user-authentication-system
feature/poster-search-functionality
feature/collection-management
```

### Bug Fix Branches
```bash
fix/login-error-handling
fix/image-upload-validation
fix/search-results-pagination
```

### Hotfix Branches (Critical Issues)
```bash
hotfix/security-vulnerability-patch
hotfix/production-error-fix
```

## Commit Message Guidelines

### Format
```
Type: Brief description (50 chars or less)

Optional longer description explaining the change,
why it was needed, and how it addresses the issue.

Closes #123 (reference GitHub issue)
```

### Types
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code formatting changes
- `refactor:` Code restructuring without feature changes
- `test:` Adding or updating tests
- `security:` Security improvements

### Examples
```bash
feat: Add OTP authentication system

Implements passwordless login using one-time codes sent via email.
Includes rate limiting and secure token generation.

Closes #4

fix: Resolve image upload validation error

Fixes issue where large images were incorrectly rejected.
Updated file size validation and error messaging.

Closes #25
```

## Code Review Guidelines

### For Authors
- **Self-review first** - Review your own code before requesting review
- **Clear PR description** - Explain what was changed and why
- **Reference issues** - Link to the GitHub issue being addressed
- **Include testing notes** - How to test the changes
- **Address feedback promptly** - Respond to review comments quickly

### For Reviewers
- **Check functionality** - Does it work as intended?
- **Review tests** - Are tests comprehensive and passing?
- **Code quality** - Does it follow existing patterns?
- **Security** - Any potential security issues?
- **Performance** - Any performance implications?

## Testing Strategy

### Test Types Required

#### 1. Model Tests (Unit Tests)
```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  it "validates presence of email" do
    user = User.new(email: nil)
    expect(user).not_to be_valid
  end
end
```

#### 2. Request Tests (API Tests)
```ruby
# spec/requests/posters_spec.rb  
RSpec.describe "Posters", type: :request do
  it "returns poster list" do
    get "/posters"
    expect(response).to have_http_status(200)
  end
end
```

#### 3. System Tests (Integration Tests)
```ruby
# spec/system/poster_management_spec.rb
RSpec.describe "Poster Management", type: :system do
  it "allows admin to create poster" do
    visit "/admin/posters/new"
    fill_in "Title", with: "Test Poster"
    click_button "Create Poster"
    expect(page).to have_content("Poster created")
  end
end
```

### Test Coverage Requirements
- **New models**: 100% method coverage
- **New controllers**: All actions tested
- **New features**: End-to-end system tests
- **Bug fixes**: Regression tests to prevent reoccurrence

## Common Development Patterns

### Adding New Models
```bash
# 1. Generate model with migration
rails generate model ModelName attribute:type

# 2. Review and edit migration
# 3. Run migration
rails db:migrate

# 4. Add model tests
# 5. Add any necessary associations
# 6. Run quality checks
./bin/checks
```

### Adding New Features
```bash
# 1. Create GitHub issue
# 2. Create feature branch
# 3. Add routes (if needed)
# 4. Add controller actions
# 5. Add views
# 6. Add tests for all components
# 7. Run quality checks
# 8. Create PR
```

## Environment-Specific Guidelines

### Development Environment
- **Use sample data** - Work with test data during development
- **Local database** - PostgreSQL running locally
- **Environment variables** - Use .env file for configuration
- **Hot reloading** - Use ./bin/dev for automatic reloading

### Testing Environment
- **Isolated data** - Each test run uses clean database
- **Consistent state** - Tests should not depend on each other
- **Fast execution** - Tests should run quickly for developer feedback

### Production Environment  
- **Real data import** - Import production data once schema is solid
- **Environment secrets** - Use secure environment variable management
- **Monitoring** - Track application performance and errors

## Deployment Process

### Pre-Deployment Checklist
- [ ] All tests passing in CI
- [ ] Security scan completed
- [ ] Human testing completed
- [ ] Database migrations reviewed
- [ ] Environment variables updated (if needed)

### Deployment Steps
1. **Merge to main** - Via GitHub pull request
2. **Verify CI passes** - All automated checks complete
3. **Deploy to production** - Using deployment pipeline
4. **Run post-deployment checks** - Verify functionality
5. **Monitor for issues** - Watch logs and metrics

## Emergency Procedures

### Hotfix Process
For critical production issues:

```bash
# 1. Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-issue-description

# 2. Implement minimal fix
# 3. Test thoroughly
# 4. Run quality checks (may skip some for critical issues)
# 5. Create PR with "HOTFIX" label
# 6. Fast-track review and deployment
```

### Rollback Process
If deployment issues occur:
1. **Identify the issue** - Determine scope and impact
2. **Revert deployment** - Use deployment tool rollback
3. **Investigate root cause** - Debug in development environment
4. **Create proper fix** - Follow normal development process
5. **Re-deploy with fix** - Ensure issue is resolved

---

*This workflow ensures high code quality, comprehensive testing, and maintainable development practices. For specific implementation details, see [CLAUDE.md](../blob/main/CLAUDE.md).*