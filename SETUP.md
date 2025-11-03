# Setup Guide - AI-Powered Monorepo Automation Template

This guide walks you through setting up your new repository created from this template.

> **⏱️ Estimated Time**: 15-30 minutes

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [Configuration Files](#configuration-files)
4. [GitHub Secrets](#github-secrets)
5. [Project Customization](#project-customization)
6. [Testing the Setup](#testing-the-setup)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before you begin, ensure you have:

- [ ] **GitHub Account** with access to GitHub Actions
- [ ] **Claude Max Subscription** (for Claude Code OAuth)
- [ ] **Git** installed locally
- [ ] **Node.js >= 18.0.0** (if using Node.js projects)
- [ ] **npm >= 9.0.0** (if using npm)
- [ ] Text editor or IDE

### Optional (for deployment):

- [ ] **Vercel Account** (for frontend deployment)
- [ ] **Docker Hub Account** (for backend deployment)

---

## Initial Setup

### Step 1: Create Repository from Template

1. Click **"Use this template"** button on GitHub
2. Choose a repository name and visibility
3. Click **"Create repository from template"**
4. Clone your new repository locally:

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
```

### Step 2: Install Dependencies (Node.js projects only)

If using the default Node.js structure:

```bash
# Install all dependencies including workspaces
npm ci

# Setup git hooks
npm run prepare
```

For other languages (Python, Go, etc.), skip this step or install your language-specific dependencies.

---

## Configuration Files

### 📝 Required Changes

These files **MUST** be updated after creating your repository:

#### 1. `.github/CODEOWNERS`

**What to change**: Replace all instances of `@YOUR_GITHUB_USERNAME`

```diff
- * @YOUR_GITHUB_USERNAME
+ * @yourusername

- /frontend/ @YOUR_GITHUB_USERNAME
+ /frontend/ @yourusername
```

**Why**: This determines who gets automatically assigned as reviewer for PRs.

**How**:

- Option 1: Find & Replace `@YOUR_GITHUB_USERNAME` → `@yourusername`
- Option 2: Use team names: `@org/team-name`
- Option 3: Multiple owners: `@user1 @user2`

---

#### 2. `README.md` Badges

**What to change**: Update badge URLs with your repository information

```diff
- [![CodeQL](https://github.com/YOUR_USERNAME/YOUR_REPO_NAME/workflows/...)]
+ [![CodeQL](https://github.com/yourusername/yourrepo/workflows/...)]
```

**Why**: Badges show CI/CD status for your repository.

**How**:

- Replace `YOUR_USERNAME` with your GitHub username
- Replace `YOUR_REPO_NAME` with your repository name
- Or delete the badges if you don't need them

---

#### 3. `package.json` (Node.js projects)

**What to change**: Update project metadata

```diff
{
-  "name": "ai-monorepo-template",
+  "name": "your-project-name",
-  "description": "AI-Powered Monorepo Automation Template",
+  "description": "Your project description",
}
```

**Why**: Proper package identification and metadata.

---

### 🔧 Optional Customization

#### Workspace Names

If you want to rename `frontend`/`backend` to different names:

1. **Rename directories**:

```bash
mv frontend web
mv backend api
```

2. **Update `package.json` workspaces**:

```json
{
  "workspaces": [
    "web", // was "frontend"
    "api" // was "backend"
  ]
}
```

3. **Update workflow paths** in `.github/workflows/*.yml`:

```yaml
paths:
  - "web/**" # was 'frontend/**'
  - "api/**" # was 'backend/**'
```

#### Remove Unused Workflows

If you don't need certain features, delete the corresponding workflow file:

- Don't need deployment? → Delete `.github/workflows/deploy.yml`
- Don't need Lighthouse? → Delete `.github/workflows/lighthouse.yml`
- Don't need weekly features? → Delete `.github/workflows/weekly-feature-suggestions.yml`

---

## GitHub Secrets

### Required Secrets

Navigate to: **Settings → Secrets and variables → Actions → New repository secret**

#### 1. `CLAUDE_CODE_OAUTH_TOKEN` (Required)

**Purpose**: Enables Claude Code to review PRs and make commits

**How to get**:

1. Install Claude Code CLI: https://claude.com/code
2. Run: `claude`
3. Execute: `/install-github-app`
4. Follow authentication prompts
5. Copy the generated OAuth token
6. Add as secret with name: `CLAUDE_CODE_OAUTH_TOKEN`

**Cost**: No additional cost - uses your Claude Max subscription

---

### Optional Secrets (for Deployment)

Only configure these if you're using the deployment workflows:

#### 2. Vercel Secrets (Frontend Deployment)

If deploying frontend to Vercel:

- `VERCEL_TOKEN` - Get from: https://vercel.com/account/tokens
- `VERCEL_ORG_ID` - Found in project settings
- `VERCEL_PROJECT_ID` - Found in project settings

#### 3. Docker Secrets (Backend Deployment)

If deploying backend to Docker Hub:

- `DOCKER_USERNAME` - Your Docker Hub username
- `DOCKER_PASSWORD` - Docker Hub access token (not your password)

**How to get Docker Hub token**:

1. Go to: https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Copy and save as `DOCKER_PASSWORD` secret

#### 4. GitHub Token (Advanced Automation)

Only needed for advanced project board automation:

- `GITHUB_TOKEN` - Personal Access Token with `repo` and `project` scope
- `GITHUB_PROJECT_ID` - Your GitHub Project ID

---

## Project Customization

### For Different Languages/Frameworks

This template is designed for Node.js monorepo by default, but you can adapt it:

#### Python Projects

1. **Remove Node.js structure**:

```bash
rm -rf frontend backend node_modules package.json package-lock.json
```

2. **Create Python structure**:

```bash
mkdir src tests
touch requirements.txt setup.py
```

3. **Update workflows**:

- Modify `.github/workflows/` files to use Python actions
- Example: Replace `actions/setup-node` with `actions/setup-python`

4. **Update `.gitignore`**: Python-specific entries are already included

#### Go Projects

1. **Remove Node.js structure** (same as Python)

2. **Create Go structure**:

```bash
mkdir -p cmd/server pkg internal
touch go.mod
go mod init yourmodule
```

3. **Update workflows**: Use `actions/setup-go`

#### Single Project (Not Monorepo)

1. **Remove workspaces** from `package.json`:

```json
{
  "name": "your-project"
  // Remove "workspaces" field
}
```

2. **Simplify structure**:

```bash
rm -rf frontend backend
# Move your code to root or src/
```

3. **Update workflows**: Remove path filters or adjust to your structure

---

## Testing the Setup

### 1. Verify Local Build (Node.js)

```bash
# Install dependencies
npm ci

# Run linter
npm run lint

# Run tests
npm run test

# Build
npm run build
```

All commands should complete successfully.

### 2. Test Git Hooks

```bash
# Make a small change
echo "# Test" >> README.md

# Try to commit (should trigger pre-commit hooks)
git add README.md
git commit -m "test: verify hooks"
```

If hooks are working, you'll see:

- Linting running
- Formatting checks
- Commit message validation

### 3. Create Test PR

1. **Create a new branch**:

```bash
git checkout -b test/setup
```

2. **Make a small change**:

```bash
echo "console.log('test');" >> frontend/src/test.js
git add .
git commit -m "test: verify automation"
git push -u origin test/setup
```

3. **Open PR on GitHub**

4. **Verify workflows run**:

- CI workflows should trigger
- Claude Code should review within 2 minutes
- You should see automated comments

### 4. Test Claude Code Commands

In the PR, try commenting:

```
@claude apply
```

Claude should respond and offer to apply suggestions.

---

## Troubleshooting

### Issue: Workflows Not Running

**Symptoms**: No GitHub Actions running after creating PR

**Solutions**:

1. Check Actions are enabled: Settings → Actions → Allow all actions
2. Verify workflow files are in `.github/workflows/`
3. Check branch name matches workflow triggers (usually `main`)

---

### Issue: Claude Code Not Responding

**Symptoms**: No review comments from Claude Code

**Solutions**:

1. Verify `CLAUDE_CODE_OAUTH_TOKEN` is set correctly
2. Check token hasn't expired - regenerate if needed
3. Ensure Claude Code GitHub App is installed on the repository
4. Check workflow logs for authentication errors

---

### Issue: Pre-commit Hooks Failing

**Symptoms**: Can't commit due to lint/format errors

**Solutions**:

1. Run fixes manually:

```bash
npm run lint:fix
npm run format
```

2. If hooks are misconfigured:

```bash
rm -rf .husky
npm run prepare
```

---

### Issue: Deployment Failing

**Symptoms**: Deploy workflow fails

**Solutions**:

**For Vercel**:

1. Verify all three secrets are set: `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`
2. Test build locally: `cd frontend && npm run build`
3. Check Vercel project exists and IDs match

**For Docker**:

1. Verify `DOCKER_USERNAME` and `DOCKER_PASSWORD` are correct
2. Test Docker build locally: `cd backend && docker build -t test .`
3. Verify Docker Hub repository exists

---

### Issue: Different Node Version

**Symptoms**: `engines` field errors during install

**Solutions**:

**Option 1**: Use required version (Node >= 18)

```bash
# Using nvm
nvm install 18
nvm use 18
```

**Option 2**: Update requirements in `package.json`

```json
{
  "engines": {
    "node": ">=16.0.0" // Adjust to your version
  }
}
```

---

### Issue: Workspace Errors

**Symptoms**: `npm ci` fails with workspace errors

**Solutions**:

1. **Ensure workspace directories exist**:

```bash
ls frontend/package.json  # Should exist
ls backend/package.json   # Should exist
```

2. **If using different structure**, remove workspaces:

```json
{
  // Remove "workspaces" from package.json
}
```

3. **Reinstall**:

```bash
rm -rf node_modules package-lock.json
npm install
```

---

## Next Steps

After completing setup:

1. ✅ **Customize for your project**:
   - Add your actual code to frontend/backend
   - Update dependencies
   - Configure database, APIs, etc.

2. ✅ **Configure optional features**:
   - Setup deployment (Vercel, Docker, etc.)
   - Enable Lighthouse performance monitoring
   - Configure Dependabot for your stack

3. ✅ **Update documentation**:
   - Customize README.md with your project details
   - Add API documentation
   - Document deployment process

4. ✅ **Invite team members**:
   - Add collaborators to repository
   - Update CODEOWNERS with team structure
   - Configure branch protection rules

5. ✅ **Start developing**:
   - Create feature branches
   - Make PRs to test automation
   - Iterate and improve workflows

---

## Additional Resources

- **Quickstart Guide**: `specs/001-ai-monorepo-template/quickstart.md`
- **Claude Code Docs**: https://claude.com/code
- **GitHub Actions Docs**: https://docs.github.com/actions
- **Conventional Commits**: https://www.conventionalcommits.org/

---

## Support

If you encounter issues:

1. Check [Troubleshooting](#troubleshooting) section above
2. Review workflow logs in Actions tab
3. Consult the detailed quickstart guide
4. Check Claude Code documentation

---

**Last Updated**: 2025-11-03
**Template Version**: 1.0.0
