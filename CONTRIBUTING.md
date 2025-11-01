# Contributing to AI-Powered Monorepo Template

Thank you for your interest in contributing! This document provides guidelines for contributing to this repository template.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Workflow Automation Overview](#workflow-automation-overview)
- [Pull Request Process](#pull-request-process)
- [Code Standards](#code-standards)
- [Testing](#testing)
- [Documentation](#documentation)

## Getting Started

1. **Fork the repository** and clone your fork locally
2. **Install dependencies** for the component you're working on:
   ```bash
   # Frontend
   cd frontend && npm install

   # Backend
   cd backend && npm install
   ```
3. **Create a branch** for your feature or fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### 1. Automated Code Review

When you create a pull request, Claude Code will automatically review your changes within 2 minutes:

- Reviews focus on security, bugs, code quality, and performance
- Comments appear inline on specific lines of code
- Review guidelines are defined in `.github/CLAUDE.md`

### 2. AI-Assisted Fixes

After receiving review feedback, you can request AI assistance:

```
@claude apply
```

This triggers Claude Code to apply suggested fixes automatically. The bot will:
- Commit changes to your PR branch
- Reference the review comments addressed
- Trigger CI pipelines to validate fixes

### 3. Continuous Integration

Our CI pipelines run intelligently based on what changed:

- **Frontend changes** → Only frontend CI runs
- **Backend changes** → Only backend CI runs
- **Both changed** → Both pipelines run in parallel

This saves time and ensures fast feedback.

## Workflow Automation Overview

This template includes 6 automated workflows:

### US1: Automated Code Review
- **Trigger**: PR opened
- **Action**: Claude Code reviews code
- **Output**: Inline comments on PR

### US2: AI-Assisted Fixes
- **Trigger**: `@claude apply` comment
- **Action**: Claude Code commits fixes
- **Output**: New commit with improvements

### US3: Intelligent CI/CD
- **Trigger**: PR updated or push to main
- **Action**: Build/test affected components only
- **Output**: Status checks

### US4: Documentation Sync
- **Trigger**: Code merged to main
- **Action**: Updates documentation automatically
- **Output**: Documentation PR

### US5: Dependency Updates
- **Trigger**: Weekly (Dependabot)
- **Action**: Creates update PRs
- **Output**: Dependency update PRs with release notes

### US6: Project Board Automation
- **Trigger**: Issue/PR lifecycle events
- **Action**: Moves items on project board
- **Output**: Updated board status

## Pull Request Process

1. **Create PR** with clear title and description
2. **Wait for automated review** (usually <2 minutes)
3. **Address feedback** manually or with `@claude apply`
4. **Ensure CI passes** for your component
5. **Request human review** from maintainers
6. **Merge** once approved and all checks pass

### PR Title Format

Use conventional commit format:

```
feat: add user authentication
fix: resolve null pointer in login
docs: update API documentation
refactor: extract database logic
test: add unit tests for auth
chore: update dependencies
```

## Code Standards

### General Principles

- **Modularity**: Small, focused components/functions
- **DRY**: Don't repeat yourself - reuse code
- **Type Safety**: Use TypeScript types, avoid `any`
- **Testing**: Write tests for new features
- **Documentation**: Comment complex logic

### Frontend (React/Next.js)

- Use functional components with hooks
- Prefer server components over client components
- Follow Next.js best practices for SSR/ISR
- Use the UI library components (no raw HTML)
- Keep components under 200 lines

### Backend (Node.js/Express or Python)

- Follow RESTful API conventions
- Implement proper error handling
- Validate all inputs
- Use environment variables for config
- Write unit tests for business logic

### YAML (Workflows)

- Include inline comments explaining steps
- Use meaningful job and step names
- Set appropriate timeouts
- Implement error handling
- Follow the existing workflow patterns

## Testing

### Running Tests

```bash
# Frontend
cd frontend
npm test
npm run test:coverage

# Backend
cd backend
npm test
# or
pytest
```

### Test Requirements

- **Unit tests**: For business logic and utilities
- **Integration tests**: For API endpoints
- **E2E tests**: For critical user flows (optional)
- **Coverage**: Aim for >80% coverage

## Documentation

### When to Update Docs

- Adding new features → Update README and relevant docs
- Changing APIs → Update API documentation in `docs/api/`
- Fixing bugs → Update troubleshooting guide if applicable
- Workflow changes → Update workflow contracts in specs

### Documentation Standards

- Use clear, concise language
- Include code examples
- Add diagrams for complex flows
- Keep quickstart guide up to date
- Document all environment variables

## Reporting Issues

When reporting issues, include:

1. **Description**: What is the problem?
2. **Steps to Reproduce**: How can we recreate it?
3. **Expected Behavior**: What should happen?
4. **Actual Behavior**: What actually happens?
5. **Environment**: OS, Node version, etc.
6. **Logs**: Relevant error messages or workflow logs

## Questions or Need Help?

- Check existing [Issues](../../issues) and [Discussions](../../discussions)
- Review the [Quickstart Guide](specs/001-ai-monorepo-template/quickstart.md)
- Read the [Full Specification](specs/001-ai-monorepo-template/spec.md)
- Join our community (Discord/Slack link here if available)

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the code, not the person
- Welcome newcomers and help them learn

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing to make this template better!
