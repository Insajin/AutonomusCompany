# Tasks: AI-Powered Monorepo Automation Template

**Input**: Design documents from `/specs/001-ai-monorepo-template/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅

**Tests**: Tests are NOT explicitly requested in the specification. This task list focuses on implementation only. Teams can add TDD workflows as needed.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each automation feature.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

This is a repository template project. Paths follow GitHub repository conventions:
- **Workflow files**: `.github/workflows/`
- **Configuration files**: `.github/`, root directory
- **Documentation**: `docs/`, `README.md`
- **Utility scripts**: `scripts/`
- **Example structures**: `frontend/`, `backend/`

---

## Phase 1: Setup (Repository Template Structure)

**Purpose**: Initialize GitHub repository template with basic structure and documentation

- [X] T001 Create repository template structure with .github/, docs/, scripts/, frontend/, backend/ directories
- [X] T002 [P] Initialize .gitignore with Node.js, Python, and IDE-specific patterns
- [X] T003 [P] Create LICENSE file (MIT or appropriate license)
- [X] T004 [P] Create CONTRIBUTING.md with contribution guidelines and workflow overview
- [X] T005 [P] Create base README.md with template overview and link to quickstart
- [X] T006 [P] Create .github/CLAUDE.md template with code review and AI fix guidelines structure
- [X] T007 [P] Create docs/api/ directory structure for API documentation
- [X] T008 [P] Create example frontend/package.json with React/Next.js dependencies
- [X] T009 [P] Create example backend/package.json with Node.js/Express dependencies (or requirements.txt for Python)

---

## Phase 2: Foundational (Core Configuration Files)

**Purpose**: Configuration files and utilities that ALL automation workflows depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T010 Create .github/dependabot.yml with multi-ecosystem configuration for frontend and backend
- [X] T011 [P] Create scripts/validate-config.sh for workflow validation
- [X] T012 [P] Create scripts/test-automation.sh for integration testing framework
- [X] T013 [P] Setup example environment variables in .env.example (CLAUDE_CODE_OAUTH_TOKEN)
- [X] T014 Create .github/workflows/.gitkeep to ensure workflows directory exists

---

## Phase 3: US1 - Automated Code Quality Review (Priority: P1)

**Goal**: Developers get immediate AI-powered code review feedback on PRs within 2 minutes using Claude Code

**Independent Test**: Create test PR with intentional issues (null pointer, unused variables, security vulnerability) and verify Claude Code posts review comments within 2 minutes

**Checkpoint**: At this point, User Story 1 (Automated Code Review) should be fully functional - creating PRs triggers Claude Code review

- [X] T015 [US1] Create .github/workflows/pr-review.yml workflow file
- [X] T016 [US1] Configure PR trigger (on pull_request.opened) in pr-review.yml
- [X] T017 [US1] Add checkout step to get PR merge commit in pr-review.yml
- [X] T018 [US1] Add initial status comment step ("Review in progress...") in pr-review.yml
- [X] T019 [US1] Configure anthropics/claude-code-action@v1 step with OAuth token secret in pr-review.yml
- [X] T020 [US1] Add prompt configuration reading from .github/CLAUDE.md in pr-review.yml
- [X] T021 [US1] Implement review result posting step (handled by action automatically) in pr-review.yml
- [X] T022 [US1] Add error handling for usage limits with status comment in pr-review.yml
- [X] T023 [US1] Add timeout handling (10 minutes) with partial results in pr-review.yml
- [X] T024 [US1] Configure workflow permissions (contents: read, pull-requests: write) in pr-review.yml
- [X] T025 [US1] Add inline YAML comments explaining each step in pr-review.yml
- [X] T026 [US1] Update README.md with section on automated code review feature and usage

---

## Phase 4: US2 - AI-Assisted Code Improvements (Priority: P1)

**Goal**: Developers can request AI to apply code fixes via PR comments (@claude apply) and receive commits within 5 minutes

**Independent Test**: Create PR with review comments, post "@claude apply" command, verify commits are pushed with fixes within 5 minutes

**Checkpoint**: At this point, User Story 2 (AI-Assisted Fixes) should be fully functional - developers can trigger Claude Code to apply fixes via comments

- [X] T027 [US2] Create .github/workflows/ai-comment.yml workflow file
- [X] T028 [US2] Configure issue_comment trigger with PR filter in ai-comment.yml
- [X] T029 [US2] Add comment body parsing logic for @claude commands in ai-comment.yml
- [X] T030 [US2] Add checkout step with write access to PR branch in ai-comment.yml
- [X] T031 [US2] Add acknowledgment comment step ("Processing request...") in ai-comment.yml
- [X] T032 [US2] Configure anthropics/claude-code-action@v1 step with OAuth token secret and mode:'apply' in ai-comment.yml
- [X] T033 [US2] Add .github/CLAUDE.md configuration reading in ai-comment.yml
- [X] T034 [US2] Implement commit creation with bot attribution in ai-comment.yml
- [X] T035 [US2] Add git commit with conventional commit format and reference links in ai-comment.yml
- [X] T036 [US2] Implement result summary comment with changes made in ai-comment.yml
- [X] T037 [US2] Add conflict detection and error handling in ai-comment.yml
- [X] T038 [US2] Configure workflow permissions (contents: write, pull-requests: write) in ai-comment.yml
- [X] T039 [US2] Add support for multiple command variants (@claude fix, @claude explain) in ai-comment.yml
- [X] T040 [US2] Add inline YAML comments explaining each step in ai-comment.yml
- [X] T041 [US2] Update README.md with section on AI-assisted fixes and command usage

---

## Phase 5: US3 - Intelligent Build Optimization (Priority: P2)

**Goal**: CI/CD pipelines only build and test affected monorepo components, achieving 40% time reduction

**Independent Test**: Make frontend-only changes and verify only frontend CI runs; make backend-only changes and verify only backend CI runs

**Checkpoint**: At this point, User Story 3 (Intelligent CI) should be fully functional - path filtering ensures only relevant builds execute

- [X] T042 [P] [US3] Create .github/workflows/frontend-ci.yml workflow file
- [X] T043 [P] [US3] Create .github/workflows/backend-ci.yml workflow file
- [X] T044 [P] [US3] Configure path filters (frontend/**) in frontend-ci.yml
- [X] T045 [P] [US3] Configure path filters (backend/**) in backend-ci.yml
- [X] T046 [P] [US3] Add checkout step in frontend-ci.yml
- [X] T047 [P] [US3] Add checkout step in backend-ci.yml
- [X] T048 [P] [US3] Configure Node.js setup with caching in frontend-ci.yml
- [X] T049 [P] [US3] Configure Node.js/Python setup with caching in backend-ci.yml
- [X] T050 [P] [US3] Add dependency installation step (npm ci) in frontend-ci.yml
- [X] T051 [P] [US3] Add dependency installation step (npm ci or pip install) in backend-ci.yml
- [X] T052 [P] [US3] Add lint step (npm run lint) in frontend-ci.yml
- [X] T053 [P] [US3] Add lint step in backend-ci.yml
- [X] T054 [P] [US3] Add test step (npm test) with coverage in frontend-ci.yml
- [X] T055 [P] [US3] Add test step with coverage in backend-ci.yml
- [X] T056 [P] [US3] Add build step (npm run build) in frontend-ci.yml
- [X] T057 [P] [US3] Add build step in backend-ci.yml
- [X] T058 [P] [US3] Add artifact upload for frontend build in frontend-ci.yml
- [X] T059 [P] [US3] Add artifact upload for backend build in backend-ci.yml
- [X] T060 [P] [US3] Add failure reporting with PR comment in frontend-ci.yml
- [X] T061 [P] [US3] Add failure reporting with PR comment in backend-ci.yml
- [X] T062 [P] [US3] Configure workflow permissions (contents: read, pull-requests: write) in frontend-ci.yml
- [X] T063 [P] [US3] Configure workflow permissions (contents: read, pull-requests: write) in backend-ci.yml
- [X] T064 [P] [US3] Add timeout configuration (10 minutes) in frontend-ci.yml
- [X] T065 [P] [US3] Add timeout configuration (10 minutes) in backend-ci.yml
- [X] T066 [US3] Update README.md with section on intelligent CI/CD and path filtering

---

## Phase 6: US4 - Automatic Documentation Sync (Priority: P2)

**Goal**: Documentation automatically updates when code changes are merged to main, creating doc PRs within 10 minutes

**Independent Test**: Merge PR adding new API endpoint, verify documentation PR is created within 10 minutes with endpoint documentation

**Checkpoint**: At this point, User Story 4 (Doc Sync) should be fully functional - code merges trigger documentation updates

- [ ] T067 [US4] Create .github/workflows/docs-sync.yml workflow file
- [ ] T068 [US4] Configure push trigger on main branch with code path filters in docs-sync.yml
- [ ] T069 [US4] Add checkout step for full repository in docs-sync.yml
- [ ] T070 [US4] Add git diff extraction for changed files since last doc update in docs-sync.yml
- [ ] T071 [US4] Add changed file analysis logic (identify functions, endpoints, models) in docs-sync.yml
- [ ] T072 [US4] Configure anthropics/claude-code-action@v1 with mode:'document' for documentation generation in docs-sync.yml
- [ ] T073 [US4] Add prompt for documentation updates based on code changes in docs-sync.yml
- [ ] T074 [US4] Implement skip logic if no documentation impact detected in docs-sync.yml
- [ ] T075 [US4] Configure peter-evans/create-pull-request@v5 for doc PR creation in docs-sync.yml
- [ ] T076 [US4] Add PR body with reference to triggering commit in docs-sync.yml
- [ ] T077 [US4] Add docs: prefix and auto-labels to documentation PRs in docs-sync.yml
- [ ] T078 [US4] Configure workflow permissions (contents: write, pull-requests: write) in docs-sync.yml
- [ ] T079 [US4] Add inline YAML comments explaining documentation sync process in docs-sync.yml
- [ ] T080 [US4] Create example docs/api/endpoints.md with API documentation template
- [ ] T081 [US4] Update README.md with section on automatic documentation sync

---

## Phase 7: US5 - Proactive Dependency Management (Priority: P3)

**Goal**: Weekly automated dependency update PRs with release notes and test results

**Independent Test**: Configure weekly schedule, wait for scheduled run, verify PRs created for outdated dependencies with labels and test results

**Checkpoint**: At this point, User Story 5 (Dependency Management) should be fully functional - Dependabot creates weekly PRs

- [X] T082 [US5] Configure package-ecosystem: npm for frontend in .github/dependabot.yml
- [X] T083 [US5] Configure package-ecosystem: npm for backend in .github/dependabot.yml
- [X] T084 [US5] Set schedule interval to weekly in .github/dependabot.yml
- [X] T085 [US5] Configure separate update times for frontend and backend in .github/dependabot.yml
- [X] T086 [US5] Add version strategy configuration in .github/dependabot.yml
- [X] T087 [US5] Configure PR limits per ecosystem in .github/dependabot.yml
- [X] T088 [US5] Add commit message prefix configuration in .github/dependabot.yml
- [X] T089 [US5] Configure labels for dependency PRs in .github/dependabot.yml
- [X] T090 [US5] Add reviewers configuration (optional) in .github/dependabot.yml
- [X] T091 [US5] Add ignore/allow configuration for specific dependencies in .github/dependabot.yml
- [X] T092 [US5] Update README.md with section on dependency management and configuration options

---

## Phase 8: US6 - Visual Project Tracking (Priority: P3)

**Goal**: GitHub Projects board automatically updates issue status based on PR lifecycle events

**Independent Test**: Create issue, verify appears in Todo; create PR referencing issue, verify moves to In Progress; merge PR, verify moves to Done

**Checkpoint**: At this point, User Story 6 (Project Tracking) should be fully functional - issues auto-move on project board

- [X] T093 [US6] Create docs/github-projects-setup.md with project board configuration instructions
- [X] T094 [US6] Document built-in automation rules (issue opened → Todo, PR merged → Done) in github-projects-setup.md
- [X] T095 [US6] Create .github/workflows/project-board-automation.yml for custom rules (optional)
- [X] T096 [US6] Add issue opened trigger with project add logic in project-board-automation.yml
- [X] T097 [US6] Add PR opened trigger with issue status update using GitHub CLI in project-board-automation.yml
- [X] T098 [US6] Add PR closed/merged trigger with issue completion logic in project-board-automation.yml
- [X] T099 [US6] Configure GitHub CLI (gh) authentication in project-board-automation.yml
- [X] T100 [US6] Add error handling for API failures with fallback to manual updates in project-board-automation.yml
- [X] T101 [US6] Configure workflow permissions (issues: write, projects: write) in project-board-automation.yml
- [X] T102 [US6] Add inline YAML comments explaining project automation in project-board-automation.yml
- [X] T103 [US6] Update README.md with section on project board automation

---

## Phase 9: Deployment Automation

**Purpose**: Deploy frontend and backend independently when changes are merged to main

- [X] T104 [P] Create .github/workflows/deploy.yml workflow file
- [X] T105 [P] Configure push trigger on main branch in deploy.yml
- [X] T106 [P] Add path detection for frontend changes in deploy.yml
- [X] T107 [P] Add path detection for backend changes in deploy.yml
- [X] T108 [P] Create frontend deployment job with Vercel integration in deploy.yml
- [X] T109 [P] Create backend deployment job with Docker build/push in deploy.yml
- [X] T110 [P] Configure amondnet/vercel-action for frontend deployment in deploy.yml
- [X] T111 [P] Configure docker/build-push-action for backend deployment in deploy.yml
- [X] T112 [P] Add deployment secrets documentation (VERCEL_TOKEN, etc.) in deploy.yml comments
- [X] T113 [P] Add deployment status reporting in deploy.yml
- [X] T114 [P] Configure workflow permissions (contents: read, packages: write) in deploy.yml
- [X] T115 Update README.md with section on deployment automation and configuration

---

## Phase 10: Polish & Cross-Cutting Concerns

**Purpose**: Complete documentation, validation, and final touches

- [X] T116 [P] Enhance README.md with complete feature overview, screenshots/diagrams, and troubleshooting section
- [X] T117 [P] Create docs/architecture.md explaining workflow integration and data flows
- [X] T118 [P] Create docs/troubleshooting.md with common issues and solutions
- [X] T119 [P] Add workflow syntax validation to scripts/validate-config.sh
- [X] T120 [P] Implement integration test for PR review → Fix → CI chain in scripts/test-automation.sh
- [X] T121 [P] Create .github/workflows/template-validation.yml to validate template on changes
- [X] T122 [P] Add cost estimation documentation in docs/cost-analysis.md with Claude Max subscription details
- [X] T123 [P] Create docs/customization-guide.md for adapting template to different tech stacks
- [X] T124 [P] Add security best practices documentation in docs/security.md
- [X] T125 [P] Populate .github/CLAUDE.md with comprehensive example code review and fix guidelines
- [X] T126 [P] Create frontend/src/ example component structure with sample code
- [X] T127 [P] Create backend/src/ example API structure with sample code
- [X] T128 [P] Add pull request template in .github/pull_request_template.md
- [X] T129 [P] Add issue templates in .github/ISSUE_TEMPLATE/ directory
- [X] T130 [P] Create CHANGELOG.md template for version tracking
- [X] T131 [P] Add GitHub repository template configuration in template metadata
- [X] T132 Validate all workflows against quickstart.md test scenarios
- [X] T133 Final review: Ensure all paths, secrets (CLAUDE_CODE_OAUTH_TOKEN), and configurations are consistent

---

## Task Summary

**Total Tasks**: 133
**By Phase**:
- Phase 1 (Setup): 9 tasks
- Phase 2 (Foundational): 5 tasks
- Phase 3 (US1 - Code Review): 12 tasks
- Phase 4 (US2 - AI Fixes): 15 tasks
- Phase 5 (US3 - Intelligent CI): 25 tasks
- Phase 6 (US4 - Doc Sync): 15 tasks
- Phase 7 (US5 - Dependencies): 11 tasks
- Phase 8 (US6 - Project Boards): 11 tasks
- Phase 9 (Deployment): 12 tasks
- Phase 10 (Polish): 18 tasks

**Parallel Opportunities**: 65 tasks marked [P] can run in parallel (49%)

---

## Dependencies & Execution Order

### Story Completion Order

```
Setup (Phase 1) → Foundational (Phase 2)
    ↓
