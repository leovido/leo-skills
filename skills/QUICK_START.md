# Quick Start Guide

## For New Projects

### Step 1: Get the Setup Script

**Option A: From this repository**
```bash
# Clone or download this repository
git clone https://github.com/yourusername/leo-skills.git
cd leo-skills
```

**Option B: Via Skillport**
```bash
# If using Skillport
skillport load leo-skills
```

### Step 2: Run the Setup Script

```bash
# Make it executable
chmod +x setup.sh

# Run in your new project directory
cd /path/to/your/new-project
/path/to/leo-skills/setup.sh
```

Or copy the script to your project:
```bash
cp /path/to/leo-skills/setup.sh .
chmod +x setup.sh
./setup.sh
```

### Step 3: Verify Setup

The script will:
- ✅ Check prerequisites (Node.js, pnpm)
- ✅ Install dependencies
- ✅ Create configuration files
- ✅ Set up project structure
- ✅ Install git hooks

### Step 4: Review Output

The script provides color-coded feedback:
- 🔵 **Blue (ℹ)** - Information
- 🟢 **Green (✓)** - Success
- 🟡 **Yellow (⚠)** - Warning (non-critical)
- 🔴 **Red (✗)** - Error (critical)

## Prerequisites

Before running the script, ensure you have:

- ✅ **Node.js 18+** installed
  ```bash
  node --version  # Should show v18 or higher
  ```
- ✅ **npm** or **pnpm** available
  ```bash
  npm --version   # or
  pnpm --version
  ```
- ✅ **Git** installed (optional, script will initialize if needed)
  ```bash
  git --version
  ```
- ✅ **Write permissions** in the project directory

## What Gets Created

The script creates:

### Configuration Files
- `.gitignore` - Git ignore rules
- `.env.example` - Environment variable template
- `tsconfig.json` - TypeScript configuration
- `biome.json` - Biome linting/formatting config
- `lefthook.yml` - Git hooks configuration
- `docker-compose.yml` - Docker setup (if template available)

### Project Structure
```
src/
  domains/
    example/
      components/
      hooks/
      utils/
      types/
      __tests__/
  shared/
    components/
    hooks/
    utils/
    types/
  app/
```

### GitHub Files
- `.github/workflows/pr-checks.yml` - CI/CD workflow
- `.github/pull_request_template.md` - PR template

## Common Issues & Solutions

### Issue: "Node.js is not installed"
**Solution:** Install Node.js 18+ from [nodejs.org](https://nodejs.org/)

### Issue: "pnpm not found"
**Solution:** The script will try to install it automatically. If it fails:
```bash
npm install -g pnpm
```

### Issue: "Permission denied"
**Solution:** 
```bash
chmod +x setup.sh
```

### Issue: "Cannot install dependencies"
**Solution:** 
- Check internet connection
- Verify package.json exists
- Try manually: `pnpm install`

### Issue: "Lefthook hooks not working"
**Solution:**
```bash
pnpm lefthook install
```

## After Setup

1. **Review configuration files**
   - Check `tsconfig.json` matches your framework
   - Review `biome.json` rules
   - Customize `lefthook.yml` if needed

2. **Add package.json scripts** (if not already present)
   ```json
   {
     "scripts": {
       "lint": "biome check .",
       "lint:fix": "biome check --write .",
       "format": "biome format --write .",
       "format:check": "biome format --check .",
       "typecheck": "tsc --noEmit",
       "test": "jest",
       "test:ci": "jest --ci --coverage"
     }
   }
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your actual values
   ```

4. **Install framework dependencies**
   ```bash
   # For React
   pnpm add react react-dom
   pnpm add -D @types/react @types/react-dom
   
   # For Next.js
   pnpm add next react react-dom
   ```

5. **Install testing dependencies** (if not already installed)
   ```bash
   pnpm add -D jest @types/jest ts-jest @testing-library/react @testing-library/jest-dom
   ```

## Validation

To test the setup script works correctly:

```bash
./validate-setup.sh
```

This runs automated tests to verify the script works in various scenarios.

## Next Steps

- Read `SKILLS.md` for detailed best practices
- Review `TESTING.md` for reliability information
- Check `SETUP_SCRIPT.md` for detailed documentation
- Start building your application!

## Getting Help

If the script fails:

1. Check the error message (red text)
2. Verify prerequisites are met
3. Review `TESTING.md` troubleshooting section
4. Check file permissions
5. Ensure you have internet access (for package installation)

## Success Indicators

You'll know the setup worked if:

✅ Script completes without critical errors
✅ All configuration files are present
✅ Project structure is created
✅ Git hooks are installed (check `.git/hooks/`)
✅ You can run `pnpm run lint` (if scripts are added)

