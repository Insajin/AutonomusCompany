# Automated Feature Suggestion Workflow

This guide explains how the automated feature suggestion system works and how to use it effectively.

## Overview

The automated feature suggestion system uses Claude Code to continuously analyze your codebase and propose improvements. It operates on a weekly cycle, creating GitHub Discussions for team collaboration and automatically implementing approved suggestions.

## Table of Contents

1. [How It Works](#how-it-works)
2. [Weekly Analysis Process](#weekly-analysis-process)
3. [Interacting with Suggestions](#interacting-with-suggestions)
4. [Approval and Implementation](#approval-and-implementation)
5. [Commands Reference](#commands-reference)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)

## How It Works

### The Complete Flow

```
┌─────────────────────────────────────────────────────────────┐
│  Monday 09:00 UTC - Weekly Analysis Triggered               │
└─────────────────────────────┬───────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Claude Code Analyzes Codebase                              │
│  - Reviews code structure and patterns                      │
│  - Identifies improvement opportunities                     │
│  - Generates categorized suggestions                        │
└─────────────────────────────┬───────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  GitHub Discussion Created                                  │
│  - Suggestions posted with full details                     │
│  - Team notified via GitHub notifications                   │
└─────────────────────────────┬───────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Team Reviews and Discusses                                 │
│  - Comment with questions or feedback                       │
│  - Use @claude commands to refine suggestions               │
│  - Iterate until suggestion is clear                        │
└─────────────────────────────┬───────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Decision Made                                              │
│  - Add "approved" label → Implementation starts             │
│  - Add "rejected" label → Close discussion                  │
│  - Leave open → Continue discussion                         │
└─────────────────────────────┬───────────────────────────────┘
                              ↓ (if approved)
┌─────────────────────────────────────────────────────────────┐
│  Automatic Implementation                                   │
│  1. Detailed spec created in specs/                         │
│  2. Feature branch created                                  │
│  3. Code implementation generated                           │
│  4. Pull request created                                    │
└─────────────────────────────┬───────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Code Review & Merge                                        │
│  - Normal PR review process                                 │
│  - CI/CD validation                                         │
│  - Merge when ready                                         │
└─────────────────────────────────────────────────────────────┘
```

## Weekly Analysis Process

### What Gets Analyzed

Every Monday, Claude Code performs a comprehensive analysis:

1. **Code Quality**
   - Code complexity and maintainability
   - Duplication and refactoring opportunities
   - Type safety and error handling
   - Testing coverage gaps

2. **Architecture**
   - Component organization
   - Dependency structure
   - Design patterns usage
   - Scalability considerations

3. **Security**
   - Potential vulnerabilities
   - Authentication/authorization patterns
   - Data validation
   - Secure coding practices

4. **Performance**
   - Optimization opportunities
   - Resource usage
   - Caching strategies
   - Bundle size (frontend)

5. **Developer Experience**
   - Build processes
   - Testing workflows
   - Documentation quality
   - Automation opportunities

6. **Features**
   - Missing functionality
   - User experience improvements
   - Integration opportunities
   - Competitive features

### Suggestion Categories

Suggestions are categorized into four types:

#### 🆕 New Features

- User-facing functionality
- New integrations
- Enhanced capabilities
- Feature parity improvements

**Example**:

> **Add Dark Mode Support**
> Priority: Medium | Effort: Medium
>
> Implement system-wide dark mode toggle with persistent preferences, improving user experience especially for users in low-light environments.

#### 🔧 Code Improvements

- Refactoring opportunities
- Performance optimizations
- Security enhancements
- Technical debt reduction

**Example**:

> **Refactor Authentication Module**
> Priority: High | Effort: Large
>
> Extract authentication logic into reusable service layer, improving testability and reducing duplication across controllers.

#### ⚙️ Automation Workflows

- CI/CD enhancements
- GitHub Actions workflows
- Developer productivity tools
- Automated testing

**Example**:

> **Add Automated Accessibility Testing**
> Priority: Medium | Effort: Small
>
> Integrate axe-core into CI pipeline to catch accessibility issues early, ensuring WCAG compliance.

#### 📚 Documentation

- API documentation
- Setup guides
- Architecture docs
- Code examples

**Example**:

> **Create API Integration Guide**
> Priority: High | Effort: Small
>
> Comprehensive guide for third-party developers integrating with our API, reducing support burden and improving adoption.

## Interacting with Suggestions

### Available Commands

Use these commands in Discussion comments:

#### `@claude refine [your feedback]`

Refine a suggestion based on your feedback.

**Example**:

```
@claude refine
I like this idea, but we should also consider:
- Mobile responsive design
- Accessibility for screen readers
- Performance impact on low-end devices

Can you update the suggestion to address these points?
```

**Response**: Claude will update the suggestion with your considerations incorporated.

#### `@claude clarify [your question]`

Get clarification on specific aspects of the suggestion.

**Example**:

```
@claude clarify
How would this dark mode implementation handle:
1. User preference persistence?
2. System preference detection?
3. Transition animations?
```

**Response**: Claude will provide detailed answers to your questions.

#### `@claude analyze`

Request detailed feasibility and impact analysis.

**Example**:

```
@claude analyze
```

**Response**: Claude will provide:

- Technical feasibility assessment
- Implementation complexity analysis
- Potential risks and challenges
- Resource requirements
- Expected timeline
- Performance and security impact

### Discussion Best Practices

1. **Be Specific in Feedback**
   - Provide concrete examples
   - Explain your reasoning
   - Suggest alternatives if you disagree

2. **Ask Questions Early**
   - Clarify ambiguities before approval
   - Understand implementation approach
   - Consider edge cases and constraints

3. **Collaborate with Team**
   - Tag relevant team members
   - Share domain expertise
   - Discuss trade-offs openly

4. **Use Reactions**
   - 👍 for agreement
   - 👎 for disagreement
   - 🎯 for priority items
   - 🤔 for needs discussion

## Approval and Implementation

### Approval Process

When a suggestion is ready for implementation:

1. **Add the `approved` label**
   - This triggers the implementation workflow
   - No other action required

2. **Claude creates detailed specification**
   - Saved to `specs/NNN-feature-name/`
   - Includes full technical details
   - Links back to discussion

3. **Implementation PR is generated**
   - Feature branch created
   - Code implemented by Claude
   - Tests added
   - Documentation updated

4. **Standard review process**
   - Review code like any other PR
   - Run tests and verify functionality
   - Request changes if needed
   - Merge when approved

### Rejection Process

If a suggestion isn't suitable:

1. **Add the `rejected` label**
2. **Comment with explanation**
   - Why it doesn't fit
   - Alternative approaches considered
   - What would need to change for reconsideration

3. **Close the discussion** (optional)

### Deferral Process

If a suggestion has merit but isn't ready now:

1. **Add the `deferred` label**
2. **Comment with reasoning**
   - What needs to happen first
   - Dependencies or blockers
   - Timeline for reconsideration

3. **Keep discussion open** for future reference

## Commands Reference

### Quick Reference Table

| Command                      | Purpose                             | When to Use                             |
| ---------------------------- | ----------------------------------- | --------------------------------------- |
| `@claude refine [feedback]`  | Update suggestion based on feedback | Have specific improvements or concerns  |
| `@claude clarify [question]` | Get detailed explanation            | Need more information or have questions |
| `@claude analyze`            | Deep feasibility analysis           | Unsure about complexity or impact       |

### Command Examples

#### Refining for Scope

```
@claude refine
Let's break this into two phases:
Phase 1: Basic dark mode for main UI
Phase 2: Dark mode for admin panel and reports

Please update the suggestion to focus on Phase 1 only.
```

#### Clarifying Implementation

```
@claude clarify
What libraries or frameworks would you recommend for this?
Are there any existing solutions we should consider?
How does this integrate with our current theme system?
```

#### Analyzing Impact

```
@claude analyze

Specifically interested in:
- Performance impact on page load time
- Database schema changes required
- Breaking changes for existing API consumers
- Testing effort required
```

## Best Practices

### For Reviewers

1. **Review Weekly**
   - Check new suggestions every Monday
   - Triage within 2-3 days
   - Provide timely feedback

2. **Think Long-Term**
   - Consider maintenance burden
   - Evaluate alignment with roadmap
   - Assess technical debt impact

3. **Be Constructive**
   - Even when rejecting, explain why
   - Suggest alternatives or modifications
   - Encourage iteration

4. **Leverage AI**
   - Use `@claude` commands extensively
   - Iterate until suggestion is clear
   - Don't approve until confident

### For Maintainers

1. **Configure Analysis Focus**
   - Edit `.github/prompts/feature-analysis.md`
   - Adjust priority criteria
   - Customize suggestion structure

2. **Monitor Quality**
   - Review implemented features
   - Provide feedback on AI suggestions
   - Adjust prompts based on results

3. **Manage Volume**
   - Batch similar suggestions
   - Set priority thresholds
   - Defer low-priority items

4. **Track Metrics**
   - Acceptance rate
   - Implementation success rate
   - Time from suggestion to merge
   - Quality of implementations

## Troubleshooting

### Common Issues

#### No Discussion Created

**Symptoms**: Weekly workflow runs but no discussion appears

**Possible Causes**:

1. Discussions not enabled in repository
2. Invalid discussion category ID
3. Claude Max usage limit reached
4. OAuth token expired

**Solutions**:

**Quick Fix - Automated Setup**:

```bash
./scripts/setup-discussions.sh
```

This will automatically:

- Enable Discussions
- Create required labels
- Get and configure category ID
- Verify everything works

**Manual Fix**:

1. Enable Discussions in Settings → General → Features
2. Get category ID: `gh api graphql -f query='...'` (see README)
3. Update `.github/workflows/weekly-feature-suggestions.yml`
4. Check Claude Max subscription status
5. Regenerate OAuth token with `/install-github-app`

#### Refinement Commands Not Working

**Symptoms**: `@claude refine` doesn't update the suggestion

**Possible Causes**:

1. Command syntax incorrect
2. Workflow not triggered
3. Permissions issue

**Solutions**:

1. Verify exact command format
2. Check Actions tab for workflow run
3. Verify workflow has `discussions: write` permission

#### Implementation Fails

**Symptoms**: Approved suggestion doesn't generate PR

**Possible Causes**:

1. Specification too complex
2. Conflicting code changes
3. Missing dependencies

**Solutions**:

1. Break into smaller features
2. Review and merge pending PRs first
3. Manually verify dependencies are available
4. Check workflow logs for specific errors

#### Poor Quality Suggestions

**Symptoms**: Suggestions are too generic or off-target

**Possible Causes**:

1. Insufficient codebase context
2. Prompts need tuning
3. Recent changes not reflected

**Solutions**:

1. Ensure full git history available
2. Update `.github/prompts/feature-analysis.md`
3. Wait for next weekly run after major changes
4. Run manual analysis: trigger `workflow_dispatch`

### Getting Help

If you encounter issues:

1. **Check Workflow Logs**
   - Actions tab → Failed workflow
   - Review error messages
   - Check Claude Code output

2. **Review Documentation**
   - [README.md](../README.md)
   - [CLAUDE.md](../.github/CLAUDE.md)
   - [Workflow Files](../.github/workflows/)

3. **Ask in Discussions**
   - Create discussion with `question` label
   - Provide workflow run link
   - Include error messages

4. **Report Issues**
   - GitHub Issues for bugs
   - Include reproducible steps
   - Attach relevant logs

## Advanced Configuration

### Customizing Analysis Schedule

Edit `.github/workflows/weekly-feature-suggestions.yml`:

```yaml
on:
  schedule:
    # Run every Monday at 09:00 UTC
    - cron: "0 9 * * 1"
    # Add additional schedules:
    # - cron: '0 9 * * 4'  # Also Thursday
```

### Adjusting Suggestion Focus

Edit `.github/prompts/feature-analysis.md` to:

- Add project-specific criteria
- Adjust priority thresholds
- Include custom categories
- Define quality standards

### Filtering Suggestions

Modify prompt in `weekly-feature-suggestions.yml`:

```yaml
prompt: |
  Analyze this codebase and suggest improvements.

  Focus specifically on:
  - Performance optimizations (high priority)
  - Security enhancements (critical priority)
  - Developer tooling (medium priority)

  Do NOT suggest:
  - UI/UX changes (we have a designer)
  - Database schema changes (in freeze period)
```

## Metrics and Success

### Tracking Effectiveness

Monitor these metrics:

1. **Suggestion Quality**
   - Acceptance rate (target: >30%)
   - Implementation success rate (target: >80%)
   - Time to approval (target: <1 week)

2. **Implementation Quality**
   - Tests passing on first PR
   - Revisions needed before merge
   - Production issues post-merge

3. **Team Engagement**
   - Comments per suggestion
   - Time to first feedback
   - Number of refinements requested

4. **Business Value**
   - Features delivered per quarter
   - Technical debt reduced
   - Developer productivity improvements

### Continuous Improvement

Based on metrics:

1. **Tune Prompts**
   - If acceptance rate low: Make suggestions more conservative
   - If quality low: Add more quality checks to prompts
   - If off-target: Provide more context in prompts

2. **Adjust Workflow**
   - If too many suggestions: Increase priority threshold
   - If too few: Broaden analysis scope
   - If timing wrong: Adjust schedule

3. **Refine Process**
   - Update team guidelines
   - Improve documentation
   - Share best practices

---

## Related Documentation

- [README.md](../README.md) - Main project documentation
- [CLAUDE.md](../.github/CLAUDE.md) - AI behavior configuration
- [Architecture](./architecture.md) - System design
- [Customization Guide](./customization-guide.md) - Adapting workflows

---

**Last Updated**: 2025-01-03
**Maintained By**: Project maintainers

For questions or suggestions about this workflow, create a discussion with the `question` label.
