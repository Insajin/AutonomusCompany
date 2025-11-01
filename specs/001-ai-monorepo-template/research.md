# Phase 0: Research & Decision Documentation

**Feature**: AI-Powered Monorepo Automation Template
**Date**: 2025-10-31
**Status**: Complete

## Overview

This document captures research findings and technical decisions for building a GitHub repository template that provides comprehensive automation workflows for monorepo projects using Anthropic Claude Code AI with OAuth token authentication (Claude Max subscription).

## Research Areas

### 1. GitHub Actions Integration Patterns

**Decision**: Use Anthropic Claude Code GitHub Action with OAuth token authentication

**Rationale**:
- Anthropic provides `anthropics/claude-code-action@v1` for both code reviews and AI-assisted fixes
- Official action is maintained, secure, and receives updates
- Supports OAuth token authentication via Claude Max subscription (no API costs)
- Reduces custom API integration code and authentication complexity
- Leverages GitHub's native workflow ecosystem
- Single AI service simplifies configuration and maintenance

**Alternatives Considered**:
- Direct API calls via curl/python scripts: Rejected due to authentication complexity, rate limit handling, and maintenance burden
- Third-party wrapper actions: Rejected due to security concerns and lack of official support
- Custom bot implementations: Rejected as over-engineering for template use case

**Implementation Notes**:
- Action supports OAuth token authentication via `CLAUDE_CODE_OAUTH_TOKEN` secret
- Token generated using `/install-github-app` command in Claude CLI
- No API costs when using Claude Max subscription
- Single authentication method simplifies setup
- Actions handle retries and rate limiting internally
- Compatible with standard GitHub Actions workflow syntax

---

### 2. Monorepo Path Detection Strategy

**Decision**: Use GitHub Actions `paths` filter with glob patterns for component detection

**Rationale**:
- Native GitHub Actions feature - no custom code required
- Efficient: Workflows only trigger when relevant files change
- Supports multiple path patterns per workflow
- Well-documented and widely used pattern in monorepo projects
- Works with PR events, push events, and manual triggers

**Alternatives Considered**:
- Custom change detection scripts: Rejected as unnecessary complexity when native solution exists
- Meta-configuration file defining components: Rejected as additional maintenance burden
- Always run all pipelines: Rejected due to CI cost and time inefficiency (violates 40% performance improvement goal)

**Example Pattern**:
```yaml
on:
  pull_request:
    paths:
      - 'frontend/**'
      - '!frontend/**/*.md'  # Exclude markdown
```

**Implementation Notes**:
- Use negative patterns (!) to exclude documentation changes
- Consider shared dependencies (e.g., `shared/**` triggers both frontend and backend)
- Path filters apply to both file additions and modifications

---

### 3. AI Code Review Workflow Design

**Decision**: Trigger Claude Code review automatically on PR open, allow manual re-trigger via comment

**Rationale**:
- Automatic trigger ensures every PR gets reviewed (meets 95% within 2 minutes goal)
- Comment-based re-trigger allows reviews after force-push or updates
- Separates review workflow from fix workflow (single responsibility)
- Comment trigger pattern: `@codex review` provides explicit control

**Alternatives Considered**:
- Review on every commit: Rejected due to excessive API calls and cost
- Only manual trigger: Rejected as developers might forget, missing automation value
- Review on PR update: Rejected as too frequent (every push triggers review)

**Workflow Stages**:
1. PR opened → Checkout PR merge commit
2. Extract diff and PR metadata
3. Call Claude Code action with context
4. Post review comments to PR
5. Handle errors gracefully (timeout, usage limits)

**Implementation Notes**:
- Use `refs/pull/${{ github.event.pull_request.number }}/merge` to get combined diff
- Configure Claude Code with project-specific rules from `.github/CLAUDE.md`
- Set reasonable timeout (10 minutes) with status updates
- Action handles comment posting automatically

---

### 4. AI-Assisted Fix Application

**Decision**: Claude Code triggered by PR comment commands, commits fixes to PR branch

**Rationale**:
- Comment-based trigger gives developers control over when fixes apply
- Committing to PR branch keeps changes in review flow
- Clear attribution via bot account shows automated changes
- Supports iterative refinement (developer can request changes again)

**Alternatives Considered**:
- Automatic fix application: Rejected due to risk of incorrect changes without review
- Create separate PR with fixes: Rejected as creates PR sprawl and tracking complexity
- Suggest code without committing: Rejected as doesn't meet "apply fixes" requirement

**Command Pattern**:
- `@claude apply` - Apply all review suggestions
- `@claude fix <issue>` - Fix specific issue
- `@claude explain <code>` - Explain code without changes

**Workflow Stages**:
1. Comment created on PR → Parse command
2. Checkout PR head branch
3. Extract context (PR diff, comments, CLAUDE.md rules)
4. Call Claude action with prompt
5. Claude generates code changes
6. Commit and push to PR branch
7. Post summary comment

