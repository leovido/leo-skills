#!/bin/bash

# Script to fix and add a skill with directory/name mismatch
# Usage: ./fix-and-add-skill.sh <repo-url> [target-dir]

set -euo pipefail

REPO_URL="${1:-}"
TARGET_DIR="${2:-skills/design-principles}"

if [ -z "$REPO_URL" ]; then
  echo "Usage: $0 <repo-url> [target-dir]"
  echo "Example: $0 https://github.com/Dammyjay93/claude-design-skill"
  exit 1
fi

REPO_NAME=$(basename "$REPO_URL" .git)
TEMP_DIR=$(mktemp -d -t skillport-fix-XXXXXX)

echo "📥 Cloning repository..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
  echo "❌ Failed to clone repository"
  exit 1
}

cd "$TEMP_DIR"

echo "🔍 Inspecting repository structure..."

# Find skill directory
SKILL_DIR=$(find . -type d -name "skill" -o -type d -name "design-principles" | grep -v ".git" | head -1)

if [ -z "$SKILL_DIR" ]; then
  echo "⚠️  Could not find skill directory. Listing all directories:"
  find . -type d -maxdepth 2 | grep -v ".git"
  echo ""
  read -p "Enter the skill directory name (or press Enter to use current directory): " SKILL_DIR
  SKILL_DIR="${SKILL_DIR:-.}"
fi

SKILL_DIR_NAME=$(basename "$SKILL_DIR")

# Find frontmatter.name
echo "🔍 Looking for frontmatter.name..."
FRONTMATTER_NAME=$(grep -r "frontmatter.name" . --include="*.md" --include="*.yaml" --include="*.yml" 2>/dev/null | \
  grep -oE "name:\s*['\"]?([^'\"]+)['\"]?" | \
  head -1 | \
  sed -E "s/name:\s*['\"]?([^'\"]+)['\"]?/\1/" || echo "")

if [ -z "$FRONTMATTER_NAME" ]; then
  # Try to find in skill.json
  if [ -f "skill.json" ]; then
    FRONTMATTER_NAME=$(grep -oE '"id"\s*:\s*"([^"]+)"' skill.json | sed -E 's/"id"\s*:\s*"([^"]+)"/\1/' || echo "")
  fi
fi

echo "📊 Found:"
echo "   Directory: $SKILL_DIR_NAME"
echo "   Frontmatter name: ${FRONTMATTER_NAME:-unknown}"

# Determine the correct name
if [ -n "$FRONTMATTER_NAME" ] && [ "$SKILL_DIR_NAME" != "$FRONTMATTER_NAME" ]; then
  echo ""
  echo "⚠️  Mismatch detected!"
  echo "   Directory: '$SKILL_DIR_NAME'"
  echo "   Frontmatter: '$FRONTMATTER_NAME'"
  echo ""
  read -p "Fix by renaming directory to '$FRONTMATTER_NAME'? (y/n): " FIX_IT
  
  if [ "$FIX_IT" = "y" ] || [ "$FIX_IT" = "Y" ]; then
    if [ "$SKILL_DIR" != "." ]; then
      cd "$(dirname "$SKILL_DIR")"
      mv "$SKILL_DIR_NAME" "$FRONTMATTER_NAME"
      SKILL_DIR="./$FRONTMATTER_NAME"
    fi
    echo "✅ Directory renamed"
  fi
fi

# Create target directory
TARGET_PARENT=$(dirname "$TARGET_DIR")
mkdir -p "$TARGET_PARENT"

# Copy skill to target
echo "📦 Copying skill to $TARGET_DIR..."
if [ -d "$SKILL_DIR" ] && [ "$SKILL_DIR" != "." ]; then
  cp -r "$SKILL_DIR"/* "$TARGET_DIR" 2>/dev/null || {
    # If target exists, ask
    if [ -d "$TARGET_DIR" ]; then
      read -p "Target directory exists. Overwrite? (y/n): " OVERWRITE
      if [ "$OVERWRITE" = "y" ] || [ "$OVERWRITE" = "Y" ]; then
        rm -rf "$TARGET_DIR"
        cp -r "$SKILL_DIR"/* "$TARGET_DIR"
      else
        echo "❌ Aborted"
        rm -rf "$TEMP_DIR"
        exit 1
      fi
    fi
  }
else
  cp -r . "$TARGET_DIR"
fi

echo "✅ Skill added to $TARGET_DIR"

# Cleanup
rm -rf "$TEMP_DIR"

echo "🎉 Done! Skill is now available at $TARGET_DIR"

