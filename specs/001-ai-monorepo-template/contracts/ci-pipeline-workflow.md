# CI Pipeline Workflow Contract

**Workflow Files**:
- `.github/workflows/frontend-ci.yml`
- `.github/workflows/backend-ci.yml`

**Primary Goal**: Build and test only affected monorepo components within 5 minutes, achieving 40% time reduction

## Trigger Events

```yaml
on:
  pull_request:
    paths:
      - 'frontend/**'      # For frontend-ci.yml
      - 'backend/**'       # For backend-ci.yml
      - '!**/*.md'         # Exclude documentation
  push:
    branches: [main]
    paths:
      - 'frontend/**'      # For frontend-ci.yml
```

**Rationale**: Path filters ensure only relevant component tests run, avoiding unnecessary CI execution.

## Inputs

### From GitHub Context
- `github.event.pull_request.number` - PR number (if PR event)
- `github.ref` - Branch being tested
- `github.sha` - Commit SHA

### From Repository
- Component-specific package files:
  - `frontend/package.json` or `backend/requirements.txt`
- Test configuration files
- Source code in component directory

### Environment Variables
- `NODE_VERSION`: Node.js version (e.g., "18")
- `PYTHON_VERSION`: Python version (e.g., "3.11")
- Component-specific env vars from repository secrets

## Processing Steps

### Frontend CI Pipeline

1. **Checkout code**
   ```yaml
   - uses: actions/checkout@v5
   ```

2. **Setup environment**
   ```yaml
   - uses: actions/setup-node@v3
     with:
       node-version: '18'
       cache: 'npm'
       cache-dependency-path: frontend/package-lock.json
   ```

3. **Install dependencies** (with caching)
   ```yaml
   - name: Install dependencies
     working-directory: frontend
     run: npm ci
   ```

4. **Lint code**
   ```yaml
   - name: Lint
     working-directory: frontend
     run: npm run lint
   ```

5. **Run tests**
   ```yaml
   - name: Test
     working-directory: frontend
     run: npm test -- --coverage
   ```

6. **Build**
   ```yaml
   - name: Build
     working-directory: frontend
     run: npm run build
   ```

7. **Upload artifacts**
   ```yaml
   - uses: actions/upload-artifact@v3
     with:
       name: frontend-build
       path: frontend/dist/
   ```

### Backend CI Pipeline

Similar structure but with backend-specific commands:

1. Setup Python/Node/Go environment
2. Install dependencies
3. Run linter
4. Run unit tests
5. Run integration tests
6. Build (if applicable)

## Outputs

### Success Case
- **Status Check**: ✅ "Frontend CI / Tests" passing
- **Coverage Report**: Uploaded to artifacts or coverage service
- **Build Artifacts**: Stored for deployment workflow

### Failure Cases
- **Status Check**: ❌ "Frontend CI / Tests" failed
- **Error Summary**: Comment on PR with failure details
- **Logs**: Link to detailed workflow run logs

## Permissions Required

```yaml
permissions:
  contents: read
  pull-requests: write  # For posting test results
  checks: write         # For status checks
```

## Dependencies

### GitHub Actions
- `actions/checkout@v5`
- `actions/setup-node@v3` or `actions/setup-python@v4`
- `actions/cache@v3` - Cache dependencies
- `actions/upload-artifact@v3` - Store build outputs

### External Services
- None (all runs on GitHub-hosted runners)

## Success Criteria

- ✅ Only affected components run (100% accuracy)
- ✅ Parallel execution when multiple components change
- ✅ 40% faster than running all tests
- ✅ Completes within 5 minutes for typical PR
- ✅ Accurate failure reporting

## Performance Optimizations

### Dependency Caching
```yaml
- uses: actions/cache@v3
  with:
    path: |
      frontend/node_modules
      ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('frontend/package-lock.json') }}
```

### Parallel Test Execution
```yaml
strategy:
  matrix:
    test-group: [unit, integration, e2e]
```

### Incremental Builds
```yaml
- uses: actions/cache@v3
  with:
    path: frontend/.next/cache
    key: nextjs-${{ hashFiles('frontend/package-lock.json') }}
```

### Early Failure Detection
```yaml
fail-fast: false  # Run all tests even if one fails
```

## Path Filter Examples

### Frontend Only
```yaml
paths:
  - 'frontend/**'
  - '!frontend/**/*.md'
  - '!frontend/docs/**'
```

### Shared Dependencies
```yaml
paths:
  - 'frontend/**'
  - 'shared/**'      # Shared utilities affect frontend
```

### Multiple Components
```yaml
# If both frontend and backend change, both workflows run in parallel
jobs:
  frontend:
    if: contains(github.event.head_commit.message, 'frontend/')
  backend:
    if: contains(github.event.head_commit.message, 'backend/')
```

## Error Handling

### Test Failures
```yaml
- name: Report test results
  if: failure()
  uses: actions/github-script@v7
  with:
    script: |
      github.rest.issues.createComment({
        issue_number: context.issue.number,
        body: `❌ Tests failed in frontend component

        See details: ${context.payload.repository.html_url}/actions/runs/${context.runId}`
      })
```

### Timeout
```yaml
timeout-minutes: 10  # Fail if takes longer than 10 minutes
```

### Flaky Tests
```yaml
- name: Test with retry
  uses: nick-invision/retry@v2
  with:
    timeout_minutes: 5
    max_attempts: 3
    command: npm test
```

## Configuration Options

### In package.json (Frontend)
```json
{
  "scripts": {
    "lint": "eslint src/",
    "test": "jest --ci",
    "test:coverage": "jest --coverage",
    "build": "next build"
  }
}
```

### In pyproject.toml (Backend)
```toml
[tool.pytest]
testpaths = ["tests"]
python_files = ["test_*.py"]
```

## Metrics

Track these for monitoring:
- Median CI time per component (target: <3 minutes)
- P95 CI time (target: <5 minutes)
- Time savings vs full build (target: >40%)
- Cache hit rate (target: >80%)
- Test flakiness rate (target: <1%)

## Testing

### Validate Path Filters
1. **Frontend-only change**:
   - Modify `frontend/src/App.tsx`
   - Push commit
   - Verify only frontend-ci.yml runs

2. **Backend-only change**:
   - Modify `backend/src/main.py`
   - Push commit
   - Verify only backend-ci.yml runs

3. **Multi-component change**:
   - Modify both frontend and backend
   - Verify both pipelines run in parallel

4. **Documentation-only change**:
   - Modify `frontend/README.md`
   - Verify neither CI pipeline runs

## Example Output

**Status Check (In Progress)**:
```
⏳ Frontend CI / Tests
Running tests... (1m 23s)
```

**Status Check (Success)**:
```
✅ Frontend CI / Tests
All tests passed in 2m 47s

Coverage: 87.3%
Tests: 142 passed
```

**Status Check (Failure)**:
```
❌ Frontend CI / Tests
3 tests failed

Details: https://github.com/.../runs/789
```

**PR Comment (Failure)**:
```
❌ Frontend CI Failed

**Failed Tests:**
- `UserAuth.test.tsx` - Login validation
- `Dashboard.test.tsx` - Data loading
- `API.test.tsx` - Error handling

**Coverage:** 84.2% (-3.1%)

See full logs: [View Run](https://github.com/.../runs/789)
```

## Related Workflows

- **Triggered By**: PR creation, commits to PR, push to main
- **Depends On**: Path detection logic
- **Followed By**: [deploy-workflow.md](./deploy-workflow.md) (on main branch success)
- **Integrates With**: PR status checks, GitHub Projects
