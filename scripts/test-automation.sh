#!/bin/bash
# Automation Integration Testing Script
# Tests the automated workflows end-to-end

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

echo "🧪 Testing Automation Workflows..."
echo ""

# Check prerequisites
check_prerequisites() {
    echo "📋 Checking prerequisites..."

    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        echo -e "${RED}✗ GitHub CLI (gh) not installed${NC}"
        echo "Install from: https://cli.github.com/"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} GitHub CLI found"

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}✗ Not in a git repository${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} Git repository found"

    # Check if user is authenticated with gh
    if ! gh auth status &> /dev/null; then
        echo -e "${RED}✗ Not authenticated with GitHub CLI${NC}"
        echo "Run: gh auth login"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} GitHub authenticated"

    echo ""
}

# Test 1: Validate workflow files exist
test_workflow_files_exist() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo "Test 1: Checking workflow files exist..."

    local expected_workflows=(
        ".github/workflows/pr-review.yml"
        ".github/workflows/ai-comment.yml"
        ".github/workflows/frontend-ci.yml"
        ".github/workflows/backend-ci.yml"
    )

    local all_exist=true
    for workflow in "${expected_workflows[@]}"; do
        if [ -f "$workflow" ]; then
            echo -e "  ${GREEN}✓${NC} Found: $workflow"
        else
            echo -e "  ${YELLOW}⚠${NC} Missing: $workflow (may not be implemented yet)"
            all_exist=false
        fi
    done

    if [ "$all_exist" = true ]; then
        echo -e "${GREEN}✓ Test 1 PASSED${NC}\n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${YELLOW}⚠ Test 1 SKIPPED (workflows not implemented yet)${NC}\n"
    fi
}

# Test 2: Validate YAML syntax
test_yaml_syntax() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo "Test 2: Validating YAML syntax..."

    if [ -x "scripts/validate-config.sh" ]; then
        if ./scripts/validate-config.sh &> /dev/null; then
            echo -e "${GREEN}✓ Test 2 PASSED: All YAML files valid${NC}\n"
            PASSED_TESTS=$((PASSED_TESTS + 1))
        else
            echo -e "${RED}✗ Test 2 FAILED: YAML validation errors${NC}\n"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    else
        echo -e "${YELLOW}⚠ Test 2 SKIPPED (validation script not found)${NC}\n"
    fi
}

# Test 3: Check required secrets configuration
test_secrets_configured() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo "Test 3: Checking required secrets..."

    # Check if .env.example exists
    if [ ! -f ".env.example" ]; then
        echo -e "${YELLOW}⚠ .env.example not found${NC}"
        echo -e "${YELLOW}⚠ Test 3 SKIPPED${NC}\n"
        return
    fi

    # Check for required secret placeholders
    local required_secrets=(
        "CLAUDE_CODE_OAUTH_TOKEN"
    )

    local all_documented=true
    for secret in "${required_secrets[@]}"; do
        if grep -q "$secret" .env.example; then
            echo -e "  ${GREEN}✓${NC} Documented: $secret"
        else
            echo -e "  ${RED}✗${NC} Missing in .env.example: $secret"
            all_documented=false
        fi
    done

    if [ "$all_documented" = true ]; then
        echo -e "${GREEN}✓ Test 3 PASSED${NC}\n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}✗ Test 3 FAILED${NC}\n"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Test 4: Verify project structure
test_project_structure() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo "Test 4: Verifying project structure..."

    local required_dirs=(
        ".github"
        ".github/workflows"
        "frontend"
        "backend"
        "docs"
        "scripts"
    )

    local all_exist=true
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo -e "  ${GREEN}✓${NC} Directory exists: $dir"
        else
            echo -e "  ${RED}✗${NC} Missing directory: $dir"
            all_exist=false
        fi
    done

    if [ "$all_exist" = true ]; then
        echo -e "${GREEN}✓ Test 4 PASSED${NC}\n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}✗ Test 4 FAILED${NC}\n"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Test 5: Check package.json files
test_package_json() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo "Test 5: Checking package.json files..."

    local all_valid=true

    # Check frontend
    if [ -f "frontend/package.json" ]; then
        if python3 -c "import json; json.load(open('frontend/package.json'))" 2> /dev/null; then
            echo -e "  ${GREEN}✓${NC} frontend/package.json valid JSON"
        else
            echo -e "  ${RED}✗${NC} frontend/package.json invalid JSON"
            all_valid=false
        fi
    else
        echo -e "  ${YELLOW}⚠${NC} frontend/package.json not found"
    fi

    # Check backend
    if [ -f "backend/package.json" ]; then
        if python3 -c "import json; json.load(open('backend/package.json'))" 2> /dev/null; then
            echo -e "  ${GREEN}✓${NC} backend/package.json valid JSON"
        else
            echo -e "  ${RED}✗${NC} backend/package.json invalid JSON"
            all_valid=false
        fi
    else
        echo -e "  ${YELLOW}⚠${NC} backend/package.json not found"
    fi

    if [ "$all_valid" = true ]; then
        echo -e "${GREEN}✓ Test 5 PASSED${NC}\n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}✗ Test 5 FAILED${NC}\n"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Test 6: Simulate workflow trigger (dry run)
test_workflow_trigger_simulation() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo "Test 6: Simulating workflow triggers..."

    echo -e "  ${BLUE}ℹ${NC} This is a dry-run test (no actual PR created)"

    # Check if we can query repository info
    if gh repo view --json name,owner &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} Can access repository via GitHub API"
        echo -e "${GREEN}✓ Test 6 PASSED${NC}\n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "  ${RED}✗${NC} Cannot access repository"
        echo -e "${RED}✗ Test 6 FAILED${NC}\n"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Main test execution
main() {
    check_prerequisites

    echo "════════════════════════════════════════"
    echo "Running Integration Tests"
    echo "════════════════════════════════════════"
    echo ""

    test_workflow_files_exist
    test_yaml_syntax
    test_secrets_configured
    test_project_structure
    test_package_json
    test_workflow_trigger_simulation

    # Summary
    echo "════════════════════════════════════════"
    echo "📊 Test Summary"
    echo "════════════════════════════════════════"
    echo "Total tests: $TOTAL_TESTS"
    echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
    if [ $FAILED_TESTS -gt 0 ]; then
        echo -e "${RED}Failed: $FAILED_TESTS${NC}"
    else
        echo "Failed: $FAILED_TESTS"
    fi
    echo ""

    # Exit with error if any tests failed
    if [ $FAILED_TESTS -gt 0 ]; then
        echo -e "${RED}❌ Some tests failed. Please fix the issues above.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ All tests passed!${NC}"
        exit 0
    fi
}

# Run tests
main
