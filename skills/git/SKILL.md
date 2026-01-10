---
name: git
description: Git workflow standards, commit conventions, hooks, and pull request practices. Use this when users need guidance on Conventional Commits, Git hooks with Lefthook, pull request templates, .gitignore configuration, or Git workflow best practices for team collaboration.
license: MIT - Complete terms in LICENSE.txt
---

# Git Skills & Best Practices

Git workflow standards, commit conventions, hooks, and pull request practices.

## Table of Contents

- [Git Workflow](#git-workflow)
- [Git Hooks](#git-hooks)
- [Pull Request Templates](#pull-request-templates)

---

## Git Workflow

### Conventional Commits

Follow the [Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0/):

**Format:**
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

**Examples:**
```
feat(auth): add user login functionality
fix(api): resolve race condition in data fetching
docs: update README with setup instructions
```

### .gitignore

Include standard exclusions for React/React Native projects:

**Essential entries:**
```
# Environment variables
.env
.env.local
.env.*.local

# Dependencies
node_modules/
.pnp
.pnp.js

# Build outputs
dist/
build/
.next/
out/

# Testing
coverage/
.nyc_output/

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

# pnpm
.pnpm-store/

# Misc
.cache/
.temp/
.turbo/
```

---

## Git Hooks

### Lefthook Integration

Use [Lefthook](https://github.com/evilmartians/lefthook) for managing git hooks.

**Configuration (`lefthook.yml`):**

```yaml
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
```

**Pre-commit hooks should:**
- Run linting checks
- Run unit tests
- Auto-fix issues when possible

**Pre-push hooks should:**
- Run full test suite
- Run TypeScript type checking (`tsc`)
- Prevent pushing if checks fail

---

## Pull Request Templates

Create `.github/pull_request_template.md` with the following structure:

```markdown
## Overview
<!-- Brief description of what this PR accomplishes -->

## Solution
<!-- Detailed explanation of the approach and implementation -->

## Screenshots
<!-- Add screenshots or screen recordings if applicable -->
<!-- For web: browser screenshots -->
<!-- For mobile: iOS/Android screenshots -->

## Ticket
<!-- Link to JIRA ticket or other project management tool -->
<!-- Format: [PROJECT-123](link-to-ticket) -->

## Tested On
<!-- Check all that apply -->
- [ ] Web
- [ ] Mobile
- [ ] iOS
- [ ] Android
- [ ] Other: ___________

## Additional Notes
<!-- Any additional context, breaking changes, or follow-up items -->
```

---

## Additional Resources

- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [Lefthook Documentation](https://github.com/evilmartians/lefthook)

---

## Notes

- This document should be reviewed and updated regularly as best practices evolve
- Team-specific additions and modifications are encouraged
- When in doubt, refer to official documentation and community standards