[US1 Code Review] ← Independent (can start after Phase 2)
    ↓
[US2 AI Fixes] ← Depends on US1 (needs review workflow to provide context)
    ↓
[US3 Intelligent CI] ← Independent (can run parallel with US1/US2)
[US4 Doc Sync] ← Independent (can run parallel with US1/US2/US3)
[US5 Dependencies] ← Independent (can run parallel with US1/US2/US3/US4)
[US6 Project Boards] ← Independent (can run parallel with all)
    ↓
Deployment (Phase 9) ← Can start after US3 completes
    ↓
Polish (Phase 10) ← Starts after core stories complete
```

### Critical Path
Setup → Foundational → US1 → US2 → Deployment → Polish (47 tasks)

### Parallel Execution Example (After Phase 2)
- **Team A**: US1 Code Review (T015-T026)
- **Team B**: US3 Intelligent CI (T042-T066)
- **Team C**: US5 Dependencies (T082-T092)
- **Team D**: US6 Project Boards (T093-T103)

---

## MVP Scope

**Minimum Viable Product** (First Release):
- Phase 1: Setup (T001-T009)
- Phase 2: Foundational (T010-T014)
- **Phase 3: US1 - Code Review** (T015-T026) ← Core value
- **Phase 4: US2 - AI Fixes** (T027-T041) ← Completes automation loop

**MVP Task Count**: 41 tasks
**Estimated Timeline**: 2-3 weeks for MVP

**Post-MVP Increments**:
- **Release 2**: Add US3 (Intelligent CI) - 25 tasks
- **Release 3**: Add US4 (Doc Sync) - 15 tasks
- **Release 4**: Add US5 + US6 (Dependencies + Project Boards) - 22 tasks
- **Release 5**: Add Deployment + Polish - 30 tasks

---

## Implementation Strategy

1. **Start with MVP** (US1 + US2): Deliver core AI-powered code review and fixes first
2. **Independent stories**: US3, US4, US5, US6 can be implemented in parallel by different teams
3. **Incremental delivery**: Each user story is independently testable and deliverable
4. **Parallel execution**: Maximize parallelism within each phase (49% of tasks can run in parallel)
5. **OAuth-first**: All AI workflows use single Claude Code OAuth token (no API costs)

---

## Key Technical Notes

**Authentication**:
- Single OAuth token: `CLAUDE_CODE_OAUTH_TOKEN` (from Claude Max subscription)
- No API costs - uses existing subscription
- Generated via `/install-github-app` command

**Configuration**:
- Single config file: `.github/CLAUDE.md` (covers both code review AND AI fixes)
- No separate AGENTS.md or multiple API keys

**AI Service**:
- Claude Code used for both US1 (review) and US2 (fixes)
- Same `anthropics/claude-code-action@v1` with different modes
- Simplified architecture: one service instead of two
