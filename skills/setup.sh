#!/bin/bash

# Development Skills Setup Script
# This script automates the setup of a new project based on SKILLS.md best practices

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track failures for summary
FAILURES=0
WARNINGS=0

# Functions
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++)) || true
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((FAILURES++)) || true
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Safe command execution with error handling
safe_run() {
    local description="$1"
    shift
    print_info "$description"
    if "$@" > /dev/null 2>&1; then
        print_success "$description"
        return 0
    else
        print_error "$description failed"
        return 1
    fi
}

# Verify file was created
verify_file() {
    if [ -f "$1" ]; then
        return 0
    else
        print_error "Failed to create: $1"
        return 1
    fi
}

# Verify directory was created
verify_dir() {
    if [ -d "$1" ]; then
        return 0
    else
        print_error "Failed to create directory: $1"
        return 1
    fi
}

# Header
echo ""
echo "=========================================="
echo "  Development Skills Setup Script"
echo "=========================================="
echo ""

# Pre-flight checks
print_info "Running pre-flight checks..."

# Check if we're in a writable directory
if [ ! -w "." ]; then
    print_error "Current directory is not writable"
    exit 1
fi

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_warning "Not in a git repository. Initializing git..."
    if git init > /dev/null 2>&1; then
        print_success "Git repository initialized"
    else
        print_error "Failed to initialize git repository"
        exit 1
    fi
fi

# Check Node.js
print_info "Checking Node.js installation..."
if check_command node; then
    NODE_VERSION=$(node --version 2>/dev/null || echo "unknown")
    print_success "Node.js found: $NODE_VERSION"
    
    # Check if version is >= 18
    if [[ "$NODE_VERSION" =~ v([0-9]+)\. ]]; then
        NODE_MAJOR="${BASH_REMATCH[1]}"
        if [ "$NODE_MAJOR" -lt 18 ]; then
            print_error "Node.js version 18 or higher is required. Found: $NODE_VERSION"
            exit 1
        fi
    else
        print_warning "Could not parse Node.js version, continuing anyway..."
    fi
else
    print_error "Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check npm (needed for pnpm installation)
if ! check_command npm && ! check_command pnpm; then
    print_error "Neither npm nor pnpm is available. Cannot proceed."
    exit 1
fi

# Check and install pnpm
print_info "Checking pnpm installation..."
if check_command pnpm; then
    PNPM_VERSION=$(pnpm --version 2>/dev/null || echo "unknown")
    print_success "pnpm found: $PNPM_VERSION"
    PNPM_AVAILABLE=true
else
    print_warning "pnpm not found. Attempting to install pnpm..."
    if check_command npm; then
        # Try different installation methods
        if npm install -g pnpm > /dev/null 2>&1; then
            print_success "pnpm installed via npm"
            PNPM_AVAILABLE=true
        elif command -v corepack &> /dev/null; then
            if corepack enable > /dev/null 2>&1 && corepack prepare pnpm@latest --activate > /dev/null 2>&1; then
                print_success "pnpm installed via corepack"
                PNPM_AVAILABLE=true
            else
                print_error "Failed to install pnpm. Please install manually: npm install -g pnpm"
                exit 1
            fi
        else
            print_error "Failed to install pnpm. Please install manually: npm install -g pnpm"
            exit 1
        fi
    else
        print_error "npm not found. Cannot install pnpm."
        exit 1
    fi
fi

# Ensure pnpm is in PATH
if ! check_command pnpm; then
    print_warning "pnpm may not be in PATH. Trying to reload shell..."
    export PATH="$PATH:$(npm config get prefix)/bin"
fi

# Check if package.json exists
HAS_PACKAGE_JSON=false
if [ -f "package.json" ]; then
    HAS_PACKAGE_JSON=true
    print_success "package.json found"
else
    print_warning "No package.json found. Some features will be limited."
    print_info "Consider running 'pnpm init' first for full functionality."
fi

# Install project dependencies if package.json exists
if [ "$HAS_PACKAGE_JSON" = true ]; then
    print_info "Installing project dependencies..."
    if pnpm install > /dev/null 2>&1; then
        print_success "Dependencies installed"
    else
        print_warning "Failed to install dependencies. You may need to run 'pnpm install' manually."
    fi
fi

# Setup Lefthook
print_info "Setting up Lefthook..."
LEFTHOOK_INSTALLED=false

# Check if lefthook is available as a command
if check_command lefthook; then
    print_success "Lefthook is already installed globally"
    LEFTHOOK_INSTALLED=true
elif [ "$HAS_PACKAGE_JSON" = true ]; then
    # Try to install as dev dependency
    print_info "Installing Lefthook as dev dependency..."
    if pnpm add -D @evilmartians/lefthook > /dev/null 2>&1; then
        print_success "Lefthook installed"
        LEFTHOOK_INSTALLED=true
    else
        print_warning "Failed to install Lefthook. You may need to install it manually."
    fi