**Implementation Notes**:
- Require `contents: write` permission
- Use conventional commit messages: `fix: apply AI suggestions from review`
- Handle conflicts gracefully (alert developer if can't push)
- Include link to triggering comment in commit body

---

### 5. CI Pipeline Path-Based Execution

**Decision**: Separate workflows per component with path filters, matrix strategy for parallel execution

**Rationale**:
- Independent workflows allow different test commands per component
- Path filters prevent unnecessary execution (meets 100% relevant pipeline goal)
- Matrix strategy enables parallel execution when multiple components change
- Each workflow can have component-specific configuration

**Alternatives Considered**:
- Single mega-workflow with conditional steps: Rejected due to complexity and all-or-nothing execution
- Dynamic workflow generation: Rejected as over-engineering for template
- Monorepo tools (Nx, Turborepo): Rejected as adds dependency and learning curve for template

**Workflow Structure**:
```yaml
# frontend-ci.yml
on:
  pull_request:
    paths: ['frontend/**']
jobs:
  test:
    runs-on: ubuntu-latest
    steps: [checkout, setup, test, build]
```

**Implementation Notes**:
- Use `working-directory` to scope commands to component
- Cache dependencies per component
- Report results back to PR with status checks
- Support custom test commands via configuration file

---

### 6. Documentation Synchronization Strategy

**Decision**: Trigger on main branch merge, use Claude to analyze diff and update docs, create PR for review

**Rationale**:
- Main branch trigger ensures only merged code affects documentation
- Claude provides intelligent analysis (not just template replacement)
- PR creation maintains human review loop (prevents doc errors)
- Supports any documentation format (Markdown, OpenAPI, etc.)

**Alternatives Considered**:
- Inline doc comments in code: Rejected as doesn't handle high-level architecture docs
- Manual documentation updates: Rejected as violates automation goal
- Direct commit to main: Rejected as bypasses review and risks documentation errors

**Analysis Strategy**:
1. Extract commit diff since last documentation update
2. Identify changed functions, endpoints, data models
3. Locate relevant documentation files
4. Generate documentation updates based on code changes
5. Create PR with `docs:` prefix and auto-label

**Implementation Notes**:
- Use `peter-evans/create-pull-request@v5` for PR creation
- Include reference to triggering commit in PR body
- Skip execution if no documentation changes needed (check diff)
- Support documentation testing (link validation, syntax checks)

---

### 7. Dependabot Configuration

**Decision**: Use native Dependabot with separate ecosystems for each monorepo component

**Rationale**:
- Dependabot is built into GitHub (no additional setup)
- Supports multiple `package-ecosystem` entries in single config
- Automatic PR creation with changelogs and release notes
- Integrates with GitHub Security Advisories

**Alternatives Considered**:
- Renovate bot: Rejected as requires additional app installation
- Manual dependency updates: Rejected as violates automation goal
- Custom dependency checker: Rejected as Dependabot covers 95% of use cases

**Configuration Pattern**:
```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/frontend"
    schedule: {interval: "weekly"}
  - package-ecosystem: "npm"
    directory: "/backend"
    schedule: {interval: "weekly"}
```

**Implementation Notes**:
- Configure separate update schedules to avoid PR floods
- Use `allow` lists to limit updates to production dependencies
- Enable auto-merge for patch updates (with passing tests)
- Group related updates when possible

---

### 8. Project Board Automation

**Decision**: Use GitHub's built-in Projects automation workflows with GraphQL API for custom rules

**Rationale**:
- GitHub Projects (beta) provides native automation rules
- Built-in rules cover 80% of use cases (issue opened → Todo, PR merged → Done)
- GraphQL API allows custom automation for remaining 20%
- No external service dependencies

**Alternatives Considered**:
- GitHub Actions workflow for board updates: Rejected as redundant with built-in features
- External project management tools (Jira sync): Rejected as adds complexity
- Manual board updates: Rejected as violates automation goal

**Automation Rules**:
- **Built-in**: Issue opened → Status: Todo
- **Built-in**: PR merged → Status: Done
- **Custom**: PR opened referencing issue → Move issue to "In Progress"
- **Custom**: PR closed without merge → Keep issue in original status

**Implementation Notes**:
- Use `gh project item update` CLI command for custom rules
- Trigger custom automation from `pull_request` and `issues` events
- Handle race conditions (multiple events updating same item)
- Provide fallback to manual updates if automation fails

---

### 9. Error Handling and Retry Logic

**Decision**: Implement exponential backoff for API calls, status comments for long-running operations, graceful degradation

**Rationale**:
- AI APIs have rate limits and occasional downtime
- Workflows can timeout (6-hour GitHub Actions limit)
- Users need visibility into automation status
- System should never block development workflow

**Error Categories**:
1. **Transient failures** (rate limits, timeouts): Retry with backoff
2. **Invalid input** (malformed code, missing context): Skip with warning comment
3. **Service outages**: Post status and allow manual fallback
4. **Workflow failures**: Fail fast with clear error message

**Implementation Notes**:
- Use `actions/github-script` for custom retry logic
- Post initial status comment ("Review in progress...") within 30 seconds
- Update status comment every 2 minutes for long operations
- Link to workflow run logs for debugging
- Never fail silently - always provide user feedback

---

### 10. Security and Credentials Management

**Decision**: All API keys in GitHub Secrets, least-privilege workflow permissions, audit logging via GitHub Actions logs

**Rationale**:
- GitHub Secrets are encrypted at rest and in transit
- Granular workflow permissions reduce attack surface
- GitHub Actions logs provide audit trail
- Follows GitHub security best practices

**Security Measures**:
- Store `CLAUDE_CODE_OAUTH_TOKEN` as repository secret
- Use `permissions:` key in workflows (e.g., `contents: read`, `pull-requests: write`)
- Never log OAuth token or sensitive data (use `::add-mask::` if needed)
- OAuth token is repository-scoped (principle of least privilege)
- Attribute automated commits to bot account (not personal accounts)
- Review automated changes before merge (no direct-to-main commits)

**Access Control**:
- Restrict secret access to repository admins
- Use environment protection rules for production deployments
- Enable branch protection rules (require PR, passing status checks)
- Audit workflow file changes (require review for `.github/workflows/` modifications)

**Implementation Notes**:
- Provide `.env.example` with required secrets list
- Document secret setup in README
- Include security scanning of workflow files
- Support OIDC authentication for enhanced security (optional)

---

## Technology Stack Summary

| Component | Technology | Version/Ref | Rationale |
|-----------|-----------|-------------|-----------|
| Workflow Engine | GitHub Actions | N/A | Native, no setup required |
| Code Review & Fix AI | Anthropic Claude Code | anthropics/claude-code-action@v1 | Official action, OAuth auth, no API costs |
| Dependency Updates | Dependabot | Native | Built-in, automatic security advisories |
| Project Management | GitHub Projects | API v2 (GraphQL) | Native, built-in automation |
| CLI Automation | GitHub CLI (gh) | 2.0+ | Simplifies API interactions |
| Path Detection | GitHub Actions paths | N/A | Native workflow feature |
| Scripting | Bash/Shell | POSIX compatible | Universal, minimal dependencies |
| Configuration | YAML | 1.2 | Standard for GitHub Actions |
| Documentation | Markdown | CommonMark | Standard for GitHub |

---

## Performance Optimization Strategies

### Code Review Response Time (Target: <2 minutes for 95% of PRs)

1. **Eager checkout**: Start checkout while parsing metadata
2. **Diff filtering**: Only send changed lines to Claude Code (not entire files)
3. **Concurrency**: Run review analysis in parallel for large PRs
4. **Usage monitoring**: Track Claude Max subscription usage to avoid hitting limits
5. **Timeout**: Set 10-minute max with status updates every 2 minutes

### CI Pipeline Efficiency (Target: 40% reduction)

1. **Path filtering**: Only run affected component tests
2. **Dependency caching**: Use `actions/cache` for node_modules, pip packages
3. **Parallel execution**: Run frontend and backend tests simultaneously
4. **Incremental builds**: Cache build artifacts between runs
5. **Test sharding**: Split large test suites across multiple jobs

### Documentation Updates (Target: <10 minutes for 90% of cases)

1. **Diff analysis**: Only analyze changed files (not full codebase)
2. **Documentation mapping**: Pre-index which code maps to which docs
3. **Batch updates**: Group multiple changes into single PR
4. **Skip unchanged**: Fast-path exit if no documentation impact

---

## Risk Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| AI API rate limits | High | Medium | Implement backoff, queue requests, status updates |
| Incorrect AI fixes | High | Low | Require human review, run full test suite, revert capability |
| GitHub Actions quota | Medium | Low | Optimize workflow triggers, use caching, provide usage monitoring |
| Workflow maintenance burden | Medium | Medium | Comprehensive documentation, validation scripts, version pinning |
| Security vulnerabilities | High | Low | Secret management, least privilege, audit logging |
| Template adoption complexity | Medium | Medium | Quickstart guide, validation scripts, examples |

---

## Open Questions Resolved

All technical unknowns from the specification have been researched and resolved:

✅ **AI Integration Method**: Official GitHub Actions with secrets management
✅ **Monorepo Detection**: Path-based workflow filters
✅ **Pipeline Optimization**: Path filtering + parallel execution
✅ **Documentation Sync**: Claude analysis with PR review loop
✅ **Dependency Management**: Native Dependabot with multiple ecosystems
✅ **Project Board Updates**: Built-in automation + GraphQL API for custom rules
✅ **Error Handling**: Retry logic + status comments + graceful degradation
✅ **Security**: GitHub Secrets + workflow permissions + audit logs

**Status**: Ready to proceed to Phase 1 (Design & Contracts)
