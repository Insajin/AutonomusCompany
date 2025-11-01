# Workflow Contracts

This directory contains specifications for each GitHub Actions workflow in the template.

## Contract Documents

Each workflow contract defines:
- **Triggers**: Events that start the workflow
- **Inputs**: Required context and configuration
- **Outputs**: Comments, commits, or status updates produced
- **Permissions**: GitHub token permissions required
- **Dependencies**: Required secrets, actions, or external services
- **Success Criteria**: When the workflow is considered successful
- **Error Handling**: How failures are communicated

## Workflow Catalog

| Workflow | File | Purpose |
|----------|------|---------|
| PR Code Review | [pr-review-workflow.md](./pr-review-workflow.md) | Automated code review using OpenAI Codex |
| AI Fix Application | [ai-comment-workflow.md](./ai-comment-workflow.md) | Apply code fixes using Claude Code |
| Frontend CI | [frontend-ci-workflow.md](./frontend-ci-workflow.md) | Build and test frontend component |
| Backend CI | [backend-ci-workflow.md](./backend-ci-workflow.md) | Build and test backend component |
| Deployment | [deploy-workflow.md](./deploy-workflow.md) | Deploy frontend and backend to production |
| Documentation Sync | [docs-sync-workflow.md](./docs-sync-workflow.md) | Update docs based on code changes |
| Dependabot Config | [dependabot-config.md](./dependabot-config.md) | Dependency update configuration |

## Integration Points

```
Pull Request Created
    ↓
[pr-review-workflow] → Posts review comments
    ↓
Developer adds "@claude apply" comment
    ↓
[ai-comment-workflow] → Commits fixes
    ↓
[frontend-ci-workflow] ← Path filter: frontend/**
[backend-ci-workflow] ← Path filter: backend/**
    ↓
PR Merged to Main
    ↓
[deploy-workflow] → Deploys to production
    ↓
[docs-sync-workflow] → Creates documentation PR

Weekly Schedule
    ↓
[dependabot] → Creates dependency update PRs
```

## Common Patterns

### Event Triggers

```yaml
on:
  pull_request:
    types: [opened, synchronize]
    paths:
      - 'component/**'
```

### Secret Access

```yaml
env:
  API_KEY: ${{ secrets.SERVICE_API_KEY }}
```

### Permission Scoping

```yaml
permissions:
  contents: read
  pull-requests: write
```

### Status Updates

```yaml
- name: Post status
  uses: actions/github-script@v7
  with:
    script: |
      github.rest.issues.createComment({
        issue_number: context.issue.number,
        body: 'Status: In progress...'
      })
```

## Testing Workflows

Each workflow should be testable by:
1. Creating test PR with intentional issues/changes
2. Verifying workflow triggers correctly
3. Checking outputs appear as expected
4. Confirming error handling works
5. Validating performance meets targets

See [quickstart.md](../quickstart.md) for detailed testing instructions.