else
    print_warning "Cannot install Lefthook without package.json. Install manually: pnpm add -D @evilmartians/lefthook"
fi

# Copy or create lefthook.yml
if [ ! -f "lefthook.yml" ]; then
    if [ -f "lefthook.yml.example" ]; then
        if cp lefthook.yml.example lefthook.yml 2>/dev/null; then
            print_success "Created lefthook.yml from template"
            verify_file "lefthook.yml"
        else
            print_error "Failed to copy lefthook.yml.example"
        fi
    else
        print_info "Creating default lefthook.yml..."
        cat > lefthook.yml << 'EOF'
pre-commit:
  parallel: true
  commands:
    lint:
      run: pnpm run lint
      stage_fixed: true
    format:
      run: pnpm run format:check
      stage_fixed: true
    test:
      run: pnpm run test:ci
      stage_fixed: true

pre-push:
  parallel: true
  commands:
    test:
      run: pnpm run test
    typecheck:
      run: pnpm run typecheck
EOF
        if verify_file "lefthook.yml"; then
            print_success "Created default lefthook.yml"
        fi
    fi
else
    print_info "lefthook.yml already exists. Skipping..."
fi

# Install Lefthook hooks (only if lefthook is available)
if [ "$LEFTHOOK_INSTALLED" = true ]; then
    print_info "Installing Lefthook git hooks..."
    if [ "$HAS_PACKAGE_JSON" = true ]; then
        # Use pnpm to run lefthook
        if pnpm lefthook install > /dev/null 2>&1; then
            print_success "Lefthook hooks installed"
        else
            print_warning "Failed to install Lefthook hooks. Run 'pnpm lefthook install' manually."
        fi
    elif check_command lefthook; then
        # Use global lefthook
        if lefthook install > /dev/null 2>&1; then
            print_success "Lefthook hooks installed"
        else
            print_warning "Failed to install Lefthook hooks. Run 'lefthook install' manually."
        fi
    fi
else
    print_warning "Skipping Lefthook hook installation (Lefthook not available)"
fi

# Setup GitHub Actions workflow
print_info "Setting up GitHub Actions..."
mkdir -p .github/workflows
if [ ! -f ".github/workflows/pr-checks.yml" ]; then
    if [ -f ".github/workflows/pr-checks.yml.example" ]; then
        if cp .github/workflows/pr-checks.yml.example .github/workflows/pr-checks.yml 2>/dev/null; then
            print_success "Created GitHub Actions workflow"
            verify_file ".github/workflows/pr-checks.yml"
        else
            print_error "Failed to copy GitHub Actions workflow"
        fi
    else
        print_warning "PR checks workflow example not found. Skipping..."
    fi
else
    print_info "GitHub Actions workflow already exists. Skipping..."
fi

# Setup PR template
print_info "Setting up PR template..."
mkdir -p .github
if [ ! -f ".github/pull_request_template.md" ]; then
    # Try to copy from example if available
    if [ -f ".github/pull_request_template.md" ]; then
        print_info "PR template already exists"
    elif [ -f "pull_request_template.md" ]; then
        # Try to copy from current directory if this script is in the skills repo
        if cp pull_request_template.md .github/pull_request_template.md 2>/dev/null; then
            print_success "Created PR template"
        else
            print_warning "Failed to copy PR template"
        fi
    else
        print_warning "PR template not found. You may want to create one."
    fi
else
    print_info "PR template already exists. Skipping..."
fi

# Setup .gitignore
print_info "Setting up .gitignore..."
if [ ! -f ".gitignore" ]; then
    if [ -f ".gitignore.example" ]; then
        if cp .gitignore.example .gitignore 2>/dev/null; then
            print_success "Created .gitignore from template"
            verify_file ".gitignore"
        else
            print_error "Failed to copy .gitignore.example"
        fi
    else
        print_info "Creating default .gitignore..."
        cat > .gitignore << 'EOF'
# Environment variables
.env
.env.local
.env.*.local

# Dependencies
node_modules/
.pnp
.pnp.js
.pnpm-store/

# Build outputs
dist/
build/
.next/
out/
.expo/

# Testing
coverage/
.nyc_output/
.jest/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
pnpm-debug.log*

# Misc
.cache/
.temp/
.turbo/
EOF
        if verify_file ".gitignore"; then
            print_success "Created default .gitignore"
        fi
    fi
else
    print_info ".gitignore already exists. Skipping..."
fi

# Setup environment variables
print_info "Setting up environment variables..."
if [ ! -f ".env.example" ]; then
    cat > .env.example << 'EOF'
# Application
NODE_ENV=development
PORT=3000

# Add your environment variables here
# Never commit actual values or secrets
EOF
    if verify_file ".env.example"; then
        print_success "Created .env.example"
    fi
else
    print_info ".env.example already exists. Skipping..."
fi

