# AI-Powered Monorepo Automation Template

[![CodeQL](https://github.com/Insajin/AutonomusCompany/workflows/CodeQL%20Security%20Analysis/badge.svg)](https://github.com/Insajin/AutonomusCompany/actions/workflows/codeql.yml)
[![Frontend CI](https://github.com/Insajin/AutonomusCompany/workflows/Frontend%20CI/badge.svg)](https://github.com/Insajin/AutonomusCompany/actions/workflows/frontend-ci.yml)
[![Backend CI](https://github.com/Insajin/AutonomusCompany/workflows/Backend%20CI/badge.svg)](https://github.com/Insajin/AutonomusCompany/actions/workflows/backend-ci.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A comprehensive GitHub repository template that automates development workflows for monorepo projects using Claude Code AI.

## Features

### 🤖 AI-Powered Development

- **Automated Code Review** - Claude Code reviews every PR within 2 minutes
- **AI-Assisted Fixes** - Apply suggested improvements with `@claude apply`
- **Intelligent Suggestions** - Security, bugs, performance, and quality feedback
- **Automated Feature Suggestions** - Weekly AI analysis proposes new features and improvements
- **Interactive Refinement** - Discuss and refine suggestions via GitHub Discussions
- **Automatic Implementation** - Approved features automatically generate PRs with implementation

### 🔒 Security & Quality

- **CodeQL Analysis** - Automated security vulnerability scanning
- **Code Coverage** - 70% threshold with PR reports
- **Pre-commit Hooks** - Lint, format, and validate before commit
- **Conventional Commits** - Enforced commit message format

### ⚡ Performance Monitoring

- **Lighthouse CI** - Automated performance audits
- **Core Web Vitals** - Track FCP, LCP, CLS, TTI
- **Bundle Size Tracking** - Monitor frontend bundle sizes
- **Performance Budgets** - Fail builds that exceed limits

### 🚀 Release Automation

- **Semantic Release** - Auto versioning based on commits
- **Changelog Generation** - Automatic CHANGELOG.md updates
- **GitHub Releases** - Auto-create releases with notes
- **Conventional Commits** - Smart version bumping

### 🔧 Developer Experience

- **Monorepo Support** - Separate frontend/backend workflows
- **Intelligent CI/CD** - Only build/test changed components (40% faster)
- **Dev Environment Setup** - One-command setup script
- **Documentation** - Templates, guides, and examples

### 📦 Dependency Management

- **Dependabot** - Monthly automated dependency updates + immediate security alerts
- **Multiple Ecosystems** - npm, Go, GitHub Actions, Docker
- **Smart Grouping** - Separate PRs per component
- **Template-Optimized** - Maintains stable versions for new projects

### 💰 Cost Optimization

- **No API Costs** - Uses Claude Max subscription (OAuth)
- **Efficient CI** - Path-based filtering reduces build time
- **Caching** - Dependencies and build artifacts cached

## Quick Start

Get up and running in 15-30 minutes:

**[→ See Full Quickstart Guide](specs/001-ai-monorepo-template/quickstart.md)**

### TL;DR

1. **Use this template** to create your repository
2. **Add Claude Code OAuth token** to repository secrets (`CLAUDE_CODE_OAUTH_TOKEN`)
3. **Customize structure** for your project (optional)
4. **Create a test PR** to see automation in action

## What's Included

### Automated Workflows

This template includes pre-configured GitHub Actions workflows:

| Workflow                | File                             | Trigger                       | Purpose                                        |
| ----------------------- | -------------------------------- | ----------------------------- | ---------------------------------------------- |
| **Code Review**         | `pr-review.yml`                  | PR opened                     | Automated code review by Claude Code           |
| **AI Fixes**            | `ai-comment.yml`                 | `@claude` command             | Apply AI-suggested fixes                       |
| **Feature Suggestions** | `weekly-feature-suggestions.yml` | Weekly (Monday)               | AI analyzes codebase and proposes improvements |
| **Discussion Feedback** | `discussion-feedback.yml`        | Discussion comments           | Refine suggestions based on feedback           |
| **Auto Implementation** | `implement-approved-feature.yml` | Discussion labeled "approved" | Create spec and implementation PR              |
| **Frontend CI**         | `frontend-ci.yml`                | Frontend changes              | Build/test frontend with coverage              |
| **Backend CI**          | `backend-ci.yml`                 | Backend changes               | Build/test backend with coverage               |
| **CodeQL**              | `codeql.yml`                     | PR + Weekly                   | Security vulnerability scanning                |
| **Lighthouse**          | `lighthouse.yml`                 | Frontend changes              | Performance audit (Core Web Vitals)            |
| **Semantic Release**    | `release.yml`                    | Merge to main                 | Auto versioning & changelog                    |
| **Doc Sync**            | `docs-sync.yml`                  | Merge to main                 | Update documentation                           |
| **Deploy**              | `deploy.yml`                     | Merge to main                 | Deploy to production                           |
| **Dependencies**        | `dependabot.yml`                 | Weekly                        | Dependency updates                             |

### Project Structure

```
.
├── .github/
│   ├── workflows/          # Automation workflows
│   └── CLAUDE.md           # AI behavior configuration
├── frontend/               # Example frontend (React/Next.js)
├── backend/                # Example backend (Node.js/Express)
├── docs/                   # Documentation
│   └── api/                # API documentation
├── scripts/                # Utility scripts
│   ├── validate-config.sh  # Workflow validation
│   └── test-automation.sh  # Integration testing
└── specs/                  # Feature specifications
```

## How It Works

### 1. Automated Code Review

When you create a PR:

```
Developer creates PR
    ↓
Claude Code reviews code (< 2 min)
    ↓
Comments posted on specific lines
    ↓
Developer addresses feedback
```

### 2. AI-Assisted Fixes

To apply suggested fixes:

```
@claude apply
```

Claude Code will:

- Read review comments
- Generate fixes
- Commit to your PR branch
- Trigger CI to validate

### 3. Intelligent CI

Path-based pipeline execution:

```
Frontend changes → Frontend CI only
Backend changes  → Backend CI only
Both changed     → Both CIs in parallel
```

Saves 40% of CI time compared to running all tests.

### 4. Automated Feature Suggestions

Every Monday, Claude Code analyzes your codebase and suggests improvements:

```
Weekly Analysis (Monday 09:00)
    ↓
Claude analyzes codebase
- New features
- Code improvements
- Automation opportunities
- Documentation gaps
    ↓
GitHub Discussion created with suggestions
    ↓
Team provides feedback via comments
    ↓
@claude refine → Suggestion refined based on feedback
    ↓
Add "approved" label
    ↓
Detailed spec created in specs/
    ↓
Implementation PR generated automatically
    ↓
Code review & merge
```

**Available Commands in Discussions**:

- `@claude refine [feedback]` - Refine suggestion based on your input
- `@claude clarify [question]` - Get clarification on details
- `@claude analyze` - Analyze feasibility and impact

**Approval Process**:

1. Review weekly suggestions in Discussions
2. Comment with feedback or questions
3. Add `approved` label when ready to implement
4. Claude creates detailed specification
5. Implementation PR generated automatically
6. Review and merge as usual

This creates a continuous improvement loop where your codebase evolves based on AI insights and team collaboration.

## Setup

### Prerequisites

- GitHub repository with admin access
- Claude Max (or Pro) subscription
- 15-30 minutes for setup

### Step 1: Generate OAuth Token

1. Open Claude Code CLI:

   ```bash
   claude
   ```

2. Run install command:

   ```
   /install-github-app
   ```

3. Follow the prompts to:
   - Authenticate with Claude Max
   - Authorize GitHub app
   - Select your repository
   - Copy the generated token

### Step 2: Add Repository Secret

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add secret:
   - Name: `CLAUDE_CODE_OAUTH_TOKEN`
   - Value: (token from step 1)

### Step 3: Enable GitHub Discussions

For automated feature suggestions to work:

1. Go to **Settings** → **General**
2. Scroll to **Features** section
3. Check **Discussions**
4. Click **Set up discussions**
5. Create categories:
   - **Ideas** (or **General**) - For feature suggestions
   - Add labels: `approved`, `rejected`, `in-review`

**Get Discussion Category ID** (for workflows):

```bash
gh api graphql -f query='query {
  repository(owner:"YOUR_OWNER",name:"YOUR_REPO"){
    discussionCategories(first:10){
      nodes{
        id
        name
      }
    }
  }
}'
```

Copy the `id` for your "Ideas" or "General" category and update it in:

- `.github/workflows/weekly-feature-suggestions.yml` (line 91: `categoryId`)

### Step 4: Test Automation

Create a test PR with intentional issues:

```javascript
// Example: code with issues
function authenticate(user) {
  const email = user.profile.email; // null pointer risk
  const token = Math.random(); // insecure
  return token;
}
```

Within 2 minutes, Claude Code will comment on the issues.

Then try:

```
@claude apply
```

Claude will commit fixes automatically.

## Using This Template

### After Forking or Cloning

Once you've created your repository from this template:

#### 1. Update Dependencies (Recommended)

This template maintains stable versions to ensure compatibility. Update to latest versions based on your needs:

```bash
# Check for outdated packages
npm outdated

# Update all dependencies to latest stable
npm update

# Or update to latest (including major versions)
npx npm-check-updates -u && npm install
```

#### 2. Configure Dependabot Schedule

The template uses monthly updates to reduce noise. Adjust based on your project needs:

Edit `.github/dependabot.yml`:

```yaml
schedule:
  interval: "daily"    # Options: daily, weekly, monthly
  # or
  interval: "weekly"
  day: "monday"
```

#### 3. Enable Security Updates

**Important**: Dependabot security updates work independently of the schedule:

1. Go to **Settings** → **Security & analysis**
2. Enable **Dependabot security updates**
3. Security vulnerabilities will create PRs immediately, regardless of schedule

#### 4. Review Workflows

Some workflows are optimized for template maintenance. You may want to:

- Adjust CI triggers for your workflow
- Customize review focus in `.github/CLAUDE.md`
- Update deployment targets in `deploy.yml`

## Configuration

### Customize Claude Behavior

Edit `.github/CLAUDE.md` to configure:

- Code review focus areas
- Review severity levels
- Code style preferences
- Commit message format
- Safety rules

See [example CLAUDE.md](.github/CLAUDE.md) for template.

### Adapt to Your Stack

The template uses frontend/backend structure by default. To customize:

1. **Rename directories** to match your structure:

   ```bash
   mv frontend web
   mv backend api
   ```

2. **Update workflow path filters**:

   ```yaml
   # .github/workflows/frontend-ci.yml
   paths:
     - "web/**" # was 'frontend/**'
   ```

3. **Adjust build commands** in CI workflows

## Usage

### Daily Development

1. Create branch and make changes
2. Create PR
3. Wait for automated review
4. Address feedback (manually or with `@claude apply`)
5. Merge when CI passes

### Available Commands

| Command                  | Effect                       |
| ------------------------ | ---------------------------- |
| `@claude apply`          | Apply all review suggestions |
| `@claude fix <issue>`    | Fix specific issue           |
| `@claude explain <code>` | Explain code without changes |

## Documentation

- **[Quickstart Guide](specs/001-ai-monorepo-template/quickstart.md)** - 15-minute setup
- **[Full Specification](specs/001-ai-monorepo-template/spec.md)** - Detailed requirements
- **[Architecture](docs/architecture.md)** - System design and workflows
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions
- **[Customization Guide](docs/customization-guide.md)** - Adapt to your stack

## Examples

### Automated Review Output

```
🤖 Code review complete

Found 3 issues:
- 1 critical (SQL injection risk)
- 1 warning (null pointer)
- 1 info (unused variable)

See inline comments for details.
```

### AI Fix Commit

```
fix: apply AI suggestions from review

Changes made:
1. Added parameterized query (line 42)
2. Added null check (line 67)
3. Removed unused variable (line 89)

Triggered-By: @developer in #123
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Cost Estimation

### Claude Max Subscription

| Item                               | Monthly Cost           |
| ---------------------------------- | ---------------------- |
| Claude Max subscription (per user) | $20                    |
| Additional API costs               | $0 (uses subscription) |

### GitHub Actions

| Item                           | Monthly Usage  | Cost           |
| ------------------------------ | -------------- | -------------- |
| CI pipelines (~500 PR updates) | ~1,000 min     | $0 (free tier) |
| Deployments (~40 merges)       | ~200 min       | $0 (free tier) |
| **Total**                      | **~1,200 min** | **$0**         |

**Total Monthly Cost**: Existing Claude Max subscription only

## Troubleshooting

### Workflows Not Triggering

1. Check Actions are enabled: **Settings** → **Actions**
2. Verify path filters match your structure
3. Validate YAML syntax: `yamllint .github/workflows/*.yml`

### OAuth Token Errors

1. Verify secret name is exactly: `CLAUDE_CODE_OAUTH_TOKEN`
2. Regenerate token using `/install-github-app`
3. Confirm Claude Max subscription is active

### Review Taking Too Long

1. Check workflow run logs for errors
2. Verify OAuth token is valid
3. Check Claude Max usage limits

See [full troubleshooting guide](docs/troubleshooting.md) for more.

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Development workflow
- Code standards
- Testing requirements
- Documentation guidelines

## Support

- **Issues**: [Report bugs or request features](../../issues)
- **Discussions**: [Ask questions](../../discussions)
- **Documentation**: [Browse full docs](docs/)

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Built with [Claude Code](https://claude.com/code) by Anthropic
- Powered by [GitHub Actions](https://github.com/features/actions)
- Uses [Dependabot](https://github.com/dependabot) for dependency management

---

**Ready to get started?** → [Follow the Quickstart Guide](specs/001-ai-monorepo-template/quickstart.md)
