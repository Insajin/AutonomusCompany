#!/bin/bash

# Codebase Analysis Helper Script
# Gathers statistics and context for Claude Code feature analysis

set -e

echo "🔍 Analyzing codebase..."
echo ""

# Repository Information
echo "## Repository Information"
echo ""
echo "**Repository**: $(git remote get-url origin 2>/dev/null || echo 'Not a git repository')"
echo "**Branch**: $(git branch --show-current 2>/dev/null || echo 'unknown')"
echo "**Last Commit**: $(git log -1 --format='%h - %s (%cr)' 2>/dev/null || echo 'N/A')"
echo ""

# File Statistics
echo "## File Statistics"
echo ""

if [ -d "frontend" ]; then
  FRONTEND_FILES=$(find frontend -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) 2>/dev/null | wc -l)
  FRONTEND_LINES=$(find frontend -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
  echo "**Frontend**:"
  echo "- Files: $FRONTEND_FILES"
  echo "- Lines of code: $FRONTEND_LINES"
  echo ""
fi

if [ -d "backend" ]; then
  BACKEND_FILES=$(find backend -type f \( -name "*.go" -o -name "*.js" -o -name "*.ts" -o -name "*.py" \) 2>/dev/null | wc -l)
  BACKEND_LINES=$(find backend -type f \( -name "*.go" -o -name "*.js" -o -name "*.ts" -o -name "*.py" \) -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
  echo "**Backend**:"
  echo "- Files: $BACKEND_FILES"
  echo "- Lines of code: $BACKEND_LINES"
  echo ""
fi

WORKFLOW_FILES=$(find .github/workflows -type f -name "*.yml" 2>/dev/null | wc -l)
echo "**Workflows**: $WORKFLOW_FILES GitHub Actions workflows"
echo ""

# Technology Stack
echo "## Technology Stack"
echo ""

if [ -f "package.json" ]; then
  echo "**Frontend Framework**: $(cat package.json | grep '"next"' > /dev/null && echo "Next.js" || (cat package.json | grep '"react"' > /dev/null && echo "React" || echo "Node.js"))"
fi

if [ -f "frontend/package.json" ]; then
  echo "**Frontend Framework**: $(cat frontend/package.json | grep '"next"' > /dev/null && echo "Next.js" || (cat frontend/package.json | grep '"react"' > /dev/null && echo "React" || echo "Node.js"))"
fi

if [ -f "backend/go.mod" ]; then
  echo "**Backend Language**: Go"
  GO_VERSION=$(grep "^go " backend/go.mod | awk '{print $2}')
  echo "**Go Version**: $GO_VERSION"
elif [ -f "backend/package.json" ]; then
  echo "**Backend Framework**: Node.js"
elif [ -f "backend/requirements.txt" ]; then
  echo "**Backend Language**: Python"
fi

if [ -f ".github/workflows/codeql.yml" ]; then
  echo "**Security**: CodeQL enabled"
fi

echo ""

# Recent Activity
echo "## Recent Activity"
echo ""

echo "**Recent Commits** (last 5):"
git log -5 --pretty=format:"- %h: %s (%cr by %an)" 2>/dev/null || echo "No git history"
echo ""
echo ""

# Open Issues and PRs
if command -v gh &> /dev/null; then
  OPEN_ISSUES=$(gh issue list --state open --limit 1000 --json number 2>/dev/null | grep -o '"number"' | wc -l || echo "0")
  OPEN_PRS=$(gh pr list --state open --limit 1000 --json number 2>/dev/null | grep -o '"number"' | wc -l || echo "0")

  echo "**Open Issues**: $OPEN_ISSUES"
  echo "**Open PRs**: $OPEN_PRS"
  echo ""
fi

# Code Quality Indicators
echo "## Code Quality Indicators"
echo ""

# Check for common patterns
if [ -d "frontend" ] || [ -d "backend" ]; then
  TODO_COUNT=$(grep -r "TODO" frontend/ backend/ 2>/dev/null | wc -l || echo "0")
  FIXME_COUNT=$(grep -r "FIXME" frontend/ backend/ 2>/dev/null | wc -l || echo "0")
  echo "**TODOs in code**: $TODO_COUNT"
  echo "**FIXMEs in code**: $FIXME_COUNT"
  echo ""
fi

# Test Coverage
if [ -f "coverage/coverage-summary.json" ]; then
  echo "**Test Coverage**: Available (see coverage/coverage-summary.json)"
elif [ -d "coverage" ]; then
  echo "**Test Coverage**: Reports available in coverage/"
else
  echo "**Test Coverage**: No coverage reports found"
fi
echo ""

# Dependencies
echo "## Dependencies"
echo ""

if [ -f "package.json" ]; then
  DEP_COUNT=$(cat package.json | grep -A 1000 '"dependencies"' | grep -B 1000 '}' | grep ':' | wc -l)
  echo "**NPM Dependencies**: ~$DEP_COUNT packages (root)"
fi

if [ -f "frontend/package.json" ]; then
  FRONTEND_DEP=$(cat frontend/package.json | grep -A 1000 '"dependencies"' | grep -B 1000 '}' | grep ':' | wc -l)
  echo "**Frontend Dependencies**: ~$FRONTEND_DEP packages"
fi

if [ -f "backend/go.mod" ]; then
  BACKEND_DEP=$(cat backend/go.mod | grep -c "require" || echo "0")
  echo "**Backend Dependencies**: ~$BACKEND_DEP Go modules"
fi

echo ""

# Documentation
echo "## Documentation"
echo ""

DOC_FILES=$(find . -type f -name "*.md" ! -path "./node_modules/*" ! -path "./.git/*" 2>/dev/null | wc -l)
echo "**Markdown files**: $DOC_FILES"

if [ -f "README.md" ]; then
  echo "- ✅ README.md present"
else
  echo "- ❌ README.md missing"
fi

if [ -f "CONTRIBUTING.md" ]; then
  echo "- ✅ CONTRIBUTING.md present"
else
  echo "- ⚠️  CONTRIBUTING.md missing"
fi

if [ -f "CLAUDE.md" ]; then
  echo "- ✅ CLAUDE.md present"
else
  echo "- ⚠️  CLAUDE.md missing"
fi

if [ -d "docs" ]; then
  DOCS_COUNT=$(find docs -type f -name "*.md" 2>/dev/null | wc -l)
  echo "- ✅ docs/ directory with $DOCS_COUNT files"
else
  echo "- ⚠️  docs/ directory missing"
fi

echo ""

# Workflows Analysis
echo "## Workflows Analysis"
echo ""

if [ -d ".github/workflows" ]; then
  echo "**Active Workflows**:"
  for workflow in .github/workflows/*.yml; do
    WORKFLOW_NAME=$(grep "^name:" "$workflow" | head -1 | sed 's/name: //' | tr -d '"' | tr -d "'")
    echo "- $WORKFLOW_NAME"
  done
  echo ""

  # Check for specific automation
  if grep -q "anthropics/claude-code-action" .github/workflows/*.yml 2>/dev/null; then
    echo "- ✅ Claude Code integration active"
  fi

  if grep -q "dependabot" .github/dependabot.yml 2>/dev/null; then
    echo "- ✅ Dependabot configured"
  fi

  if grep -q "codeql" .github/workflows/*.yml 2>/dev/null; then
    echo "- ✅ CodeQL security scanning active"
  fi
fi

echo ""

# Potential Improvements
echo "## Potential Improvement Areas"
echo ""

# Check for missing common files
SUGGESTIONS=()

if [ ! -f ".gitignore" ]; then
  SUGGESTIONS+=("⚠️  Missing .gitignore file")
fi

if [ ! -f ".editorconfig" ]; then
  SUGGESTIONS+=("💡 Consider adding .editorconfig for consistent formatting")
fi

if [ ! -f "LICENSE" ]; then
  SUGGESTIONS+=("⚠️  Missing LICENSE file")
fi

if [ ! -d "tests" ] && [ ! -d "test" ] && [ ! -d "__tests__" ]; then
  SUGGESTIONS+=("⚠️  No tests directory found")
fi

if [ ${#SUGGESTIONS[@]} -eq 0 ]; then
  echo "✅ No obvious missing files detected"
else
  for suggestion in "${SUGGESTIONS[@]}"; do
    echo "$suggestion"
  done
fi

echo ""
echo "---"
echo ""
echo "✅ Analysis complete!"
echo ""
echo "This summary provides context for automated feature suggestions."
echo "Use this information to identify improvement opportunities."
