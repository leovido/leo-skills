# Tooling Skills & Best Practices

Package management, project setup, and development tooling standards.

## Table of Contents

- [Package Management](#package-management)
- [Project Setup](#project-setup)
- [Environment Variables](#environment-variables)

---

## Package Management

### pnpm

- **Use pnpm** as the package manager for all projects
- pnpm provides faster installs and better disk space efficiency
- Use `pnpm install` instead of `npm install`
- Use `pnpm add <package>` to add dependencies
- Use `pnpm run <script>` to run scripts
- Leverage pnpm's workspace feature for monorepos

**Benefits:**
- Faster installation times
- Efficient disk space usage (hard links)
- Strict dependency resolution
- Better monorepo support

---

## Project Setup

### Automated Setup

Use the provided `setup.sh` script to automatically configure your project:

```bash
chmod +x setup.sh
./setup.sh
```

The script will handle:
- Prerequisites checking (Node.js, pnpm)
- Installing dependencies and tools
- Setting up git hooks with Lefthook
- Creating configuration files from templates
- Setting up project structure (domain-driven design)
- Initializing TypeScript, Biome, and Jest

See `SETUP_SCRIPT.md` for detailed documentation.

### Initial Setup Checklist

When starting a new project (or if not using the automated script):

1. ✅ Initialize project with appropriate framework (Next.js, Expo, etc.)
2. ✅ Set up TypeScript with strict configuration
3. ✅ Configure Biome for linting and formatting
4. ✅ Set up Jest for testing
5. ✅ Organize project structure using Domain-Driven Design principles
6. ✅ Initialize pnpm and configure package.json
7. ✅ Configure Lefthook with pre-commit and pre-push hooks
8. ✅ Create `.gitignore` with standard exclusions
9. ✅ Set up GitHub Actions workflow for PR checks
10. ✅ Configure SonarQube project (if applicable)
11. ✅ Create PR template in `.github/pull_request_template.md`
12. ✅ Set up Docker and Docker Compose
13. ✅ Configure environment variables with dotenv (`.env.example`)

---

## Environment Variables

- **Use dotenv** for environment variable management
- Always include `.env.example` with required variables (no secrets)
- Document all environment variables in README
- Never commit `.env` files
- Use validation libraries (e.g., `zod`, `joi`) to ensure required variables are present
- Load environment variables using `dotenv` at application startup
- Use different `.env` files for different environments (`.env.development`, `.env.production`, etc.)

---

## Additional Resources

- [pnpm Documentation](https://pnpm.io/)
- [dotenv Documentation](https://github.com/motdotla/dotenv)

---

## Notes

- This document should be reviewed and updated regularly as best practices evolve
- Team-specific additions and modifications are encouraged
- When in doubt, refer to official documentation and community standards

