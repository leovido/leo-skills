# Development Skills & Best Practices

This repository contains a comprehensive set of development standards, best practices, and templates for React and React Native projects.

## Contents

- **SKILLS.md** - Main documentation covering all best practices and guidelines
- **Template files** - Ready-to-use configuration files for various tools

## Quick Start

### Automated Setup (Recommended)

Use the setup script to automatically configure your project:

```bash
# Make the script executable (if not already)
chmod +x setup.sh

# Run the setup script
./setup.sh
```

The script will:
- ✅ Check and install required tools (Node.js, pnpm, Lefthook)
- ✅ Install project dependencies
- ✅ Set up git hooks with Lefthook
- ✅ Create configuration files from templates
- ✅ Set up GitHub Actions workflows
- ✅ Create domain-driven project structure
- ✅ Initialize TypeScript, Biome, and Jest configurations
- ✅ Set up Docker Compose
- ✅ Create environment variable templates

### Manual Setup

1. Review `SKILLS.md` for comprehensive guidelines
2. Copy relevant template files (`.example` files) to your project
3. Customize configurations based on your project needs

## Template Files

- `setup.sh` - Automated setup script for new projects
- `validate-setup.sh` - Validation script to test setup script
- `package.json.example` - Package.json template with required scripts
- `lefthook.yml.example` - Git hooks configuration
- `.github/workflows/pr-checks.yml.example` - GitHub Actions CI/CD workflow
- `.github/pull_request_template.md` - PR template
- `.gitignore.example` - Standard gitignore for React/React Native
- `docker-compose.yml.example` - Docker Compose setup with monitoring

## Documentation

- `SKILLS.md` - Comprehensive best practices and guidelines
- `QUICK_START.md` - Quick start guide for new projects
- `SETUP_SCRIPT.md` - Detailed setup script documentation
- `TESTING.md` - Testing and validation guide
- `SETUP.md` - Publishing to GitHub and Skillport guide

## Using with Skillport

This repository is designed to be used with [Skillport](https://github.com/skillport/skillport), a tool for sharing and reusing development skills and best practices.

### Publishing to Skillport

To make this skill available via Skillport:

1. **Create a GitHub repository** (if not already public)
   ```bash
   git init
   git add .
   git commit -m "feat: add development skills and best practices"
   git remote add origin https://github.com/yourusername/leo-skills.git
   git push -u origin main
   ```

2. **Create a Skillport skill configuration**

   Create a `skill.json` file in the root:

   ```json
   {
     "id": "leo-skills",
     "name": "Development Skills & Best Practices",
     "description": "Comprehensive development standards for React and React Native projects",
     "version": "1.0.0",
     "author": "Your Name",
     "repository": "https://github.com/yourusername/leo-skills",
     "tags": ["react", "react-native", "best-practices", "ci-cd", "docker"],
     "files": [
       "SKILLS.md",
       "README.md",
       "lefthook.yml.example",
       ".github/workflows/pr-checks.yml.example",
       ".github/pull_request_template.md",
       ".gitignore.example",
       "docker-compose.yml.example"
     ]
   }
   ```

3. **Publish to Skillport Registry**

   - Option A: Submit a PR to the Skillport registry (if available)
   - Option B: Share the GitHub repository URL directly
   - Option C: Use Skillport's CLI to publish (if available)

4. **Using the skill in projects**

   Once published, others can use it via Skillport:

   ```bash
   # Search for the skill
   skillport search "react best practices"

   # Load the skill
   skillport load leo-skills

   # Follow the instructions in SKILLS.md
   ```

### Alternative: Direct GitHub Usage

If Skillport integration isn't available, you can:

1. **Clone or reference this repository** in your projects
2. **Copy relevant files** to your project
3. **Link to this repository** in your project's README for team reference

## Contributing

Feel free to:
- Open issues for suggestions or improvements
- Submit pull requests with enhancements
- Share your own best practices

## License

[Specify your license here - MIT, Apache 2.0, etc.]

## Author

Christian Rayleo Vido