# Setup TypeScript if not already configured
print_info "Checking TypeScript configuration..."
if [ ! -f "tsconfig.json" ]; then
    print_info "Creating TypeScript configuration..."
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "allowJs": false,
    "checkJs": false,
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "isolatedModules": true,
    "jsx": "react-jsx"
  },
  "include": ["src", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules", "dist", "build"]
}
EOF
    if verify_file "tsconfig.json"; then
        print_success "Created tsconfig.json"
    fi
else
    print_info "tsconfig.json already exists. Skipping..."
fi

# Setup Biome if not already configured
print_info "Checking Biome configuration..."
if [ ! -f "biome.json" ]; then
    if [ "$HAS_PACKAGE_JSON" = true ] && check_command pnpm; then
        print_info "Initializing Biome..."
        if pnpm dlx @biomejs/biome init > /dev/null 2>&1; then
            if verify_file "biome.json"; then
                print_success "Biome initialized"
            else
                print_warning "Biome init completed but biome.json not found"
            fi
        else
            print_warning "Failed to initialize Biome. Run 'pnpm dlx @biomejs/biome init' manually."
        fi
    else
        print_warning "Cannot initialize Biome without package.json and pnpm"
    fi
else
    print_info "biome.json already exists. Skipping..."
fi

# Setup Jest if not already configured
print_info "Checking Jest configuration..."
if [ ! -f "jest.config.js" ] && [ ! -f "jest.config.ts" ] && [ ! -f "jest.config.mjs" ]; then
    print_warning "Jest configuration not found."
    if [ "$HAS_PACKAGE_JSON" = true ]; then
        print_info "Install Jest with: pnpm add -D jest @types/jest ts-jest @testing-library/react @testing-library/jest-dom"
    fi
else
    print_info "Jest configuration found"
fi

# Create domain-driven structure
print_info "Setting up domain-driven project structure..."
if [ ! -d "src" ]; then
    if mkdir -p src/domains src/shared/{components,hooks,utils,types} src/app 2>/dev/null; then
        # Create example domain structure
        if mkdir -p src/domains/example/{components,hooks,utils,types,__tests__} 2>/dev/null; then
            if verify_dir "src" && verify_dir "src/domains" && verify_dir "src/shared"; then
                print_success "Created domain-driven project structure"
                print_info "Example domain structure created at: src/domains/example"
            fi
        fi
    else
        print_error "Failed to create project structure"
    fi
else
    print_info "src directory already exists. Skipping structure creation..."
fi

# Setup Docker if docker-compose.yml doesn't exist
print_info "Checking Docker setup..."
if [ ! -f "docker-compose.yml" ]; then
    if [ -f "docker-compose.yml.example" ]; then
        if cp docker-compose.yml.example docker-compose.yml 2>/dev/null; then
            print_success "Created docker-compose.yml from template"
            verify_file "docker-compose.yml"
        else
            print_error "Failed to copy docker-compose.yml.example"
        fi
    else
        print_info "Docker setup skipped (no template found)"
    fi
else
    print_info "docker-compose.yml already exists. Skipping..."
fi

# Add scripts to package.json if it exists
if [ "$HAS_PACKAGE_JSON" = true ]; then
    print_info "Checking package.json scripts..."
    if ! grep -q '"scripts"' package.json 2>/dev/null; then
        print_warning "No scripts section in package.json."
        print_info "Recommended scripts to add:"
        echo ""
        echo '  "scripts": {'
        echo '    "lint": "biome check .",'
        echo '    "lint:fix": "biome check --write .",'
        echo '    "format": "biome format --write .",'
        echo '    "format:check": "biome format --check .",'
        echo '    "typecheck": "tsc --noEmit",'
        echo '    "test": "jest",'
        echo '    "test:ci": "jest --ci --coverage",'
        echo '    "test:watch": "jest --watch"'
        echo '  }'
        echo ""
    else
        print_success "package.json scripts section exists"
    fi
fi

# Summary
echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""

if [ $FAILURES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    print_success "Project setup completed successfully with no issues!"
elif [ $FAILURES -eq 0 ]; then
    print_success "Project setup completed with $WARNINGS warning(s)"
else
    print_warning "Project setup completed with $FAILURES error(s) and $WARNINGS warning(s)"
fi

echo ""
print_info "Next steps:"
echo "  1. Review and customize configuration files"
if [ "$HAS_PACKAGE_JSON" = false ]; then
    echo "  2. Run 'pnpm init' to create package.json"
    echo "  3. Add required scripts to package.json (see above)"
else
    echo "  2. Add missing scripts to package.json if needed"
fi
echo "  3. Set up your environment variables in .env"
echo "  4. Install additional dependencies as needed"
echo "  5. Start developing!"
echo ""
print_warning "Remember to:"
echo "  - Update .env.example with required variables (no secrets)"
echo "  - Configure SonarQube if needed"
echo "  - Set up your GitHub repository and secrets"
echo "  - Review SKILLS.md for best practices"
echo ""

# Exit with appropriate code
if [ $FAILURES -gt 0 ]; then
    exit 1
else
    exit 0
fi
