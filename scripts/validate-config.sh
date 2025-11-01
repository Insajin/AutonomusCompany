#!/bin/bash
# Workflow Configuration Validation Script
# Validates GitHub Actions workflow YAML files for syntax and best practices

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

echo "🔍 Validating GitHub Actions Workflows..."
echo ""

# Check if workflows directory exists
if [ ! -d ".github/workflows" ]; then
    echo -e "${RED}❌ .github/workflows directory not found${NC}"
    exit 1
fi

# Function to validate YAML syntax
validate_yaml_syntax() {
    local file=$1
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    # Check if js-yaml is installed
    if command -v js-yaml &> /dev/null; then
        if js-yaml "$file" &> /dev/null; then
            echo -e "${GREEN}✓${NC} YAML syntax valid: $(basename "$file")"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
            return 0
        else
            echo -e "${RED}✗${NC} YAML syntax error: $(basename "$file")"
            js-yaml "$file" 2>&1 | head -10
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
            return 1
        fi
    elif command -v yamllint &> /dev/null; then
        if yamllint -d relaxed "$file" &> /dev/null; then
            echo -e "${GREEN}✓${NC} YAML syntax valid: $(basename "$file")"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
            return 0
        else
            echo -e "${RED}✗${NC} YAML syntax error: $(basename "$file")"
            yamllint -d relaxed "$file"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
            return 1
        fi
    else
        # No YAML validator available - skip validation
        echo -e "${YELLOW}⚠${NC} No YAML validator found (install js-yaml or yamllint)"
        return 0
    fi
}

# Function to check for required fields
check_required_fields() {
    local file=$1
    local filename=$(basename "$file")

    echo ""
    echo "📋 Checking required fields in $filename..."

    # Check for 'name' field
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if grep -q "^name:" "$file"; then
        echo -e "${GREEN}✓${NC} Has 'name' field"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${YELLOW}⚠${NC} Missing 'name' field (recommended)"
    fi

    # Check for 'on' field (triggers)
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if grep -q "^on:" "$file"; then
        echo -e "${GREEN}✓${NC} Has 'on' field (triggers)"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${RED}✗${NC} Missing 'on' field (required)"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi

    # Check for 'jobs' field
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if grep -q "^jobs:" "$file"; then
        echo -e "${GREEN}✓${NC} Has 'jobs' field"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${RED}✗${NC} Missing 'jobs' field (required)"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
}

# Function to check for security best practices
check_security_practices() {
    local file=$1
    local filename=$(basename "$file")

    echo ""
    echo "🔒 Checking security best practices in $filename..."

    # Check for permissions configuration
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if grep -q "permissions:" "$file"; then
        echo -e "${GREEN}✓${NC} Has 'permissions' defined (least privilege)"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${YELLOW}⚠${NC} No 'permissions' defined (consider adding for security)"
    fi

    # Check for hardcoded secrets (anti-pattern)
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if grep -E "(password|token|api[-_]?key|secret).*:" "$file" | grep -v "secrets\." | grep -v "^#" > /dev/null; then
        echo -e "${RED}✗${NC} Potential hardcoded secrets detected!"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    else
        echo -e "${GREEN}✓${NC} No hardcoded secrets detected"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    fi
}

# Function to check for timeout configuration
check_timeout_config() {
    local file=$1
    local filename=$(basename "$file")

    echo ""
    echo "⏱️  Checking timeout configuration in $filename..."

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if grep -q "timeout-minutes:" "$file"; then
        echo -e "${GREEN}✓${NC} Has timeout configured (prevents stuck jobs)"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${YELLOW}⚠${NC} No timeout configured (recommended to prevent stuck jobs)"
    fi
}

# Main validation loop
for workflow_file in .github/workflows/*.yml .github/workflows/*.yaml; do
    if [ -f "$workflow_file" ]; then
        echo "════════════════════════════════════════"
        echo "Validating: $(basename "$workflow_file")"
        echo "════════════════════════════════════════"

        validate_yaml_syntax "$workflow_file"
        check_required_fields "$workflow_file"
        check_security_practices "$workflow_file"
        check_timeout_config "$workflow_file"

        echo ""
    fi
done

# Summary
echo "════════════════════════════════════════"
echo "📊 Validation Summary"
echo "════════════════════════════════════════"
echo "Total checks: $TOTAL_CHECKS"
echo -e "${GREEN}Passed: $PASSED_CHECKS${NC}"
if [ $FAILED_CHECKS -gt 0 ]; then
    echo -e "${RED}Failed: $FAILED_CHECKS${NC}"
else
    echo "Failed: $FAILED_CHECKS"
fi
echo ""

# Exit with error if any checks failed
if [ $FAILED_CHECKS -gt 0 ]; then
    echo -e "${RED}❌ Validation failed. Please fix the errors above.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All validations passed!${NC}"
    exit 0
fi
