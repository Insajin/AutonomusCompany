# Claude Code Feature Analysis Prompt Template

This template guides Claude Code in analyzing the codebase and generating feature suggestions.

## Analysis Guidelines

### 1. Codebase Context

Before suggesting features, analyze:

- **Current Architecture**: Understand the project structure, patterns, and technologies
- **Recent Changes**: Review recent commits to understand development direction
- **Existing Issues**: Check for common pain points or requested improvements
- **Code Quality**: Identify areas with technical debt or complexity
- **Test Coverage**: Note areas lacking adequate testing
- **Documentation**: Identify documentation gaps

### 2. Suggestion Categories

Generate suggestions in these areas:

#### 🆕 New Features

- User-facing functionality that adds value
- Integration with new tools or services
- Enhanced capabilities for existing features
- Features that align with project goals

**Focus on**:

- User needs and pain points
- Competitive advantages
- Scalability and future growth
- User experience improvements

#### 🔧 Code Improvements

- Refactoring for better maintainability
- Performance optimizations
- Security enhancements
- Modernizing legacy code
- Reducing technical debt

**Focus on**:

- Code quality metrics
- Complexity reduction
- Better error handling
- Improved type safety
- Design pattern adoption

#### ⚙️ Automation Workflows

- New GitHub Actions workflows
- Developer productivity tools
- CI/CD enhancements
- Automated testing improvements
- Deployment automation

**Focus on**:

- Time savings
- Error reduction
- Consistency
- Developer experience
- Cost optimization

#### 📚 Documentation

- Missing API documentation
- Setup guides
- Architecture diagrams
- Troubleshooting guides
- Code examples

**Focus on**:

- Onboarding experience
- Common questions
- Complex features
- Integration guides
- Best practices

### 3. Suggestion Structure

Each suggestion should include:

```markdown
## [Category Icon] Suggestion Title

**Category**: New Feature / Code Improvement / Automation / Documentation
**Priority**: Critical / High / Medium / Low
**Estimated Effort**: Small (< 4h) / Medium (1-2 days) / Large (3+ days)

### Problem Statement

[Clear description of the problem or opportunity]

### Proposed Solution

[Detailed explanation of how to address this]

### Benefits

- **User Impact**: [How this helps users]
- **Developer Experience**: [How this helps developers]
- **Technical Benefits**: [Performance, maintainability, etc.]
- **Business Value**: [ROI, competitive advantage, etc.]

### Implementation Approach

1. [High-level step 1]
2. [High-level step 2]
3. [High-level step 3]

**Files Affected**:

- `path/to/file1.ts` - [What changes]
- `path/to/file2.ts` - [What changes]

**Dependencies**:

- [External libraries needed]
- [Other features this depends on]

### Testing Strategy

- **Unit Tests**: [What to test]
- **Integration Tests**: [What to test]
- **Manual Testing**: [How to verify]

### Risks & Considerations

- **Breaking Changes**: [Any compatibility concerns]
- **Performance**: [Impact on performance]
- **Security**: [Security implications]
- **Complexity**: [Added complexity concerns]

### Alternative Approaches

[Other ways to solve this problem and why the proposed solution is preferred]
```

### 4. Prioritization Criteria

**Critical Priority** when:

- Security vulnerabilities exist
- Data loss risks present
- Breaking production issues
- Legal/compliance requirements

**High Priority** when:

- Significant user impact
- Major technical debt
- Blocking future development
- Competitive necessity

**Medium Priority** when:

- Incremental improvements
- Nice-to-have features
- Minor optimizations
- Quality of life enhancements

**Low Priority** when:

- Minor cosmetic changes
- Experimental features
- Future considerations
- Edge case handling

### 5. Quality Standards

Every suggestion must:

✅ **Be Specific**: Avoid vague suggestions like "improve performance"
✅ **Be Actionable**: Provide clear implementation path
✅ **Be Valuable**: Explain tangible benefits
✅ **Be Realistic**: Consider project constraints
✅ **Be Testable**: Include verification approach
✅ **Align with Project**: Match existing architecture and goals

❌ **Avoid**:

- Generic suggestions that apply to any project
- Features without clear user value
- Over-engineering for hypothetical needs
- Suggestions that conflict with project principles
- Changes that break backward compatibility without justification

### 6. Analysis Process

1. **Read Project Documentation**
   - README.md
   - CLAUDE.md
   - Architecture docs
   - Contributing guidelines

2. **Review Codebase Structure**
   - File organization
   - Naming conventions
   - Patterns used
   - Technology stack

3. **Analyze Recent Activity**
   - Recent commits
   - Open PRs
   - Recent issues
   - Discussion topics

4. **Identify Patterns**
   - Repeated code
   - Common issues
   - Missing abstractions
   - Inconsistencies

5. **Generate Suggestions**
   - Start with critical/high priority
   - Focus on quick wins
   - Include strategic improvements
   - Balance short and long term

6. **Format Output**
   - Use clear markdown
   - Group by category
   - Include all required sections
   - Add relevant examples

### 7. Example Output Format

```markdown
# 🤖 Weekly Feature Suggestions - [Date]

Claude Code has analyzed the codebase and identified **N** improvement opportunities:

## 🆕 New Features (X suggestions)

### 1. [Feature Title]

**Priority**: High | **Effort**: Medium

[Full suggestion using template above]

---

### 2. [Feature Title]

**Priority**: Medium | **Effort**: Small

[Full suggestion using template above]

---

## 🔧 Code Improvements (X suggestions)

[Similar structure]

## ⚙️ Automation Workflows (X suggestions)

[Similar structure]

## 📚 Documentation (X suggestions)

[Similar structure]

---

## Summary

- **Total Suggestions**: N
- **Critical**: X
- **High**: X
- **Medium**: X
- **Low**: X

**Recommended Focus**:

1. [Top priority suggestion]
2. [Second priority]
3. [Third priority]
```

### 8. Continuous Improvement

Each analysis should:

- Learn from previous suggestions (what was accepted/rejected)
- Avoid repeating rejected suggestions
- Build on implemented features
- Consider project evolution
- Adapt to changing priorities

---

## Usage in Workflows

This template is referenced by:

- `weekly-feature-suggestions.yml` - Weekly automated analysis
- `discussion-feedback.yml` - Refinement and clarification
- `implement-approved-feature.yml` - Detailed specification generation

When using this template:

1. Read and understand the project context
2. Follow the analysis process
3. Use the suggestion structure
4. Apply prioritization criteria
5. Ensure quality standards
6. Format output correctly

---

_This template ensures consistent, high-quality feature suggestions that align with project goals and provide actionable value._
