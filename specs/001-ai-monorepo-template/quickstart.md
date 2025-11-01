# Quickstart Guide: AI-Powered Monorepo Template

**Target Audience**: Development teams setting up a new monorepo or migrating existing project
**Time to Complete**: 15-30 minutes
**Prerequisites**: GitHub repository, admin access, Claude Max (or Pro) subscription

## Overview

This template provides fully automated development workflows for monorepo projects using AI-powered tools. Get automated code reviews, AI-assisted fixes, intelligent CI/CD, documentation sync, dependency management, and project tracking - all configured and ready to use.

## What You'll Get

✅ **Automated Code Review** - Claude Code reviews every PR within 2 minutes
✅ **AI-Assisted Fixes** - Claude Code applies suggested improvements on command
✅ **Smart CI/CD** - Only builds/tests changed components (40% faster)
✅ **Doc Sync** - Automatically updates documentation when code changes
✅ **Dependency Updates** - Weekly PRs for outdated packages
✅ **Project Tracking** - Auto-updates GitHub Projects board
✅ **No API Costs** - Uses your Claude Max subscription (OAuth authentication)

## Step 1: Use This Template

### Option A: GitHub UI
1. Click **"Use this template"** button at top of repository
2. Choose repository name and visibility
3. Click **"Create repository from template"**

### Option B: GitHub CLI
```bash
gh repo create my-awesome-project \
  --template username/ai-monorepo-template \
  --private \
  --clone

cd my-awesome-project
```

**Estimated Time**: 1 minute

---

## Step 2: Configure Claude Code OAuth Token

### Prerequisites
- Active Claude Max or Pro subscription
- Claude Code CLI installed locally (`claude` command)

### Generate OAuth Token

1. **Open terminal** and run Claude Code:
   ```bash
   claude
   ```

2. **Run install command**:
   ```
   /install-github-app
   ```

3. **Follow interactive setup**:
   - Authenticate with your Claude Max account
   - Authorize GitHub app access
   - Select target repository
   - Copy generated OAuth token

### Add to Repository Secrets

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **"New repository secret"**
3. Add this secret:

| Name | Value | Purpose |
|------|-------|---------|
| `CLAUDE_CODE_OAUTH_TOKEN` | (token from step above) | OAuth authentication for all Claude Code workflows |

**Important Notes**:
- ✅ No API costs - uses your Claude Max subscription
- ✅ Token is repository-scoped (secure)
- ⚠️ Claude Max is designed for individual use; verify compliance for team repos

**Estimated Time**: 5 minutes

---

## Step 3: Customize Project Structure

### Current Structure
```
your-project/
├── frontend/          # Example frontend (React/Next.js)
├── backend/           # Example backend (Node/Python)
├── docs/              # Documentation
└── .github/workflows/ # Pre-configured workflows
```

### Option 1: Keep Example Structure
If your project matches the frontend/backend split, you're done! Move to Step 4.

### Option 2: Adapt to Your Structure

**Example: Different Component Names**
```bash
# If you have "web" and "api" instead of "frontend" and "backend"
mv frontend web
mv backend api

# Update workflow path filters
sed -i '' 's/frontend\//web\//g' .github/workflows/frontend-ci.yml
sed -i '' 's/backend\//api\//g' .github/workflows/backend-ci.yml
```

**Example: Additional Components**
```bash
# Add new component
mkdir mobile

# Copy and adapt workflow
cp .github/workflows/frontend-ci.yml .github/workflows/mobile-ci.yml

# Edit mobile-ci.yml:
# - Change paths: ['mobile/**']
# - Update working-directory: mobile
# - Adjust build/test commands
```

**Estimated Time**: 5-10 minutes (depending on customization)

---

## Step 4: Configure Claude Code Behavior (Optional)

Create `.github/CLAUDE.md` to customize Claude Code behavior for both code review and AI fixes:

```markdown
# Claude Code Configuration

## Code Review Focus Areas
- Authentication and authorization
- Database queries and indexes
- API endpoint security
- Error handling

## Code Review Ignore Patterns
- Test files (*.test.*)
- Generated files (*.generated.*)
- Documentation files (*.md)

## Code Review Severity Levels
Critical: Security vulnerabilities, data loss
Warning: Potential bugs, performance issues
Info: Code style, best practices

## AI Fix Code Style
- 2-space indentation
- Prefer const over let
- Add JSDoc comments

## AI Fix Safety Rules
- Never delete tests
- Always validate inputs
- Preserve error handling

## Commit Format
Use conventional commits:
- fix: bug fixes
- feat: new features
- refactor: code improvements
```

**Default Behavior**: If no CLAUDE.md exists, Claude uses standard best practices for both review and fixes.

**Estimated Time**: 3-5 minutes

---

## Step 5: Test Automation Workflows

### Test 1: Automated Code Review

1. **Create test branch**:
   ```bash
   git checkout -b test/code-review
   ```

2. **Add code with intentional issues**:
   ```javascript
   // frontend/src/test.js
   function authenticate(user) {
     const email = user.profile.email;  // Potential null pointer
     const token = Math.random();       // Insecure token generation
     return token;
   }
   ```

3. **Create pull request**:
   ```bash
   git add frontend/src/test.js
   git commit -m "test: add authentication function"
   git push -u origin test/code-review

   gh pr create --title "Test: Code Review" --body "Testing automated review"
   ```

4. **Verify**:
   - Within 2 minutes, Claude Code should post review comments
   - Look for comments on lines with issues
   - Check that status comment appears

**Expected Output**:
```
🤖 Code review complete (Claude Code)

Found 2 issues:
- 1 critical (insecure token)
- 1 warning (null pointer)

See inline comments for details.
```

### Test 2: AI-Assisted Fixes

1. **On the same PR, post comment**:
   ```
   @claude apply
   ```

2. **Verify**:
   - Within 5 minutes, new commit should appear
   - Commit fixes identified issues
   - CI pipeline triggered automatically

**Expected Output**:
```
✅ Applied fixes in commit abc123

Changes made:
1. Added null check for user.profile
2. Replaced Math.random() with crypto.randomBytes()

CI pipeline triggered: https://github.com/.../runs/456
```

### Test 3: Intelligent CI

1. **Make frontend-only change**:
   ```bash
   echo "// test" >> frontend/src/App.tsx
   git add frontend/src/App.tsx
   git commit -m "test: frontend change"
   git push
   ```

2. **Verify**:
   - Only "Frontend CI" workflow runs
   - "Backend CI" workflow does NOT run
   - Check Actions tab to confirm

3. **Make backend-only change**:
   ```bash
   echo "# test" >> backend/src/main.py
   git add backend/src/main.py
   git commit -m "test: backend change"
   git push
   ```

4. **Verify**:
   - Only "Backend CI" workflow runs
   - "Frontend CI" workflow does NOT run

**Success Criteria**: Only relevant pipelines execute based on changed paths

**Estimated Time**: 10-15 minutes for all tests

---

## Step 6: Enable GitHub Projects (Optional)

1. **Create project board**:
   - Go to **Projects** → **New project**
   - Choose **"Board"** template
   - Name it (e.g., "Development")

2. **Add columns**:
   - Todo
   - In Progress
   - Done

3. **Enable automation**:
   - Go to Project **Settings** → **Workflows**
   - Enable: "When issues are created → Move to Todo"
   - Enable: "When PR merged → Move to Done"

4. **Get project ID** (for advanced automation):
   ```bash
   gh project list
   # Copy the project ID
   ```

**Estimated Time**: 3-5 minutes

---

## Step 7: Configure Dependabot

The template includes `.github/dependabot.yml` pre-configured for weekly updates.

**To customize**:

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/frontend"
    schedule:
      interval: "daily"  # Change from weekly
    open-pull-requests-limit: 5
