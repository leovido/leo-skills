# Auto-Loading Skillport Skills in Cursor

## Quick Answer

**You don't need to manually load skills in each chat if you configure `.cursorrules` properly.** However, Skillport skills loaded via MCP are session-based, so you have two options:

1. **Configure `.cursorrules` to auto-load skills** (Recommended)
2. **Use @-mentions to load skills on-demand**

---

## Method 1: Auto-Load via `rules/` Folder (Recommended)

Create rule files in the `rules/` folder to automatically load relevant skills:

```markdown
# Development Standards & Best Practices

## Skillport Skills

This project uses the following Skillport skills. Load them automatically when relevant:

- **development** - Core development standards (Biome, TypeScript, Testing, React, React Native)
- **devops** - CI/CD, Docker, monitoring
- **git** - Git workflow, Conventional Commits, hooks, PR templates
- **tooling** - Package management (pnpm), project setup, environment variables

## Auto-Load Instructions

When starting a new chat or task, automatically load the relevant skills:

1. **For code development tasks**: Load `development` skill
2. **For CI/CD or Docker tasks**: Load `devops` skill
3. **For Git-related tasks**: Load `git` skill
4. **For project setup or tooling**: Load `tooling` skill
5. **For comprehensive reviews**: Load all skills

## Skill Loading Commands

Use these Skillport MCP commands to load skills:
- `load_skill("development")` - Load development standards
- `load_skill("devops")` - Load DevOps practices
- `load_skill("git")` - Load Git workflow standards
- `load_skill("tooling")` - Load tooling and setup standards

## Context-Based Skill Selection

Automatically select and load skills based on the task:

- **Code review/development** → Load `development` skill
- **Setting up CI/CD** → Load `devops` skill
- **Git operations** → Load `git` skill
- **Project initialization** → Load `tooling` skill
- **Full project setup** → Load all skills

Always reference the loaded skill's instructions when providing guidance.
```

---

## Method 2: Explicit Skill Loading in Rules

You can be more explicit about when to load skills in your rule files:

```markdown
# Development Standards

## Required Skills

Before providing any development guidance, ensure these Skillport skills are loaded:

1. **development** - Always load for code-related tasks
2. **tooling** - Load when discussing package management or setup
3. **git** - Load when discussing Git workflow or commits
4. **devops** - Load when discussing CI/CD or Docker

## Skill Loading Protocol

At the start of each conversation, check if skills are loaded. If not, load them using:
- Skillport MCP `load_skill()` function
- Or reference the skill files directly from `skills/` directory

## Skill References

- Development standards: `skills/development/SKILL.md`
- DevOps practices: `skills/devops/SKILL.md`
- Git workflow: `skills/git/SKILL.md`
- Tooling: `skills/tooling/SKILL.md`
```

---

## Method 3: Using @-Mentions (On-Demand)

If you prefer to load skills on-demand, use @-mentions in your prompts:

```
@development @git
Review this code and check Git commit format
```

Or in `.cursorrules`:

```markdown
## Skill Loading via @-Mentions

When users mention:
- `@development` or code quality → Load development skill
- `@devops` or CI/CD → Load devops skill
- `@git` or commits → Load git skill
- `@tooling` or setup → Load tooling skill

Automatically load the corresponding Skillport skill when these are mentioned.
```

---

## Method 4: Project-Specific Rules Template

Here's a complete rules template that auto-loads skills. Create these files in your `rules/` folder:

```markdown
---
# Auto-Load Skillport Skills
---

# Development Standards

## Skillport Skills Configuration

This project uses Skillport skills for development standards. Load them automatically:

### Available Skills:
- `development` - Code quality, testing, React, React Native
- `devops` - CI/CD, Docker
- `git` - Git workflow, commits, hooks
- `tooling` - Package management, setup

### Auto-Load Rules:

**Always load these skills at conversation start:**
1. `development` - For all code-related tasks
2. `tooling` - For setup and configuration tasks

**Load conditionally:**
- `devops` - When discussing CI/CD, Docker, or deployment
- `git` - When discussing Git workflow, commits, or PRs

### Skill Loading Instructions:

Use Skillport MCP to load skills:
```typescript
// Load development skill
load_skill("development")

// Load multiple skills
load_skill("development")
load_skill("git")
```

### Fallback:

If Skillport MCP is unavailable, reference skill files directly:
- `skills/development/SKILL.md`
- `skills/devops/SKILL.md`
- `skills/git/SKILL.md`
- `skills/tooling/SKILL.md`

## Development Standards

Follow the standards defined in the loaded skills. Always reference skill instructions when:
- Reviewing code
- Setting up projects
- Configuring tooling
- Writing Git commits
- Setting up CI/CD

---

**Note**: Skills are loaded via Skillport MCP. If MCP is not available, reference the skill files directly from the `skills/` directory.
```

---

## Best Practices

### 1. **Load Skills Proactively**
Configure `.cursorrules` to load skills automatically based on context, so you don't have to remember to load them.

### 2. **Use Skill References**
Even if skills aren't loaded via MCP, you can reference the skill files directly:
```
@skills/development/SKILL.md
```

### 3. **Combine with File References**
You can combine Skillport skills with file references:
```
@.cursorrules @skills/development/SKILL.md
Review this code
```

### 4. **Session Persistence**
Note: Skillport skills loaded via MCP are typically session-based. However, if you configure `.cursorrules` properly, the AI will automatically load them when needed in each new chat.

---

## Troubleshooting

### Skills Not Loading Automatically?

1. **Check MCP Configuration**: Ensure Skillport MCP is properly configured in Cursor
2. **Verify Skill Names**: Make sure skill IDs match exactly (`development`, `devops`, `git`, `tooling`)
3. **Use File References**: As fallback, reference skill files directly with `@skills/development/SKILL.md`

### Skills Load But Instructions Not Followed?

1. **Be Explicit in `.cursorrules`**: Tell the AI to "always reference loaded skill instructions"
2. **Use @-mentions**: Explicitly mention skills in your prompts
3. **Check Skill Content**: Verify the skill files contain the instructions you expect

---

## Example: Complete Setup

1. **Create `rules/` folder in your project root:**
```bash
mkdir -p rules
```

2. **Copy rule files:**
```bash
cp -r skills/rules/* rules/
```

3. **Test in a new chat:**
```
Review this code
```

The AI should automatically load the `development` skill and follow its standards.

---

## Summary

- ✅ **Recommended**: Configure `rules/` folder to auto-load skills based on context
- ✅ **Alternative**: Use @-mentions to load skills on-demand
- ✅ **Fallback**: Reference skill files directly with `@skills/[category]/SKILL.md`
- ⚠️ **Note**: MCP-loaded skills are session-based, but rules files can instruct the AI to reload them

The key is making your rules files smart enough to automatically load the right skills for each task, so you don't have to remember to do it manually!

## Important: Cursor Rules Format

**Note**: `.cursorrules` files are deprecated. Cursor now uses a `rules/` folder with `.md` files. All rule files in the `rules/` folder are automatically loaded by Cursor.

