# Setup Script Documentation

## Overview

The `setup.sh` script automates the initialization of a new project based on the best practices outlined in `SKILLS.md`. It handles all the tedious setup tasks so you can focus on building your application.

## What It Does

The setup script performs the following tasks:

### 1. Prerequisites Check
- ✅ Verifies Node.js is installed (requires v18+)
- ✅ Checks for pnpm (installs if missing)
- ✅ Initializes git repository if needed

### 2. Dependency Management
- ✅ Installs project dependencies using pnpm
- ✅ Installs Lefthook for git hooks management

### 3. Git Hooks Setup
- ✅ Creates `lefthook.yml` from template
- ✅ Installs Lefthook git hooks (pre-commit, pre-push)

### 4. Configuration Files
- ✅ Creates `.gitignore` from template
- ✅ Sets up GitHub Actions workflow for PR checks
- ✅ Creates PR template
- ✅ Initializes Biome configuration
- ✅ Creates TypeScript configuration (`tsconfig.json`)
- ✅ Sets up environment variable template (`.env.example`)

### 5. Project Structure
- ✅ Creates domain-driven design folder structure:
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

### 6. Docker Setup
- ✅ Creates `docker-compose.yml` from template (if available)

## Usage

### Basic Usage

```bash
# Make the script executable
chmod +x setup.sh

# Run the script
./setup.sh
```

### For Existing Projects

The script is safe to run on existing projects. It will:
- Skip files that already exist
- Only create missing configuration files
- Not overwrite existing configurations

### Requirements

- **Node.js** v18 or higher
- **Git** (for repository initialization)
- **Internet connection** (for installing packages)

## What You Still Need to Do

After running the setup script, you should:

1. **Review Configuration Files**
   - Check `tsconfig.json` and adjust for your framework
   - Review `biome.json` and customize rules
   - Update `lefthook.yml` if needed

2. **Add Package Scripts**
   - The script will show you recommended scripts to add to `package.json`
   - Or copy from `package.json.example`

3. **Set Up Environment Variables**
   - Update `.env.example` with your required variables
   - Create `.env` file (never commit this!)

4. **Install Additional Dependencies**
   ```bash
   # For React projects
   pnpm add react react-dom
   pnpm add -D @types/react @types/react-dom
   
   # For Jest testing
   pnpm add -D jest @types/jest ts-jest @testing-library/react @testing-library/jest-dom
   ```

5. **Configure SonarQube** (if applicable)
   - Set up SonarQube project
   - Add `SONAR_TOKEN` and `SONAR_HOST_URL` to GitHub secrets

6. **Set Up GitHub Repository**
   - Create repository on GitHub
   - Add remote: `git remote add origin <your-repo-url>`
   - Push your code

## Troubleshooting

### Script fails with "command not found"

Make sure you have Node.js installed:
```bash
node --version  # Should show v18 or higher
```

### pnpm installation fails

Try installing pnpm manually:
```bash
npm install -g pnpm
```

### Lefthook hooks not working

Make sure Lefthook is installed:
```bash
pnpm lefthook install
```

### Permission denied

Make the script executable:
```bash
chmod +x setup.sh
```

## Customization

You can customize the script by:

1. **Modifying templates** - Edit `.example` files before running
2. **Editing the script** - Adjust the script to match your specific needs
3. **Adding custom steps** - Extend the script with your own setup logic

## Script Output

The script provides color-coded output:
- 🔵 **Blue (ℹ)** - Informational messages
- 🟢 **Green (✓)** - Success messages
- 🟡 **Yellow (⚠)** - Warnings
- 🔴 **Red (✗)** - Errors

## Example Output

```
==========================================
  Development Skills Setup Script
==========================================

ℹ Checking Node.js installation...
✓ Node.js found: v20.10.0
ℹ Checking pnpm installation...
✓ pnpm found: 8.15.0
ℹ Installing project dependencies...
✓ Dependencies installed
ℹ Setting up Lefthook...
✓ Lefthook installed
✓ Created lefthook.yml from template
✓ Lefthook hooks installed
...

==========================================
  Setup Complete!
==========================================
```

## Next Steps

After running the setup script:

1. Review `SKILLS.md` for best practices
2. Start building your application
3. Run `pnpm run lint` and `pnpm run test` to verify everything works
4. Make your first commit and push to trigger CI/CD checks