```

**Verify**: Wait for next scheduled run or trigger manually via Settings → Code security.

**Estimated Time**: 2 minutes

---

## Troubleshooting

### Workflows Not Triggering

**Problem**: Created PR but no automation runs

**Solutions**:
1. Check Actions tab is enabled: **Settings** → **Actions** → **Allow all actions**
2. Verify path filters match your structure
3. Check workflow files have correct syntax: `yamllint .github/workflows/*.yml`

### OAuth Token Errors

**Problem**: "Invalid OAuth token" or "Authentication failed" in workflow logs

**Solutions**:
1. Verify secret is named exactly: `CLAUDE_CODE_OAUTH_TOKEN`
2. Regenerate token using `/install-github-app` command
3. Confirm Claude Max subscription is active
4. Check token has correct repository scope

### CI Taking Too Long

**Problem**: CI pipelines exceed 5 minutes

**Solutions**:
1. Enable dependency caching (already configured in template)
2. Parallelize tests: Add matrix strategy to workflow
3. Reduce test scope: Use `--changed-files` flag

### Review Quality Issues

**Problem**: Too many false positives in code review

**Solutions**:
1. Add review guidelines in `.github/AGENTS.md`
2. Specify ignore patterns for generated files
3. Adjust severity thresholds

---

## Next Steps

### Recommended: Enable Branch Protection

1. Go to **Settings** → **Branches**
2. Add rule for `main` branch
3. Enable:
   - ✅ Require pull request before merging
   - ✅ Require status checks (select CI workflows)
   - ✅ Require conversation resolution

### Advanced Configuration

- **Custom Deployment**: Edit `.github/workflows/deploy.yml` for your infrastructure
- **Additional Workflows**: Copy and adapt existing workflows
- **Monitoring**: Integrate with observability tools (DataDog, Sentry)

### Documentation

- **API Docs**: Add to `docs/api/` - auto-updated on changes
- **Architecture**: Document in `docs/architecture/`
- **Runbooks**: Add operational guides to `docs/runbooks/`

---

## Cost Estimation

### Claude Max Subscription (Typical Team of 10 Developers)

| Service | Usage | Monthly Cost |
|---------|-------|--------------|
| Claude Max Subscription | Unlimited usage (within subscription limits) | $20/user (existing subscription) |
| **Additional API Costs** | | **$0** (uses subscription) |

**Important**:
- ✅ No per-use API costs - OAuth uses your existing subscription
- ✅ Predictable monthly cost (subscription only)
- ⚠️ Claude Max has usage limits (30-150 messages per 5 hours)
- ⚠️ Individual subscription terms apply

### GitHub Actions Minutes

| Workflow | Runs/Month | Minutes | Cost |
|----------|------------|---------|------|
| CI Pipelines | ~500 PR updates | ~1,000 min | Included in free tier |
| Deployments | ~40 merges | ~200 min | Included |
| **Total** | | **~1,200 min** | **$0** (under 2,000 limit) |

**Total Cost**: Existing Claude Max subscription only (no additional costs)

---

## Support & Resources

### Documentation
- [Full Specification](./spec.md) - Detailed requirements
- [Data Model](./data-model.md) - Entity definitions
- [Workflow Contracts](./contracts/) - Technical specifications

### Getting Help
- **Issues**: Search existing issues or create new one
- **Discussions**: Ask questions in GitHub Discussions
- **Discord**: Join community server (if available)

### Feedback
We'd love to hear how the template works for you! Please share:
- What worked well
- What was confusing
- What you'd like to see added

**Create feedback issue**: `gh issue create --title "Feedback: [topic]" --label feedback`

---

## Summary Checklist

Before going to production, ensure:

- [ ] Claude Max subscription active
- [ ] OAuth token configured in repository secrets (`CLAUDE_CODE_OAUTH_TOKEN`)
- [ ] Test PR confirmed automated review works
- [ ] Test PR confirmed AI fixes apply correctly
- [ ] CI path filters match your project structure
- [ ] Branch protection rules enabled on main
- [ ] Team members understand how to use `@claude` commands
- [ ] Project board (if using) connected and automating
- [ ] Dependabot configuration reviewed
- [ ] Documentation structure established
- [ ] `.github/CLAUDE.md` configured (optional)
- [ ] Usage limits understood for Claude Max subscription

**You're ready to go! 🚀**

Start creating issues, PRs, and let the automation handle the rest.

---

**Questions?** Check the [specification](./spec.md) or [create an issue](https://github.com/your-org/your-repo/issues/new).
