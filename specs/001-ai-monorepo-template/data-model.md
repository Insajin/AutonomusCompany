# Phase 1: Data Model & Entity Design

**Feature**: AI-Powered Monorepo Automation Template
**Date**: 2025-10-31
**Source**: Derived from [spec.md](./spec.md) functional requirements

## Overview

This document defines the logical data model for the automation template. Since this is a GitHub Actions-based template rather than a traditional application, the "entities" are primarily GitHub platform objects (PRs, issues, workflow runs) that we interact with, plus configuration structures defined in YAML files.

## Entity Catalog

### 1. Pull Request

**Description**: A proposed code change in the repository that triggers automated reviews and tests

**Attributes**:
- `number` (integer): Unique PR identifier
- `title` (string): PR title
- `body` (string): PR description
- `author` (string): GitHub username who created PR
- `head_ref` (string): Source branch name
- `base_ref` (string): Target branch name (typically "main")
- `changed_files` (array): List of file paths modified
- `changed_paths` (array): List of directory paths affected
- `diff` (string): Git diff content
- `state` (enum): "open" | "closed" | "merged"
- `created_at` (datetime): When PR was created
- `updated_at` (datetime): Last update time

**Relationships**:
- Has many `Code Review Comment`
- Has many `CI Pipeline Run`
- References zero or many `Issue`
- Has many `Workflow Run`

**Validation Rules**:
- Must have at least one changed file
- Cannot merge if required status checks fail
- Cannot merge if conflicts exist with base branch

**State Transitions**:
```
[Created] → [Review in Progress] → [Tests Running] → [Ready to Merge] → [Merged]
                ↓                         ↓                ↓
           [Changes Requested]    [Tests Failed]    [Closed without Merge]
```

---

### 2. Code Review Comment

**Description**: Automated feedback from AI code review on specific code changes

**Attributes**:
- `id` (integer): Unique comment identifier
- `pr_number` (integer): Associated PR
- `path` (string): File path being commented on
- `line` (integer): Line number in file
- `body` (string): Comment content
- `suggestion` (string, optional): Proposed code fix
- `severity` (enum): "critical" | "warning" | "info" | "style"
- `source` (enum): "claude" | "human"
- `created_at` (datetime): When comment was posted

**Relationships**:
- Belongs to one `Pull Request`
- May reference one `Code Fix Commit`

**Validation Rules**:
- Path must exist in PR changed files
- Line number must be within file bounds
- Severity must map to appropriate labels

**Categories**:
- Security vulnerabilities
- Potential bugs
- Performance issues
- Code style violations
- Documentation gaps

---

### 3. CI Pipeline Run

**Description**: Execution of automated build/test workflow for a monorepo component

**Attributes**:
- `run_id` (integer): GitHub Actions run ID
- `workflow_name` (string): Name of workflow (e.g., "Frontend CI")
- `component` (enum): "frontend" | "backend" | "shared" | "docs"
- `triggered_by` (enum): "pr_opened" | "pr_updated" | "manual"
- `pr_number` (integer, optional): Associated PR if applicable
- `status` (enum): "queued" | "in_progress" | "success" | "failure" | "cancelled"
- `started_at` (datetime): When pipeline started
- `completed_at` (datetime, optional): When pipeline finished
- `duration_seconds` (integer): Execution time
- `conclusion` (enum): "success" | "failure" | "neutral" | "cancelled" | "skipped"
- `logs_url` (string): Link to full logs

**Relationships**:
- May belong to one `Pull Request`
- Has many `Test Result`
- Preceded by `Path Detection` decision

**Validation Rules**:
- Component must match repository structure
- Cannot have "success" status with "failure" conclusion
- Duration must be positive integer

**Performance Metrics**:
- Target: 40% faster than running all pipelines
- Timeout: Max 60 minutes per component
- Concurrency: Up to 3 components in parallel

---

### 4. Code Fix Commit

**Description**: Automated code change committed by AI assistant in response to review feedback

**Attributes**:
- `sha` (string): Git commit SHA
- `pr_number` (integer): PR where commit was pushed
- `message` (string): Commit message
- `author` (string): Bot account name (e.g., "github-actions[bot]")
- `triggered_by_comment` (string): Comment that requested fix
- `files_changed` (array): List of modified files
- `lines_added` (integer): Lines of code added
- `lines_removed` (integer): Lines of code removed
- `created_at` (datetime): Commit timestamp

**Relationships**:
- Belongs to one `Pull Request`
- References one or more `Code Review Comment`
- Triggers `CI Pipeline Run`

**Validation Rules**:
- Must include reference to triggering comment in body
- Must follow conventional commit format
- Must be signed by bot account

