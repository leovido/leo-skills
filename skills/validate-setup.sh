#!/bin/bash

# Validation script to test the setup script
# This script creates a test environment and runs the setup script

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Create test directory
TEST_DIR=$(mktemp -d -t leo-skills-test-XXXXXX)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_info "Creating test environment in: $TEST_DIR"
cd "$TEST_DIR"

# Copy setup script
cp "$SCRIPT_DIR/setup.sh" .
chmod +x setup.sh

# Test 1: Empty directory (no package.json)
print_info "Test 1: Running setup on empty directory..."
mkdir test1
cd test1
if ../setup.sh > /dev/null 2>&1; then
    print_success "Test 1 passed: Setup works on empty directory"
else
    print_error "Test 1 failed: Setup failed on empty directory"
    exit 1
fi
cd ..

# Test 2: With package.json
print_info "Test 2: Running setup with package.json..."
mkdir test2
cd test2
cat > package.json << 'EOF'
{
  "name": "test-project",
  "version": "1.0.0"
}
EOF
if ../setup.sh > /dev/null 2>&1; then
    print_success "Test 2 passed: Setup works with package.json"
else
    print_error "Test 2 failed: Setup failed with package.json"
    exit 1
fi
cd ..

# Test 3: Verify files were created
print_info "Test 3: Verifying created files..."
cd test2

REQUIRED_FILES=(
    ".gitignore"
    ".env.example"
    "tsconfig.json"
    "lefthook.yml"
)

MISSING_FILES=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "Found: $file"
    else
        print_error "Missing: $file"
        ((MISSING_FILES++))
    fi
done

if [ $MISSING_FILES -eq 0 ]; then
    print_success "Test 3 passed: All required files created"
else
    print_error "Test 3 failed: $MISSING_FILES file(s) missing"
    exit 1
fi

cd ..

# Test 4: Verify directory structure
print_info "Test 4: Verifying directory structure..."
cd test2

REQUIRED_DIRS=(
    "src"
    "src/domains"
    "src/shared"
    ".github/workflows"
)

MISSING_DIRS=0
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_success "Found directory: $dir"
    else
        print_error "Missing directory: $dir"
        ((MISSING_DIRS++))
    fi
done

if [ $MISSING_DIRS -eq 0 ]; then
    print_success "Test 4 passed: All required directories created"
else
    print_error "Test 4 failed: $MISSING_DIRS directory(ies) missing"
    exit 1
fi

cd ..

# Cleanup
print_info "Cleaning up test environment..."
rm -rf "$TEST_DIR"
print_success "Validation complete! All tests passed."

