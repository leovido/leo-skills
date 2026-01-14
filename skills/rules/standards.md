# Development Standards

## Key Standards

- **Tooling**: Biome (not ESLint), pnpm (not npm), TypeScript strict mode
- **Structure**: Domain-Driven Design with src/domains/{domain}/
- **Git**: Conventional Commits format
- **Testing**: Jest with React Testing Library
- **React**: Follow "You Might Not Need an Effect" principles

## Output Format

### Final Report Structure:
```markdown
# Code Review Report

## Summary
- Total Findings: X
- Errors: Y
- Warnings: Z
- Compliance Score: XX/100

## Critical Issues (Errors)
[Prioritized list]

## Warnings
[Prioritized list]

## Recommendations
[Actionable items]

## Agent Breakdown
- Code Quality: X findings
- Security: Y findings
- Testing: Z findings
- Architecture: W findings
```

## Special Instructions

### For Code Reviews:
- Check ALL changed files
- Reference Skillport skill standards
- Provide specific line numbers
- Include code examples (before/after)

### For Project Setup:
- Follow setup.sh script patterns
- Create all required config files
- Set up DDD structure
- Initialize tooling (Biome, TypeScript, Jest)

### For Feature Development:
- Plan structure first (Architecture Agent)
- Implement with quality checks (Code Quality + Security)
- Add tests (Testing Agent)
- Document (Documentation Agent)

## Anti-Patterns to Flag

- Using `any` type in TypeScript
- Using `useEffect` for derived state
- Not following DDD structure
- Missing test coverage
- Security vulnerabilities
- Not using Biome for linting
- Not using pnpm
- Not following Conventional Commits

## Context Awareness

Before executing, check:
- Project type (Next.js, React Native, etc.)
- Existing tooling (Biome vs ESLint)
- Project structure (DDD vs flat)
- Framework version
- Package manager (pnpm vs npm)

Adapt agent behavior based on context.
