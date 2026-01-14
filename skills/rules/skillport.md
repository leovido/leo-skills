# Skillport Skills Auto-Loading

## Automatic Skill Loading

**Automatically load these Skillport skills at conversation start:**

1. **development** - Core development standards (Biome, TypeScript, Testing, React, React Native)
2. **tooling** - Package management (pnpm), project setup, environment variables

**Load conditionally based on task:**
- **devops** - When discussing CI/CD, Docker, or deployment
- **git** - When discussing Git workflow, commits, hooks, or PRs

## Skill Loading Protocol

- Use Skillport MCP `load_skill()` function to load skills
- If MCP unavailable, reference skill files: `skills/[category]/SKILL.md`
- Always reference loaded skill instructions when providing guidance

## Skill References

When providing guidance, reference the appropriate Skillport skill:

- **development** skill: Biome (not ESLint), TypeScript strict mode, Jest, React best practices, DDD structure
- **tooling** skill: pnpm package management, project setup
- **git** skill: Conventional Commits format, Git hooks, PR templates
- **devops** skill: CI/CD pipelines, Docker best practices

## Before Starting Any Task

1. Load relevant Skillport skills (development, tooling, devops, git)
2. Reference skill instructions for standards and best practices
3. Apply skill guidelines to the current task