**Commit Message Format**:
```
fix: apply AI suggestions from review

Addresses review comments:
- path/to/file.js:42 (null check)
- path/to/other.js:15 (unused variable)

Triggered-By: @user in #123 (comment)
Co-Authored-By: Claude <noreply@anthropic.com>
```

---

### 5. Documentation Update

**Description**: Proposed changes to documentation files based on code modifications

**Attributes**:
- `pr_number` (integer): Documentation update PR number
- `triggered_by_commit` (string): Code commit SHA that triggered update
- `files_updated` (array): Documentation files modified
- `analysis_summary` (string): AI explanation of changes
- `status` (enum): "pending_review" | "approved" | "merged" | "closed"
- `created_at` (datetime): When update PR was created

**Relationships**:
- References one or more `Code Commit` (that triggered update)
- Results in one `Pull Request` (for documentation changes)

**Validation Rules**:
- Must link to specific code changes
- Must include explanation of why docs needed update
- Must pass documentation linting checks

**Update Categories**:
- API endpoint changes
- Function signature modifications
- New feature additions
- Breaking changes
- Configuration changes

---

### 6. Dependency Update PR

**Description**: Proposed dependency version update identified by Dependabot

**Attributes**:
- `pr_number` (integer): Update PR number
- `component` (enum): "frontend" | "backend" | "shared"
- `package_name` (string): Dependency being updated
- `from_version` (string): Current version
- `to_version` (string): Proposed version
- `update_type` (enum): "major" | "minor" | "patch" | "security"
- `changelog_url` (string): Link to release notes
- `compatibility_notes` (string): Breaking changes or migration notes
- `created_at` (datetime): When PR was created

**Relationships**:
- Is a `Pull Request`
- Triggers `CI Pipeline Run` for affected component

**Validation Rules**:
- Must follow semantic versioning
- Security updates must be labeled appropriately
- Must include link to changelog

**Auto-Merge Criteria**:
- Patch updates with passing tests
- No breaking changes indicated
- Dependency has high trust score

---

### 7. Issue

**Description**: Tracked work item representing a bug, feature request, or task

**Attributes**:
- `number` (integer): Issue identifier
- `title` (string): Issue summary
- `body` (string): Detailed description
- `author` (string): Creator username
- `assignees` (array): Assigned developers
- `labels` (array): Categorization tags
- `state` (enum): "open" | "closed"
- `project_status` (enum): "todo" | "in_progress" | "done"
- `created_at` (datetime): Creation time
- `closed_at` (datetime, optional): When resolved

**Relationships**:
- Referenced by zero or many `Pull Request`
- Belongs to one `Project Board Column`

**Validation Rules**:
- Must have at least one label
- Cannot be "done" if state is "open"
- Project status must match issue state

**State Transitions**:
```
[Created] → [Todo] → [In Progress] → [Done/Closed]
              ↓            ↓              ↓
        [Triaged]    [Blocked]    [Won't Fix]
```

---

### 8. Project Board Column

**Description**: Visual grouping of issues/PRs by status on GitHub Projects board

**Attributes**:
- `column_id` (string): Unique column identifier
- `name` (enum): "Todo" | "In Progress" | "Done"
- `position` (integer): Display order (1, 2, 3...)
- `item_count` (integer): Number of items in column

**Relationships**:
- Contains many `Issue`
- Contains many `Pull Request`
- Belongs to one `Project Board`

**Automation Rules**:
- Issue created → Move to "Todo"
- PR opened referencing issue → Move issue to "In Progress"
- PR merged → Move issue to "Done"
- Issue closed → Move to "Done"

---

### 9. Workflow Configuration

**Description**: YAML file defining a GitHub Actions workflow

**Attributes**:
- `file_path` (string): Path to workflow file (e.g., `.github/workflows/pr-review.yml`)
- `workflow_name` (string): Display name
- `triggers` (array): Events that start workflow (e.g., ["pull_request", "issue_comment"])
- `jobs` (array): List of job definitions
- `permissions` (object): Required GitHub token permissions
- `environment_secrets` (array): Required secrets (e.g., ["OPENAI_API_KEY"])
- `path_filters` (array, optional): Monorepo path constraints

**Relationships**:
- Generates `Workflow Run` when triggered
- References `Repository Secrets`

**Validation Rules**:
- Must have at least one trigger
- Permissions must follow least-privilege principle
- Path filters must match repository structure

**Standard Workflows**:
1. `pr-review.yml` - Codex code review
2. `ai-comment.yml` - Claude fix application
3. `frontend-ci.yml` - Frontend tests
4. `backend-ci.yml` - Backend tests
5. `deploy.yml` - Deployment automation
6. `docs-sync.yml` - Documentation updates
7. `dependabot.yml` - Dependency management

