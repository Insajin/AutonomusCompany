# PR Code Review Workflow Contract

**Workflow File**: `.github/workflows/pr-review.yml`
**Primary Goal**: Automatically review pull requests using Claude Code (OAuth) within 2 minutes

## Trigger Events

```yaml
on:
  pull_request:
    types: [opened]  # Only on PR creation, not updates
```

**Rationale**: Reviewing on every commit would be expensive and noisy. Initial review catches most issues, developers can request re-review via comment.

## Inputs

### From GitHub Context
- `github.event.pull_request.number` - PR number
- `github.event.pull_request.title` - PR title
- `github.event.pull_request.body` - PR description
- `github.event.pull_request.head.ref` - Source branch
- `github.repository` - Repository full name

### From Repository Files
- `.github/CLAUDE.md` - Custom review guidelines (optional)
- Changed files diff (via `git diff`)

### From Secrets
- `CLAUDE_CODE_OAUTH_TOKEN` - OAuth token from Claude Max subscription

## Processing Steps

1. **Checkout PR merge commit**
   ```yaml
   - uses: actions/checkout@v5
     with:
       ref: refs/pull/${{ github.event.pull_request.number }}/merge
   ```

2. **Post initial status comment**
   ```
   "🤖 Code review in progress... This may take up to 2 minutes."
   ```

3. **Run Claude Code Review**
   ```yaml
   - uses: anthropics/claude-code-action@v1
     with:
       claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
       mode: 'review'
       pr_number: ${{ github.event.pull_request.number }}
       guidelines_path: '.github/CLAUDE.md'
       focus_areas: |
         - Security vulnerabilities
         - Potential bugs
         - Code quality issues
         - Performance concerns
   ```

4. **Post review results**
   - If issues found: Post inline comments on specific lines
   - If no issues: Update status comment with "✅ No issues found"
   - If timeout/error: Update status with error message

## Outputs

### Success Case
- **PR Comments**: 0-N inline code review comments
- **Status Comment**: Summary of review (updated from initial status)
- **Labels**: Optionally add labels like `needs-changes`, `security-review`

### Error Cases
- **Rate Limit**: Status comment with retry time
- **Timeout**: Status comment with partial results + "review incomplete"
- **API Error**: Status comment with error code + link to logs

## Permissions Required

```yaml
permissions:
  contents: read          # Read repository code
  pull-requests: write    # Post comments on PR
```

## Dependencies

### GitHub Actions
- `actions/checkout@v5` - Clone repository
- `anthropics/claude-code-action@v1` - Call Claude Code API
- `actions/github-script@v7` - Post comments (if manual posting needed)

### External Services
- Anthropic Claude Code API (via OAuth, no API costs with Claude Max)

### Configuration Files
- `.github/CLAUDE.md` (optional)

## Success Criteria

- ✅ Review completes within 2 minutes for 95% of PRs
- ✅ Comments posted with line-specific feedback
- ✅ Zero false positives for critical security issues
- ✅ Status updates visible throughout process
- ✅ Graceful degradation on errors

## Error Handling

### Usage Limit Exceeded
```yaml
- name: Handle usage limit
  if: steps.claude_review.outcome == 'failure'
  run: |
    github.rest.issues.createComment({
      body: '⏳ Claude Max usage limit reached. Review will retry when quota resets.'
    })
```

### Timeout (>10 minutes)
```yaml
timeout-minutes: 10
```
Post partial results with note about timeout.

### Invalid OAuth Token
Fail fast with clear error message (do not expose token). Guide user to regenerate using `/install-github-app`.

### Large PR (>500 files)
Skip automatic review, post comment suggesting manual review.

## Performance Optimizations

1. **Diff Filtering**: Only send changed lines to Claude Code (not full files)
2. **Parallel Processing**: For PRs with multiple files, analyze in batches
3. **Early Exit**: Skip review if only documentation files changed
4. **Usage Awareness**: Monitor Claude Max usage limits to avoid hitting quota

## Configuration Options

### In CLAUDE.md
```markdown
# Claude Code Review Guidelines

## Severity Levels
- Critical: Security vulnerabilities, data loss risks
- Warning: Potential bugs, performance issues
- Info: Code style, best practices

## Focus Areas
- Authentication/authorization logic
- Database queries
- API endpoints
- Error handling

## Ignore Patterns
- Test files (*.test.js)
- Generated files (*.generated.*)
```

## Testing

### Manual Test
1. Create test PR with intentional issues:
   - SQL injection vulnerability
   - Null pointer dereference
   - Unused variable
2. Verify workflow triggers
3. Check comment appears within 2 minutes
4. Confirm issues are identified

### Automated Test
```yaml
# .github/workflows/test-pr-review.yml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily
jobs:
  test:
    - Create test PR via API
    - Wait for review
    - Assert comments exist
    - Close test PR
```

## Metrics

Track these metrics for monitoring:
- Median review time (target: <90 seconds)
- P95 review time (target: <2 minutes)
- Usage limit hits (target: <5% of runs)
- False positive rate (target: <20%)
- PR coverage (target: >95%)

## Example Output

**Status Comment (Initial)**:
```
🤖 Code review in progress... This may take up to 2 minutes.

Analyzing 12 changed files across 247 lines...
```

**Review Comment (On Code)**:
```
⚠️ Potential null pointer exception

Line 42: `user.profile.email` could be null if profile is undefined.

Suggestion:
```javascript
const email = user.profile?.email ?? 'no-email';
```

Severity: Warning
Category: Potential Bug
```

**Status Comment (Complete)**:
```
✅ Code review complete

Found 3 issues:
- 0 critical
- 2 warnings
- 1 info

Review took 87 seconds.

See inline comments for details.
```

## Related Workflows

- **Triggers**: [ai-comment-workflow.md](./ai-comment-workflow.md) - Developers can request AI fixes
- **Depends On**: Repository secrets configuration
- **Followed By**: CI pipelines (if review passes)
