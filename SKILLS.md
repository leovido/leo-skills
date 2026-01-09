# Development Skills & Best Practices

A comprehensive guide to development standards, tooling, and best practices for React and React Native projects.

## Table of Contents

- [Code Quality & Linting](#code-quality--linting)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [React Best Practices](#react-best-practices)
- [React Native](#react-native)
- [Package Management](#package-management)
- [Git Workflow](#git-workflow)
- [Git Hooks](#git-hooks)
- [CI/CD](#cicd)
- [Pull Request Templates](#pull-request-templates)
- [Docker](#docker)
- [Project Setup](#project-setup)

---

## Code Quality & Linting

### Biome

- **Use Biome** for both linting and code formatting
- Configure Biome with project-specific rules
- Use Biome's built-in formatter (no need for Prettier)
- Run linting and formatting checks in CI/CD pipeline
- Ensure consistent code style across the team
- Format code automatically on save and before commit

### TypeScript

- **Always use TypeScript** - TypeScript is required for all projects
- Configure strict TypeScript settings for maximum type safety
- Run `tsc` type checking in pre-push hooks
- Include TypeScript checks in CI pipeline
- Avoid using `any` type - use proper types or `unknown` when necessary

---

## Testing

### Jest

- **Use Jest** as the testing framework for all projects
- Write unit tests for all business logic and utilities
- Write integration tests for critical user flows
- Aim for meaningful test coverage (focus on quality over quantity)
- Use React Testing Library for component testing
- Mock external dependencies and APIs appropriately
- Keep tests fast, isolated, and maintainable

### Test Structure

- Place test files next to the code they test (co-location)
- Use descriptive test names that explain what is being tested
- Follow the Arrange-Act-Assert pattern
- Use `describe` blocks to group related tests
- Run tests in watch mode during development

---

## Project Structure

### Domain-Driven Design

- **Use Domain-Driven Design (DDD)** principles for project structure
- Organize code by domain/feature rather than by technical layer
- Each domain should be self-contained with its own:
  - Components
  - Hooks
  - Utilities
  - Types
  - Tests

**Example Structure:**
```
src/
  domains/
    auth/
      components/
      hooks/
      utils/
      types/
      __tests__/
    user/
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
    layout.tsx
    page.tsx
```

**Benefits:**
- Better code organization and discoverability
- Easier to scale and maintain
- Clear boundaries between features
- Facilitates team collaboration

---

## React Best Practices

### useEffect Guidelines

Follow React's official guidance: [You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect)

**Key Principles:**

1. **Don't use Effects for data transformation**
   - Calculate derived values during rendering
   - Use `useMemo` for expensive calculations
   - Avoid redundant state variables

2. **Don't use Effects for user events**
   - Handle user interactions in event handlers
   - Effects should only synchronize with external systems

3. **When to use Effects:**
   - Synchronizing with external systems (browser APIs, third-party libraries)
   - Data fetching (though modern frameworks provide better alternatives)
   - Subscribing to external stores

4. **Best Practices:**
   - Always include cleanup functions for subscriptions
   - Handle race conditions in data fetching
   - Extract data fetching logic into custom hooks
   - Prefer server components and React Server Actions when possible

---

## React Native

### Expo Framework

- **Always use Expo** for React Native projects
- Leverage Expo's managed workflow for easier development
- Use Expo SDK for native module access
- Follow Expo's best practices for app configuration

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

## CI/CD

### GitHub Actions

When creating a Pull Request, the following checks must run:

1. **Security Checks**
   - Dependency vulnerability scanning
   - Use tools like `pnpm audit`, Dependabot, or Snyk

2. **SonarQube Analysis**
   - Code quality and security analysis
   - Requires initial SonarQube project setup
   - Configure quality gates and thresholds

3. **Unit Tests**
   - Run full test suite
   - Generate coverage reports
   - Fail if tests fail or coverage drops below threshold

4. **Linting**
   - Run Biome linting
   - Fail on linting errors
   - Optionally auto-fix and commit changes

**Example GitHub Actions workflow:**

```yaml
name: PR Checks

on:
  pull_request:
    branches: [main, develop]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm audit --audit-level=moderate

  sonarqube:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - name: SonarQube Scan
        uses: sonarsource/sonarqube-scan-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run test:ci
      - uses: codecov/codecov-action@v3
        with:
          token: ${{ secrets.CODECOV_TOKEN }}

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run lint
      - run: pnpm run format:check
```

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

## Docker

### Containerization

Set up Docker and Docker Compose for local development and deployment.

**Docker Compose Structure:**

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    volumes:
      - .:/app
      - /app/node_modules
    depends_on:
      - prometheus
      - grafana

  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus:/etc/prometheus
      - prometheus_data:/prometheus

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    depends_on:
      - prometheus

volumes:
  prometheus_data:
  grafana_data:
```

**Dockerfile Best Practices:**

- Use multi-stage builds for smaller images
- Leverage layer caching
- Use specific version tags for base images
- Run as non-root user when possible
- Include health checks

**Additional Services:**
- Database services (PostgreSQL, MySQL, MongoDB) can be added to docker-compose.yml as needed
- Configure service dependencies appropriately

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

### Environment Variables

- **Use dotenv** for environment variable management
- Always include `.env.example` with required variables (no secrets)
- Document all environment variables in README
- Never commit `.env` files
- Use validation libraries (e.g., `zod`, `joi`) to ensure required variables are present
- Load environment variables using `dotenv` at application startup
- Use different `.env` files for different environments (`.env.development`, `.env.production`, etc.)

---

## Additional Resources

- [React Documentation - You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [Lefthook Documentation](https://github.com/evilmartians/lefthook)
- [Expo Documentation](https://docs.expo.dev/)
- [Biome Documentation](https://biomejs.dev/)
- [Jest Documentation](https://jestjs.io/)
- [pnpm Documentation](https://pnpm.io/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)

---

## Notes

- This document should be reviewed and updated regularly as best practices evolve
- Team-specific additions and modifications are encouraged
- When in doubt, refer to official documentation and community standards

