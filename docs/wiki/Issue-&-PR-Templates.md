# Issue & PR Templates

## Overview

The Art Exchange uses a structured approach to GitHub issues and pull requests to maintain project organization, clear communication, and efficient development workflow. This page documents our issue labeling system, templates, and process guidelines.

## GitHub Issue Structure

### Issue Labeling System

Based on analysis of the repository's issue management, we use a comprehensive labeling system:

#### Feature Labels (Required - One Per Issue)
- **`feature`** - New functionality or capabilities
- **`enhancement`** - Improvements to existing features
- **`bug`** - Bug fixes and error corrections
- **`security`** - Security-related work and improvements

#### Phase Labels (Development Timeline)
- **`phase-1`** - Foundation (authentication, core models, collections)
- **`phase-2`** - Social features (showcases, discovery, enhanced search)
- **`phase-3`** - Marketplace (sales, transactions, AI valuations)

#### Type Labels (Work Scope)
- **`backend`** - Server-side work (models, controllers, services)
- **`frontend`** - UI/UX work (views, styling, JavaScript)
- **`database`** - Schema changes, migrations, data work

#### Priority Labels
- **`high`** - Critical issues blocking development or production
- **`medium`** - Important features for current development phase
- **`low`** - Nice-to-have features or minor improvements

### Label Usage Guidelines

Every issue should have:
- ✅ **At least one feature label** (feature/enhancement/bug/security)
- ✅ **Phase label** for development timeline organization
- ✅ **Type labels** to identify scope of work (can have multiple)
- ✅ **Priority level** based on importance and urgency

Example label combinations:
- `feature` + `phase-1` + `backend` + `high`
- `enhancement` + `phase-2` + `frontend` + `medium`
- `bug` + `phase-1` + `database` + `high`

## Issue Templates

### Feature Request Template

```markdown
## Feature Description
Brief description of the new feature or capability.

## Problem Statement
What problem does this feature solve? What user need does it address?

## Proposed Solution
Detailed description of how this feature should work.

### User Stories
- As a [user type], I want [functionality] so that [benefit]
- As a [user type], I want [functionality] so that [benefit]

### Acceptance Criteria
- [ ] Specific, testable requirement 1
- [ ] Specific, testable requirement 2
- [ ] Specific, testable requirement 3

## Technical Approach
High-level technical implementation strategy.

### Models/Database Changes
- [ ] New models needed
- [ ] Database migrations required
- [ ] Relationship changes

### Controllers/Routes
- [ ] New controllers/actions
- [ ] Route changes
- [ ] Authentication/authorization requirements

### Views/Frontend
- [ ] New pages/components
- [ ] UI/UX considerations
- [ ] JavaScript/Stimulus controllers

### Testing Requirements
- [ ] Model tests
- [ ] Request tests
- [ ] System/integration tests
- [ ] Security considerations

## Dependencies
- Related issues or features that must be completed first
- External dependencies (APIs, gems, services)

## Definition of Done
- [ ] Feature implemented and working
- [ ] All tests passing (./bin/checks)
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] User testing completed

## Labels
`feature` `phase-X` `backend/frontend` `priority-level`
```

### Bug Report Template

```markdown
## Bug Description
Clear, concise description of the bug.

## Steps to Reproduce
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Expected Behavior
What should happen instead.

## Actual Behavior
What actually happens, including error messages.

## Environment
- **Browser**: [e.g. Chrome 91, Safari 14]
- **Device**: [e.g. iPhone 12, MacBook Pro]
- **OS**: [e.g. iOS 14.6, macOS 11.4]
- **Rails Environment**: [development/staging/production]

## Error Details
```
Paste any error messages, stack traces, or relevant log output here
```

## Screenshots
If applicable, add screenshots to help explain the problem.

## Possible Solution
If you have suggestions for fixing the bug.

## Related Issues
Link to related issues or PRs.

## Labels
`bug` `phase-X` `backend/frontend` `priority-level`
```

### Enhancement Template

```markdown
## Enhancement Description
Description of the improvement to existing functionality.

## Current Behavior
How the feature currently works.

## Proposed Improvement
Detailed description of the proposed enhancement.

## Benefits
- Why this improvement is valuable
- What problems it solves
- How it improves user experience

## Implementation Details
Technical approach for implementing the enhancement.

### Changes Required
- [ ] Model changes
- [ ] Controller modifications
- [ ] View updates
- [ ] Database modifications
- [ ] Configuration changes

### Testing Strategy
- [ ] Existing tests to update
- [ ] New tests required
- [ ] Regression testing considerations

## Backward Compatibility
How this change affects existing functionality and data.

## User Impact
How this change affects current users and workflows.

## Labels
`enhancement` `phase-X` `backend/frontend` `priority-level`
```

## Pull Request Templates

### Standard PR Template

```markdown
## Summary
Brief description of the changes in this PR.

## Related Issue
Closes #[issue-number]

## Changes Made
### Backend Changes
- [ ] Model changes: [description]
- [ ] Controller changes: [description]
- [ ] Service/business logic: [description]
- [ ] Database migrations: [description]

### Frontend Changes
- [ ] View updates: [description]
- [ ] Styling changes: [description]
- [ ] JavaScript/Stimulus: [description]

### Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] System tests added/updated
- [ ] Manual testing completed

## Quality Checklist
**All items must be checked before requesting review:**

- [ ] `bundle exec rspec` - All tests passing (0 failures)
- [ ] `bundle exec rubocop` - No linting violations (0 offenses)
- [ ] `bundle exec brakeman` - No security warnings
- [ ] `bundle exec bundle-audit` - No dependency vulnerabilities
- [ ] Manual testing completed for changed functionality
- [ ] Code follows project style guidelines
- [ ] Documentation updated (if needed)

## Testing Instructions
Step-by-step instructions for testing this PR:

1. Check out this branch: `git checkout feature/branch-name`
2. Run setup: `bundle install && rails db:migrate`
3. Test scenario 1: [specific steps]
4. Test scenario 2: [specific steps]
5. Verify expected outcomes

## Screenshots/Videos
If applicable, add screenshots or videos demonstrating the changes.

## Breaking Changes
- [ ] This PR introduces breaking changes
- [ ] Database migration required
- [ ] Configuration changes required
- [ ] Deployment steps documented

## Deployment Notes
Special considerations for deploying this change:
- Environment variable changes
- Database migration requirements
- Cache clearing needs
- Service restart requirements

## Additional Context
Any additional information reviewers should know.
```