---

### 10. Repository Configuration

**Description**: Project-specific settings for automation behavior

**Attributes**:
- `monorepo_components` (array): List of component paths (e.g., ["frontend", "backend"])
- `code_review_rules` (object): Codex review guidelines from `AGENTS.md`
- `claude_behavior` (object): Claude Code rules from `CLAUDE.md`
- `ci_commands` (object): Build/test commands per component
- `deployment_targets` (object): Where each component deploys
- `dependabot_schedule` (enum): "daily" | "weekly" | "monthly"
- `project_board_id` (string): GitHub Projects board ID

**Relationships**:
- Referenced by all `Workflow Configuration`
- Validates `Workflow Run` behavior

**Validation Rules**:
- Component paths must exist in repository
- CI commands must be valid shell syntax
- Deployment targets must be accessible

**Configuration Sources**:
- `.github/workflows/*.yml` - Workflow definitions
- `.github/AGENTS.md` - Code review guidelines
- `.github/CLAUDE.md` - AI assistant behavior
- `frontend/package.json` - Frontend dependencies/scripts
- `backend/package.json` or `requirements.txt` - Backend dependencies

---

## Entity Relationship Diagram

```
┌─────────────────┐       references      ┌──────────┐
│  Pull Request   │◄──────────────────────│  Issue   │
└────────┬────────┘                       └────┬─────┘
         │                                     │
         │ has many                            │ belongs to
         │                                     │
         ▼                                     ▼
┌─────────────────────┐           ┌────────────────────────┐
│ Code Review Comment │           │ Project Board Column   │
└─────────────────────┘           └────────────────────────┘
         │
         │ triggers
         │
         ▼
┌──────────────────┐      triggers      ┌─────────────────┐
│ Code Fix Commit  │───────────────────►│ CI Pipeline Run │
└──────────────────┘                    └─────────────────┘
         │
         │ may trigger
         │
         ▼
┌─────────────────────┐
│ Documentation Update│
└─────────────────────┘

┌──────────────────┐       creates       ┌──────────────────┐
│ Dependabot       │────────────────────►│ Dependency Update│
└──────────────────┘                     │      PR          │
                                         └──────────────────┘

┌──────────────────────┐     defines    ┌──────────────────┐
│ Workflow             │───────────────►│ Workflow Run     │
│ Configuration        │                └──────────────────┘
└──────────────────────┘
         │
         │ references
         │
         ▼
┌──────────────────────┐
│ Repository           │
│ Configuration        │
└──────────────────────┘
```

## Data Flow Diagrams

### Flow 1: Automated Code Review

```
1. Developer creates PR
2. PR triggers pr-review.yml workflow
3. Workflow reads PR diff and AGENTS.md
4. Calls Codex API with context
5. Codex returns review analysis
6. Workflow posts Code Review Comments to PR
7. Developer sees comments in PR UI
```

### Flow 2: AI-Assisted Fixes

```
1. Developer posts "@claude apply" comment
2. Comment triggers ai-comment.yml workflow
3. Workflow reads PR context and CLAUDE.md
4. Calls Claude API with fix instructions
5. Claude generates code changes
6. Workflow creates Code Fix Commit
7. Commit pushed to PR branch
8. Triggers CI Pipeline Run
```

### Flow 3: Intelligent CI

```
1. PR updated with new commits
2. GitHub detects changed files
3. Path filters determine affected components
4. Only relevant CI workflows trigger
5. Each CI Pipeline Run executes in parallel
6. Results posted as PR status checks
```

### Flow 4: Documentation Sync

```
1. PR merged to main branch
2. Merge triggers docs-sync.yml workflow
3. Workflow analyzes commit diff
4. Identifies documentation needing updates
5. Calls Claude API for doc generation
6. Creates Documentation Update PR
7. Team reviews and merges doc PR
```

## Validation Summary

All entities are derived from functional requirements in the spec:

✅ **FR-001-004**: Code review comments and AI fixes
✅ **FR-005-007**: CI pipeline runs with path detection
✅ **FR-008-009**: Documentation updates
✅ **FR-010-011**: Dependency update PRs
✅ **FR-012-013**: Project board columns and issue tracking
✅ **FR-014-018**: Workflow and repository configuration
✅ **FR-019-020**: Error handling and deployment

All entities have defined:
- Attributes with types
- Relationships to other entities
- Validation rules
- State transitions (where applicable)

**Status**: Ready for contract definition (Phase 1 continued)
