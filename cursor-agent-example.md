# Cursor Multi-Agent Orchestration - Quick Start Example

This is a practical example you can use right now in Cursor.

## Step 1: Create `.cursorrules` File

Copy the `.cursorrules.example` file to your project root as `.cursorrules`:

```bash
cp .cursorrules.example .cursorrules
```

## Step 2: Test with a Simple Code Review

Open Cursor Chat and try this prompt:

```
Review the current file using our multi-agent workflow. 

Act as orchestrator and coordinate:
1. Code Quality Agent - Check Biome and TypeScript compliance
2. Security Agent - Scan for vulnerabilities
3. Testing Agent - Check test coverage
4. Architecture Agent - Validate structure

Aggregate all findings and provide a prioritized report.
```

## Step 3: Test Project Setup

Try this in Cursor Composer:

```
Set up a new Next.js project following our standards.

Coordinate these agents:
- Architecture Agent: Create DDD structure
- Code Quality Agent: Configure Biome, TypeScript, Jest
- Documentation Agent: Create README

Execute in parallel, then verify everything is correct.
```

## Step 4: Create Custom Commands

In Cursor, you can create custom commands. Here's an example:

### Command: "Multi-Agent Code Review"

**Prompt:**
```
@.cursorrules @SKILLS.md

Perform a comprehensive code review using multi-agent orchestration:

1. CODE QUALITY AGENT:
   - Check Biome linting on all TypeScript files
   - Verify TypeScript strict mode compliance
   - Check code formatting
   - Report: Format as structured JSON

2. SECURITY AGENT:
   - Scan dependencies for vulnerabilities
   - Review authentication patterns
   - Check for unsafe patterns
   - Report: Security findings with severity

3. TESTING AGENT:
   - Analyze test coverage
   - Review test quality
   - Identify missing tests
   - Report: Testing recommendations

4. ARCHITECTURE AGENT:
   - Validate DDD structure
   - Check folder organization
   - Review component organization
   - Report: Structural findings

ORCHESTRATOR:
- Aggregate all findings
- Prioritize by severity (errors > warnings > info)
- Resolve conflicts (security > architecture > code quality)
- Generate unified report with:
  * Summary
  * Critical Issues
  * Warnings
  * Recommendations
  * Compliance Score (0-100)
```

## Step 5: Use in Daily Workflow

### For Code Reviews:
```
@.cursorrules
Review this PR using multi-agent workflow. Focus on:
- TypeScript strict mode
- Biome compliance
- Security patterns
- Test coverage
```

### For New Features:
```
@.cursorrules @SKILLS.md
Create a new user profile feature. Coordinate:
1. Architecture Agent - Plan DDD structure
2. Code Quality Agent - Implement with standards
3. Security Agent - Ensure secure patterns
4. Testing Agent - Add comprehensive tests
```

### For Migrations:
```
@.cursorrules
Help migrate from ESLint to Biome. Orchestrate:
1. Analyze current ESLint config
2. Map to Biome equivalents
3. Create biome.json
4. Update scripts
5. Verify no regressions
```

## Advanced: Dynamic Agent Selection

You can make the orchestrator smarter by adding this to `.cursorrules`:

```markdown
## Smart Agent Selection

Automatically select agents based on request:

IF request contains "security" OR "auth" OR "vulnerability":
  INCLUDE Security Agent

IF request contains "test" OR "coverage" OR "jest":
  INCLUDE Testing Agent

IF request contains "structure" OR "folder" OR "organization":
  INCLUDE Architecture Agent

IF request contains "lint" OR "format" OR "biome":
  INCLUDE Code Quality Agent

IF request contains "review" OR "audit":
  INCLUDE ALL Agents (full review)

IF request contains "setup" OR "initialize":
  INCLUDE Architecture + Code Quality + Documentation
```

Then you can simply say:
```
Review this code
```

And the orchestrator will automatically select the right agents!

## Tips for Best Results

1. **Be explicit about agent roles**: "Act as Code Quality Agent..."
2. **Use @-mentions**: Reference `.cursorrules` and `SKILLS.md`
3. **Request structured output**: Ask for JSON or markdown format
4. **Chain agents**: "First Code Quality, then Security, then aggregate"
5. **Provide context**: Mention project type, framework, etc.

## Troubleshooting

**Agents not following workflow?**
- Make `.cursorrules` more explicit
- Use structured prompts with clear steps

**Results not aggregated?**
- Explicitly request aggregation step
- Provide output format template

**Too many agents running?**
- Use conditional logic in `.cursorrules`
- Be specific about which agents you need

## Next Steps

1. ✅ Create `.cursorrules` in your project
2. ✅ Test with simple code review
3. ✅ Create custom commands for common workflows
4. ✅ Integrate into daily development
5. ✅ Refine based on results

---

**You're ready to start orchestrating!** Try the examples above and see how multi-agent workflows improve your development process.

