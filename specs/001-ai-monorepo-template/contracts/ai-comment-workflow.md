# AI Fix Application Workflow Contract

**Workflow File**: `.github/workflows/ai-comment.yml`
**Primary Goal**: Apply code fixes using Claude Code when triggered by PR comments within 5 minutes

## Trigger Events

```yaml
on:
  issue_comment:
    types: [created]
```

**Filter Logic**: Only process if:
- Comment is on a pull request (not standalone issue)
- Comment contains trigger phrase: `@claude apply`, `@claude fix`, or `@claude explain`
- Comment author has write permission to repository

## Inputs

### From GitHub Context
- `github.event.issue.pull_request` - PR reference
- `github.event.comment.body` - Comment text
- `github.event.comment.user` - Who triggered
- `github.event.comment.id` - Comment ID (for linking)

### From Pull Request
- PR diff and file contents
- Previous review comments
- Commit history

### From Repository Files
- `.github/CLAUDE.md` - Claude behavior rules (optional)

### From Secrets
- `CLAUDE_CODE_OAUTH_TOKEN` - OAuth token from Claude Max subscription (no API costs)

## Processing Steps

1. **Validate trigger**
   ```yaml
   if: |
     github.event.issue.pull_request &&
     contains(github.event.comment.body, '@claude')
   ```

2. **Checkout PR branch** (head, not merge)
   ```yaml
   - uses: actions/checkout@v5
     with:
       ref: ${{ github.event.issue.pull_request.head.ref }}
       token: ${{ secrets.GITHUB_TOKEN }}
   ```

3. **Post acknowledgment**
   ```
   "🤖 Processing your request... Analyzing code and generating fixes."
   ```

4. **Parse command**
   - `@claude apply` → Apply all review suggestions
   - `@claude fix <issue>` → Fix specific issue
   - `@claude explain <code>` → Explain without changes

5. **Call Claude Code**
   ```yaml
   - uses: anthropics/claude-code-action@v1
     with:
       claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
       mode: 'apply'  # Built-in command for fix application
       pr_number: ${{ github.event.issue.number }}
   ```

6. **Commit changes**
   ```yaml
   - name: Commit fixes
     run: |
       git config user.name "github-actions[bot]"
       git config user.email "github-actions[bot]@users.noreply.github.com"
       git add .
       git commit -m "fix: apply AI suggestions from review

       Triggered-By: @${{ github.event.comment.user.login }} in #${{ github.event.issue.number }}
       Reference: ${{ github.event.comment.html_url }}

       Co-Authored-By: Claude <noreply@anthropic.com>"
       git push
   ```

7. **Post results**
   - Link to new commit
   - Summary of changes made
   - Reference to CI status checks

## Outputs

### Success Case
- **Git Commit**: New commit on PR branch with fixes
- **Summary Comment**: Description of changes applied
- **Status Check**: Triggers CI to validate fixes

### Explain Mode (No Changes)
- **Explanation Comment**: Claude's analysis without code modification

### Error Cases
- **Parse Error**: "Could not understand command. Use: @claude apply"
- **Conflict Error**: "Unable to apply changes due to conflicts. Please resolve manually."
- **API Error**: "Service temporarily unavailable. Please try again."

## Permissions Required

```yaml
permissions:
  contents: write         # Push commits to PR branch
  pull-requests: write    # Post comments
  issues: read            # Read triggering comment
```

## Dependencies

### GitHub Actions
- `actions/checkout@v5` - Clone repository with write access
- `anthropics/claude-code-action@v1` - Call Claude API
- `actions/github-script@v7` - Post comments

### External Services
- Anthropic Claude API

### Configuration Files
- `.github/CLAUDE.md` (optional)

## Success Criteria

- ✅ Fixes applied within 5 minutes for 90% of requests
- ✅ Commits pushed to PR branch successfully
- ✅ Changes address review comments accurately
- ✅ Commit messages follow conventional format
- ✅ Triggers CI pipeline for validation

## Error Handling

### Ambiguous Request
```
"❓ I need more context. Could you specify which issue to fix?

Available issues:
1. Null pointer in line 42
2. Unused variable in line 67

Reply with: @claude fix 1"
```

### Conflicting Changes
```
"⚠️ Cannot apply changes - conflicts detected.

The code has been modified since the review. Please:
1. Pull latest changes
2. Resolve conflicts manually
3. Request review again"
```

### No Review Comments
```
"ℹ️ No review suggestions found to apply.

Make sure automated code review has run first."
```

## Command Variants

### Apply All Suggestions
```
@claude apply
```
→ Applies all review comments as fixes

### Fix Specific Issue
```
@claude fix null pointer in authenticate()
```
→ Only fixes specified issue

### Explain Code
```
@claude explain why is this async?
```
→ Provides explanation without code changes

### Custom Instructions
```
@claude apply and add unit tests
```
→ Applies fixes + generates tests

## Configuration Options

### In CLAUDE.md
```markdown
# Claude Code Behavior

## Code Style
- Use 2-space indentation
- Prefer const over let
- Add JSDoc comments for functions

## Safety Rules
- Never delete tests
- Always validate input parameters
- Preserve existing error handling

## Commit Guidelines
- Use conventional commit format
- Reference triggering comment
- Include Co-Authored-By tag
```

## Testing

### Manual Test
1. Create PR with code issues
2. Wait for automated review
3. Comment `@claude apply`
4. Verify:
   - Commit pushed within 5 minutes
   - Changes address review comments
   - Commit message properly formatted
   - CI triggered and passes

### Edge Case Tests
- Multiple fix requests in parallel (queue handling)
- Fix request after force-push (conflict detection)
- Fix request with no review comments (graceful skip)

## Metrics

Track these metrics:
- Median fix time (target: <3 minutes)
- P95 fix time (target: <5 minutes)
- Success rate (target: >90%)
- Commit revert rate (target: <5%)
- Developer satisfaction (via surveys)

## Example Output

**Acknowledgment Comment**:
```
🤖 Processing your request... Analyzing code and generating fixes.

Context:
- PR #123: Add authentication
- Review comments: 3 warnings
- Branch: feature/auth
```

**Success Comment**:
```
✅ Applied fixes in commit abc123

Changes made:
1. Added null check in `authenticate()` (line 42)
2. Removed unused variable `tempUser` (line 67)
3. Fixed async/await pattern in `login()` (line 89)

CI pipeline triggered: https://github.com/.../runs/456

Time: 2m 34s
```

**Partial Success Comment**:
```
⚠️ Partially applied fixes in commit abc123

✅ Fixed (2/3):
- Null check added
- Unused variable removed

❌ Could not fix (1/3):
- Async pattern: Requires architectural changes

Consider addressing the remaining issue manually.
```

## Security Considerations

- **Authentication**: Only users with write access can trigger
- **Code Review**: All commits still require human review before merge
- **Secrets**: Never log or expose API keys
- **Attribution**: Bot commits clearly attributed to avoid impersonation

## Related Workflows

- **Triggered By**: [pr-review-workflow.md](./pr-review-workflow.md) - Provides context
- **Triggers**: CI workflows to validate changes
- **Integrates With**: GitHub Projects (status updates)
