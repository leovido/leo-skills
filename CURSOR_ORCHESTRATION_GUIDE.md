# AI Orchestration with Cursor - Practical Guide

This guide shows you how to implement multi-agent orchestration specifically within Cursor's environment.

## Table of Contents

1. [Understanding Cursor's Capabilities](#understanding-cursors-capabilities)
2. [Method 1: Cursor Rules for Agent Orchestration](#method-1-cursor-rules)
3. [Method 2: Structured Prompts in Composer](#method-2-structured-prompts)
4. [Method 3: Agent Workflow Scripts](#method-3-agent-workflow-scripts)
5. [Method 4: Custom Commands](#method-4-custom-commands)
6. [Practical Examples](#practical-examples)

---

## Understanding Cursor's Capabilities

Cursor supports orchestration through:

- **`.cursorrules`** - Project-wide rules that guide AI behavior
- **Composer** - Multi-file editing with context awareness
- **Chat** - Conversational AI with file context
- **Custom Commands** - Reusable prompt templates
- **@-mentions** - Reference files, folders, and code

---

## Method 1: Cursor Rules for Agent Orchestration

Create a `.cursorrules` file in your project root to define agent behavior.

### Basic Orchestration Rules

```markdown
# Multi-Agent Development Orchestration

## Agent Roles

You are an orchestrator managing multiple specialized AI agents. When a task is requested, follow this workflow:

### Step 1: Task Analysis
- Analyze the user's request
- Determine which agents are needed
- Identify dependencies between agents

### Step 2: Agent Execution
Execute agents in this order when reviewing code:

1. **Code Quality Agent**
   - Check: Biome linting compliance
   - Check: TypeScript strict mode
   - Check: Code formatting
   - Report: Format findings as {type: "error|warning|info", rule: "rule-id", message: "...", fix: "..."}

2. **Security Agent**
   - Check: Dependency vulnerabilities
   - Check: Authentication patterns
   - Check: Input validation
   - Report: Security findings with severity levels

3. **Testing Agent**
   - Check: Test coverage
   - Check: Test quality
   - Check: Missing test cases
   - Report: Testing recommendations

4. **Architecture Agent**
   - Check: Domain-Driven Design structure
   - Check: Folder organization
   - Check: Pattern compliance
   - Report: Architectural findings

### Step 3: Result Aggregation
- Collect all agent findings
- Prioritize by severity (security > architecture > code quality > testing)
- Generate unified report
- Provide actionable recommendations

## Agent Communication Format

When acting as an agent, always format your response as:

```json
{
  "agent": "agent-name",
  "findings": [
    {
      "type": "error|warning|info",
      "rule": "rule-id",
      "location": "file:line:column",
      "message": "Description",
      "severity": 1-10,
      "fix": "Suggested fix or null"
    }
  ],
  "recommendations": [
    {
      "priority": "high|medium|low",
      "action": "What to do",
      "rationale": "Why"
    }
  ]
}
```

## Conflict Resolution

- Security findings always take precedence over code quality
- Architecture findings take precedence over code quality
- When priorities are equal, present both options to user

## Skills Reference

Always reference SKILLS.md for:
- Tooling requirements (Biome, pnpm, TypeScript)
- Project structure (DDD)
- Git workflow (Conventional Commits)
- Testing standards (Jest)
```

### Advanced Orchestration with Decision Trees

```markdown
# Advanced Multi-Agent Orchestration

## Workflow Selection

Based on the task type, select the appropriate workflow:

### Code Review Workflow
IF task involves "review", "check", "audit", "inspect":
  THEN execute: Code Quality → Security → Testing → Architecture → Orchestrator
  OUTPUT: Unified review report

### Project Setup Workflow  
IF task involves "setup", "initialize", "create project":
  THEN execute in parallel: Architecture + Code Quality + Documentation
  OUTPUT: Setup checklist and configuration files

### Feature Development Workflow
IF task involves "feature", "implement", "add":
  THEN execute: Architecture (plan) → Code Quality + Security (implement) → Testing (validate)
  OUTPUT: Feature implementation with tests

### Migration Workflow
IF task involves "migrate", "upgrade", "convert":
  THEN execute: Orchestrator (analyze) → Code Quality (migrate) → Testing (validate)
  OUTPUT: Migration guide and updated code

## Agent Specialization

### Code Quality Agent
- Skill: leo-skills (code quality section)
- Focus: Biome, TypeScript, formatting
- Output: Linting errors, type errors, formatting issues

### Security Agent  
- Skill: security-skills (to be created)
- Focus: Vulnerabilities, auth patterns, OWASP
- Output: Security vulnerabilities, unsafe patterns

### Testing Agent
- Skill: leo-skills (testing section) + testing-skills
- Focus: Coverage, test quality, missing tests
- Output: Coverage gaps, test improvements

### Architecture Agent
- Skill: leo-skills (project structure section)
- Focus: DDD structure, folder organization
- Output: Structural issues, organization suggestions

## Execution Patterns

### Sequential (Default for Reviews)
Execute agents one after another, passing context:
Agent1 → Agent2 → Agent3 → Orchestrator

### Parallel (For Setup)
Execute independent agents simultaneously:
[Agent1, Agent2, Agent3] → Orchestrator

### Hierarchical (For Features)
Orchestrator delegates to sub-agents:
Orchestrator → [Frontend Agents] + [Backend Agents] → Merge
```

---

## Method 2: Structured Prompts in Composer

Use Cursor's Composer with structured prompts to orchestrate agents.

### Example: Code Review Orchestration

**Prompt for Composer:**

```
I need a comprehensive code review. Please act as an orchestrator and coordinate the following agents:

1. CODE QUALITY AGENT:
   - Review all TypeScript files for type safety
   - Check Biome linting compliance
   - Verify code formatting
   - Report findings in structured format

2. SECURITY AGENT:
   - Scan for common vulnerabilities
   - Review authentication/authorization patterns
   - Check for unsafe patterns (XSS, injection, etc.)
   - Report security findings

3. TESTING AGENT:
   - Analyze test coverage
   - Review test quality
   - Identify missing test cases
   - Suggest test improvements

4. ARCHITECTURE AGENT:
   - Validate Domain-Driven Design structure
   - Check folder organization
   - Review component organization
   - Suggest structural improvements

After each agent completes, aggregate all findings and:
- Prioritize by severity (errors first, then warnings)
- Group by category
- Provide actionable fixes
- Generate a compliance score

Format the final report as:
- Summary
- Critical Issues (errors)
- Warnings
- Recommendations
- Compliance Score (0-100)
```

### Example: Project Setup Orchestration

**Prompt for Composer:**

```
Set up a new Next.js project following our standards. Coordinate these agents:

1. ARCHITECTURE AGENT:
   - Create Domain-Driven Design folder structure
   - Set up src/domains/{domain}/ structure
   - Create shared/ folder

2. CODE QUALITY AGENT:
   - Initialize Biome configuration
   - Set up TypeScript with strict mode
   - Configure package.json scripts
   - Create .gitignore

3. DOCUMENTATION AGENT:
   - Generate README.md
   - Create .env.example
   - Document setup process

Execute these agents in parallel, then verify all configurations are correct.
```

---

## Method 3: Agent Workflow Scripts

Create reusable scripts that Cursor can execute to orchestrate agents.

### Script: `scripts/orchestrate-review.sh`

```bash
#!/bin/bash
# Multi-agent code review orchestration

echo "🔍 Starting Multi-Agent Code Review"
echo "===================================="

# Agent 1: Code Quality
echo ""
echo "📋 Agent 1: Code Quality"
echo "-----------------------"
pnpm run lint 2>&1 | tee /tmp/code-quality.log
pnpm run typecheck 2>&1 | tee -a /tmp/code-quality.log

# Agent 2: Security
echo ""
echo "🔒 Agent 2: Security"
echo "-------------------"
pnpm audit --audit-level=moderate 2>&1 | tee /tmp/security.log

# Agent 3: Testing
echo ""
echo "🧪 Agent 3: Testing"
echo "------------------"
pnpm run test:ci 2>&1 | tee /tmp/testing.log

# Orchestrator: Aggregate Results
echo ""
echo "📊 Orchestrator: Aggregating Results"
echo "------------------------------------"

# Parse and format results
echo "## Code Review Report" > review-report.md
echo "" >> review-report.md
echo "### Code Quality Findings" >> review-report.md
cat /tmp/code-quality.log >> review-report.md
echo "" >> review-report.md
echo "### Security Findings" >> review-report.md
cat /tmp/security.log >> review-report.md
echo "" >> review-report.md
echo "### Testing Findings" >> review-report.md
cat /tmp/testing.log >> review-report.md

echo "✅ Review complete! See review-report.md"
```

### Script: `scripts/orchestrate-setup.sh`

```bash
#!/bin/bash
# Multi-agent project setup orchestration

echo "🚀 Starting Multi-Agent Project Setup"
echo "======================================"

# Run setup script (which internally orchestrates)
./setup.sh

# Verify setup with agents
echo ""
echo "✅ Verifying Setup with Agents"
echo "-------------------------------"

# Architecture Agent: Check structure
echo "📁 Checking project structure..."
if [ -d "src/domains" ]; then
  echo "✅ DDD structure exists"
else
  echo "❌ DDD structure missing"
fi

# Code Quality Agent: Check tooling
echo "🔧 Checking tooling..."
if [ -f "biome.json" ]; then
  echo "✅ Biome configured"
else
  echo "❌ Biome not configured"
fi

if [ -f "tsconfig.json" ]; then
  echo "✅ TypeScript configured"
else
  echo "❌ TypeScript not configured"
fi

# Documentation Agent: Check docs
echo "📚 Checking documentation..."
if [ -f "README.md" ]; then
  echo "✅ README exists"
else
  echo "❌ README missing"
fi

echo ""
echo "🎉 Setup verification complete!"
```

---

## Method 4: Custom Commands

Create custom commands in Cursor for common orchestration workflows.

### Command: `cursor-commands/code-review.md`

```markdown
# Multi-Agent Code Review

Run a comprehensive code review using multiple specialized agents.

## Workflow

1. **Code Quality Agent**: Check linting, TypeScript, formatting
2. **Security Agent**: Scan for vulnerabilities and unsafe patterns
3. **Testing Agent**: Analyze test coverage and quality
4. **Architecture Agent**: Validate project structure
5. **Orchestrator**: Aggregate and prioritize findings

## Output Format

Generate a report with:
- Summary of findings
- Critical issues (errors)
- Warnings
- Recommendations
- Compliance score

## Instructions

Act as an orchestrator. For each file in the current workspace:

1. Run Code Quality Agent checks
2. Run Security Agent checks  
3. Run Testing Agent checks
4. Run Architecture Agent checks
5. Aggregate all findings
6. Generate unified report

Reference SKILLS.md for standards and rules.
```

### Command: `cursor-commands/project-setup.md`

```markdown
# Multi-Agent Project Setup

Set up a new project following all best practices.

## Workflow

Execute in parallel:
- **Architecture Agent**: Create DDD structure
- **Code Quality Agent**: Configure tooling
- **Documentation Agent**: Create documentation

## Instructions

1. Analyze project type (Next.js, React Native, etc.)
2. Create Domain-Driven Design folder structure
3. Initialize Biome, TypeScript, Jest
4. Set up git hooks with Lefthook
5. Create configuration files
6. Generate README and documentation
7. Verify all setup steps

Use setup.sh script and SKILLS.md as reference.
```

---

## Practical Examples

### Example 1: Review a Pull Request

**In Cursor Chat:**

```
@CTO_REVIEW.md @SKILLS.md

I need to review this pull request. Act as an orchestrator and:

1. Load the code quality standards from SKILLS.md
2. Run Code Quality Agent on all changed files
3. Run Security Agent checks
4. Run Testing Agent to verify test coverage
5. Aggregate findings and generate report

Focus on:
- TypeScript strict mode compliance
- Biome linting rules
- Domain-Driven Design structure
- Test coverage requirements
```

### Example 2: Set Up New Feature

**In Cursor Composer:**

```
Create a new authentication feature following our standards. Coordinate:

1. ARCHITECTURE AGENT:
   - Create src/domains/auth/ structure
   - Set up components/, hooks/, utils/, types/, __tests__/

2. CODE QUALITY AGENT:
   - Ensure TypeScript strict mode
   - Follow Biome rules
   - Use proper naming conventions

3. SECURITY AGENT:
   - Implement secure authentication patterns
   - Add input validation
   - Follow OWASP guidelines

4. TESTING AGENT:
   - Write unit tests for utilities
   - Write integration tests for flows
   - Achieve 80%+ coverage

Execute agents in sequence, with each building on the previous.
```

### Example 3: Migrate ESLint to Biome

**In Cursor Chat:**

```
@SKILLS.md

Help me migrate from ESLint to Biome. Act as orchestrator:

1. CODE QUALITY AGENT:
   - Analyze current ESLint configuration
   - Map ESLint rules to Biome equivalents
   - Create biome.json configuration
   - Update package.json scripts

2. TESTING AGENT:
   - Verify no linting regressions
   - Run tests to ensure nothing broke

3. DOCUMENTATION AGENT:
   - Update README with Biome instructions
   - Document migration changes

Provide step-by-step migration plan.
```

---

## Advanced: Dynamic Agent Selection

Create a smart orchestrator that selects agents based on context.

### `.cursorrules` with Dynamic Selection

```markdown
# Smart Agent Orchestration

## Agent Selection Logic

Analyze the user's request and automatically select appropriate agents:

IF request contains "security", "auth", "vulnerability":
  INCLUDE Security Agent

IF request contains "test", "coverage", "jest":
  INCLUDE Testing Agent

IF request contains "structure", "folder", "organization":
  INCLUDE Architecture Agent

IF request contains "lint", "format", "biome", "typescript":
  INCLUDE Code Quality Agent

IF request contains "setup", "initialize", "create":
  INCLUDE Architecture + Code Quality + Documentation Agents

IF request contains "review", "audit", "check":
  INCLUDE ALL Agents (sequential workflow)

## Execution Strategy

- Single agent request: Execute directly
- Multiple agents, no dependencies: Execute in parallel
- Multiple agents, with dependencies: Execute sequentially
- Complex task: Use hierarchical orchestration

## Context Awareness

- Check project type (Next.js, React Native, etc.)
- Check existing tooling (Biome, ESLint, etc.)
- Check project structure (DDD, flat, etc.)
- Adapt agent behavior based on context
```

---

## Tips for Effective Orchestration

### 1. Use @-mentions for Context
```
@SKILLS.md @orchestrator.example.json
Review this code using our multi-agent workflow
```

### 2. Be Explicit About Agent Roles
```
Act as Code Quality Agent: Check Biome compliance
Act as Security Agent: Scan for vulnerabilities
Act as Orchestrator: Aggregate results
```

### 3. Use Structured Output
Request JSON or markdown formatted output for easier parsing:
```
Format your findings as JSON with this structure:
{
  "agent": "code_quality",
  "findings": [...],
  "recommendations": [...]
}
```

### 4. Chain Agents Explicitly
```
Step 1: Code Quality Agent reviews code
Step 2: Security Agent reviews Code Quality Agent's findings
Step 3: Orchestrator aggregates both
```

### 5. Save Agent Results
```
After each agent completes, save results to:
- /tmp/code-quality-results.json
- /tmp/security-results.json
Then aggregate in final step
```

---

## Troubleshooting

### Issue: Agents Not Following Workflow
**Solution**: Be more explicit in `.cursorrules` or use structured prompts

### Issue: Results Not Aggregated
**Solution**: Explicitly request aggregation step and provide format

### Issue: Conflicts Between Agents
**Solution**: Define conflict resolution rules in `.cursorrules`

### Issue: Too Many Agents Running
**Solution**: Use conditional logic to select only needed agents

---

## Next Steps

1. **Create `.cursorrules`** with orchestration logic
2. **Test with simple tasks** (single agent first)
3. **Expand to multi-agent workflows** (code review)
4. **Create custom commands** for common workflows
5. **Refine based on results**

---

## Example: Complete Setup

1. Create `.cursorrules` in project root
2. Add orchestration rules (see Method 1)
3. Test with: "Review this file using multi-agent workflow"
4. Create custom commands for common tasks
5. Integrate with your development workflow

---

**Remember**: Cursor's orchestration works best when you:
- Provide clear agent roles
- Use structured prompts
- Reference relevant files (@SKILLS.md)
- Request formatted output
- Chain agents explicitly

