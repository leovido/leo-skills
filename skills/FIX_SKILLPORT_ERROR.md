# Fixing Skillport Validation Error

## Problem

When adding a skill from `https://github.com/Dammyjay93/claude-design-skill`, skillport errors with:
```
frontmatter.name 'design-principles' doesn't match directory 'skill'
```

This happens because skillport validates that the skill directory name matches the `frontmatter.name` in the skill's metadata, and this repository has a mismatch.

## Solution: Manual Fix

Since the validation happens regardless of Flat/Namespace mode, you need to fix the skill repository structure locally:

### Step 1: Clone the Repository

```bash
cd /Users/christianrayleovido/Documents/Christian/vibe-coding/leo-skills
git clone https://github.com/Dammyjay93/claude-design-skill.git temp-claude-design-skill
cd temp-claude-design-skill
```

### Step 2: Inspect the Structure

Check what's in the repository:
```bash
ls -la
# Look for a directory named 'skill' and check the frontmatter
```

### Step 3: Fix the Mismatch

You have two options:

#### Option A: Rename the Directory
If the skill is in a directory called `skill`, rename it to match `design-principles`:
```bash
# If the skill is in a 'skill' directory
mv skill design-principles
```

#### Option B: Fix the Frontmatter
If you prefer to keep the directory name, update the frontmatter in the skill's metadata file:
```bash
# Find the frontmatter file (usually in README.md or a .md file)
# Change frontmatter.name from 'design-principles' to 'skill'
```

### Step 4: Add from Local Path

Once fixed, add the skill from the local directory:
```bash
cd /Users/christianrayleovido/Documents/Christian/vibe-coding/leo-skills
skillport add ./temp-claude-design-skill
# Choose option 1 (Flat) when prompted
```

### Step 5: Cleanup

After successfully adding:
```bash
rm -rf temp-claude-design-skill
```

## Alternative: Fork and Fix

If you want a permanent solution:

1. **Fork the repository** on GitHub
2. **Fix the mismatch** (rename directory or update frontmatter)
3. **Push your changes**
4. **Add from your fork**:
   ```bash
   skillport add https://github.com/YOUR_USERNAME/claude-design-skill
   ```

## Understanding the Validation

Skillport requires:
- The skill directory name (in the repository) must match `frontmatter.name`
- This ensures consistency and prevents naming conflicts
- The validation runs for both Flat and Namespace modes

## Quick Check Script

To quickly check if a skill repository has this issue:

```bash
#!/bin/bash
REPO_URL=$1
TEMP_DIR=$(mktemp -d)
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null

# Find skill directory
SKILL_DIR=$(find "$TEMP_DIR" -type d -name "skill" -o -type d -name "design-principles" | head -1)
SKILL_DIR_NAME=$(basename "$SKILL_DIR")

# Find frontmatter.name
FRONTMATTER_NAME=$(grep -r "frontmatter.name" "$TEMP_DIR" | grep -oE "'[^']+'" | head -1 | tr -d "'")

if [ "$SKILL_DIR_NAME" != "$FRONTMATTER_NAME" ]; then
  echo "❌ Mismatch: Directory '$SKILL_DIR_NAME' != frontmatter.name '$FRONTMATTER_NAME'"
else
  echo "✅ Match: Directory and frontmatter.name both are '$SKILL_DIR_NAME'"
fi

rm -rf "$TEMP_DIR"
```

Usage:
```bash
chmod +x check-skill.sh
./check-skill.sh https://github.com/Dammyjay93/claude-design-skill
```