### Hotfix PR Template

```markdown
## 🚨 HOTFIX: [Brief Description]

## Critical Issue
Description of the critical issue being fixed.

## Root Cause
What caused this issue and why it's critical.

## Solution
How this hotfix resolves the issue.

## Testing
- [ ] Issue reproduced in development
- [ ] Fix verified to resolve issue
- [ ] No regression testing completed (if emergency)
- [ ] Full testing completed (if time permits)

## Risk Assessment
- **Risk Level**: [Low/Medium/High]
- **Potential Side Effects**: [Description]
- **Rollback Plan**: [How to rollback if needed]

## Deployment Priority
- [ ] Deploy immediately
- [ ] Deploy within 24 hours
- [ ] Deploy with next release

## Follow-up Actions
- [ ] Create issue for root cause analysis
- [ ] Create issue for comprehensive testing
- [ ] Create issue for long-term solution

## Emergency Approval
In case of emergency, this hotfix can be merged with single approval.

**Justification**: [Reason for emergency process]
```

## Issue Management Workflow

### Issue Creation Process

1. **Search Existing Issues** - Check if similar issue already exists
2. **Choose Appropriate Template** - Use feature/bug/enhancement template
3. **Add Required Labels** - Feature type + phase + scope + priority
4. **Assign to Project Board** - Add to appropriate development phase
5. **Link Related Issues** - Reference dependent or related issues

### Issue Lifecycle

```
📝 Open Issue (with labels and template)
    ↓
🗣️ Discussion & Strategy Planning
    ↓
🏗️ Implementation (assign to developer)
    ↓
🔍 Code Review & Testing
    ↓
✅ Completed & Closed
```

### Issue Status Tracking

We use GitHub project boards to track issue progress:

#### Phase 1 Board
- **Backlog** - Planned features not yet started
- **In Progress** - Currently being worked on
- **Review** - Code complete, in review process
- **Testing** - Manual testing and validation
- **Done** - Completed and deployed

#### Issue Assignment
- **Assign to developer** when work begins
- **Update progress** with comments and updates
- **Link to PR** when implementation starts
- **Close when completed** with reference to completing PR

## Pull Request Workflow

### PR Creation Process

1. **Create feature branch** from main
2. **Implement changes** with tests
3. **Run quality checks** (`./bin/checks`)
4. **Create PR** with appropriate template
5. **Request review** from team members
6. **Address feedback** promptly
7. **Merge** after approval and CI passing

### PR Review Guidelines

#### For Authors
- **Self-review first** - Review your own code before requesting review
- **Complete template** - Fill out all relevant sections
- **Test thoroughly** - Manual testing beyond automated tests
- **Document changes** - Clear commit messages and PR description

#### For Reviewers
- **Check functionality** - Does it work as intended?
- **Review tests** - Comprehensive test coverage?
- **Code quality** - Follows style guidelines?
- **Security** - No security vulnerabilities?
- **Performance** - Any performance implications?

### PR Merge Requirements

**All PRs must meet these criteria before merge:**

- [ ] All quality checks passing (`./bin/checks`)
- [ ] At least one approval from team member
- [ ] CI/CD pipeline passing
- [ ] Manual testing completed
- [ ] Documentation updated (if applicable)
- [ ] Breaking changes documented
- [ ] Linked issue requirements met

## Examples from The Art Exchange

### Example Feature Issue

**Issue #5: Core Models**
```
Labels: feature, phase-1, backend, high
Title: "Implement core database models for poster marketplace"

✅ Complete template with:
- Detailed user stories for poster management
- Comprehensive acceptance criteria
- Technical implementation plan
- Testing requirements
- Definition of done checklist
```

### Example Enhancement Issue

**Issue #30: Poster Visual Metadata Framework**
```
Labels: enhancement, phase-1, backend, medium
Title: "Add visual metadata JSON column to posters"

✅ Clear enhancement description:
- Current state analysis
- Proposed improvements with AI integration
- Technical implementation strategy
- Future extensibility considerations
```

### Example Bug Issue

**Issue #25: Login Feedback for Unconfirmed Accounts**
```
Labels: bug, phase-1, frontend, medium
Title: "Silent failure when unconfirmed users try to login"

✅ Comprehensive bug report:
- Clear reproduction steps
- Expected vs actual behavior
- User experience impact
- Proposed solution approach
```

## Automation and Templates

### GitHub Issue Templates

Create `.github/ISSUE_TEMPLATE/` directory with:
- `feature_request.md`
- `bug_report.md`
- `enhancement.md`

### PR Template

Create `.github/pull_request_template.md` with standard template.

### Automated Labels

Use GitHub Actions or bots to:
- Auto-assign labels based on file changes
- Check PR template completion
- Validate quality check requirements
- Update project boards automatically

---

*This structured approach to issues and PRs ensures clear communication, efficient development workflow, and maintains high code quality throughout the project lifecycle.*