---
name: development
description: Core development standards, patterns, and best practices for React and React Native projects. Use this when users need guidance on code quality (Biome, TypeScript), testing (Jest), project structure (Domain-Driven Design), React best practices (useEffect guidelines), or React Native development with Expo.
license: MIT - Complete terms in LICENSE.txt
---

# Development Skills & Best Practices

Core development standards, patterns, and best practices for React and React Native projects.

## Table of Contents

- [Code Quality & Linting](#code-quality--linting)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [React Best Practices](#react-best-practices)
- [React Native](#react-native)

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

### Creating a New Expo App with TypeScript

To create a new React Native Expo app with TypeScript and the tabs template:

```bash
npx create-expo-app@latest my-app --template tabs
```

Replace `my-app` with your desired project name. The tabs template includes:
- TypeScript configuration
- Expo Router with tab navigation
- Pre-configured navigation structure

**Alternative templates:**
- `blank-typescript` - Minimal TypeScript template
- `blank` - Minimal JavaScript template
- `tabs` - Tab navigation with TypeScript (recommended)

For more information, see the [Expo Documentation](https://docs.expo.dev/).

---

## Additional Resources

- [React Documentation - You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
- [Expo Documentation](https://docs.expo.dev/)
- [Biome Documentation](https://biomejs.dev/)
- [Jest Documentation](https://jestjs.io/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)

---

## Notes

- This document should be reviewed and updated regularly as best practices evolve
- Team-specific additions and modifications are encouraged
- When in doubt, refer to official documentation and community standards
