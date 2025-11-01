# Claude Code Configuration

This file configures Claude Code behavior for both automated code review and AI-assisted fixes in this repository.

## Code Review Guidelines

### Focus Areas

When reviewing pull requests, prioritize these areas:

1. **Security Vulnerabilities**
   - SQL injection risks
   - XSS vulnerabilities
   - Authentication/authorization flaws
   - Exposed secrets or sensitive data
   - CSRF vulnerabilities

2. **Potential Bugs**
   - Null pointer exceptions
   - Race conditions
   - Off-by-one errors
   - Unhandled edge cases
   - Resource leaks (file handles, connections)

3. **Code Quality**
   - Overly complex functions (cyclomatic complexity)
   - Code duplication
   - Poor naming conventions
   - Missing error handling
   - Inadequate input validation

4. **Performance Concerns**
   - N+1 query problems
   - Unnecessary loops or iterations
   - Inefficient algorithms
   - Memory leaks
   - Blocking operations on main thread

### Review Severity Levels

Use these severity levels for comments:

- **Critical**: Security vulnerabilities, data loss risks, breaking changes
- **Warning**: Potential bugs, performance issues, best practice violations
- **Info**: Code style, documentation suggestions, minor improvements

### Files to Ignore

Skip review for these file types:

- Test files: `*.test.*`, `*.spec.*`
- Generated files: `*.generated.*`, `dist/`, `build/`
- Documentation: `*.md` (unless specifically requested)
- Lock files: `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`
- Configuration: `.env.example` (but review actual .env if exposed)

### Review Comment Format

Structure comments as:

```
[Severity] [Category]

[Description of the issue]

[Explanation of why it's a problem]

Suggestion:
```[language]
[Proposed fix code]
```

[Additional context if needed]
```

Example:

```
⚠️ Potential Bug

Line 42: `user.profile.email` could be null if profile is undefined.

This will throw a runtime error when profile doesn't exist, breaking the user experience.

Suggestion:
```javascript
const email = user?.profile?.email ?? 'no-email';
```

Consider also validating the user object earlier in the flow.
```

## AI Fix Guidelines

### Code Style Standards

When applying fixes, follow these conventions:

#### JavaScript/TypeScript
- Use 2-space indentation
- Prefer `const` over `let`, avoid `var`
- Use arrow functions for callbacks
- Add JSDoc comments for exported functions
- Use async/await over promises where possible
- Prefer template literals over string concatenation

#### Python
- Follow PEP 8 style guide
- Use 4-space indentation
- Add type hints for function signatures
- Use descriptive variable names
- Prefer list comprehensions where readable

#### General
- Keep functions under 50 lines
- One responsibility per function
- Extract magic numbers to named constants
- Add comments for complex logic only

### Safety Rules

**Never:**
- Delete existing tests
- Remove error handling
- Bypass authentication/authorization
- Disable security features
- Hard-code credentials or secrets
- Make breaking API changes without discussion

**Always:**
- Validate all inputs
- Preserve existing error handling
- Add null/undefined checks
- Use parameterized queries for SQL
- Escape user input in HTML
- Follow the principle of least privilege

### Fix Prioritization

When applying multiple fixes:

1. **Security issues** - Fix immediately
2. **Critical bugs** - Fix immediately
3. **Performance issues** - Fix if straightforward
4. **Code quality** - Fix if low risk
5. **Style issues** - Fix if consistent with codebase

### Testing Requirements

After applying fixes:

- Ensure all existing tests still pass
- Add new tests for fixed bugs if missing
- Consider edge cases in the fix
- Verify fix doesn't introduce new issues

## Commit Message Format

Use conventional commit format:

```
<type>: <description>

[optional body]

Triggered-By: @<username> in #<pr-number>
Reference: <comment-url>

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Commit Types

- `fix:` - Bug fixes
- `feat:` - New features
- `refactor:` - Code refactoring
- `perf:` - Performance improvements
- `style:` - Code style changes (formatting)
- `test:` - Adding or updating tests
- `docs:` - Documentation changes
- `chore:` - Maintenance tasks

### Commit Message Examples

```
fix: add null check in user authentication

Prevents null pointer exception when user profile is undefined.

Triggered-By: @developer in #123
Reference: https://github.com/org/repo/pull/123#issuecomment-456
Co-Authored-By: Claude <noreply@anthropic.com>
```

```
perf: optimize database query in getUserOrders

Replaced N+1 query pattern with single JOIN query, reducing
database calls from 100+ to 1.

Triggered-By: @developer in #124
Reference: https://github.com/org/repo/pull/124#issuecomment-789
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Project-Specific Context

### Technology Stack

- **Frontend**: React, Next.js, TypeScript
- **Backend**: Node.js, Express (or Python, Flask/FastAPI)
- **Database**: PostgreSQL (or your database)
- **Testing**: Jest, React Testing Library (frontend), pytest (backend)

### Architecture Patterns

- Follow component-based architecture for frontend
- Use repository pattern for data access
- Implement proper error boundaries
- Use dependency injection where applicable

### Business Logic Considerations

- Always validate permissions before data access
- Log important actions for audit trail
- Handle errors gracefully with user-friendly messages
- Consider rate limiting for API endpoints
- Implement proper pagination for list endpoints

## Review Process Integration

### For Reviewers (Humans)

After Claude's automated review:

1. Focus on business logic and requirements
2. Verify Claude's suggestions are appropriate
3. Check for false positives
4. Add context Claude might have missed

### For Contributors

1. Address critical and warning issues first
2. Use `@claude apply` for straightforward fixes
3. Discuss with team for complex issues
4. Request human review after AI fixes applied

## Continuous Improvement

This configuration file should evolve with the project:

- Add project-specific patterns as they emerge
- Update severity levels based on team feedback
- Refine focus areas as priorities change
- Document common false positives to avoid

## Questions or Issues?

If Claude's behavior needs adjustment:

1. Update this file with new guidelines
2. Test with a sample PR
3. Iterate based on results
4. Share learnings with the team

---

**Last Updated**: 2025-01-01
**Review Frequency**: Quarterly or as needed
