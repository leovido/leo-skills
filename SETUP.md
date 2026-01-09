# Quick Setup Guide

## Publishing to GitHub for Skillport

### Step 1: Initialize Git Repository

```bash
cd /path/to/leo-skills
git init
git add .
git commit -m "feat: add development skills and best practices"
```

### Step 2: Create GitHub Repository

1. Go to [GitHub](https://github.com/new)
2. Create a new repository named `leo-skills` (or your preferred name)
3. Make it **public** (required for Skillport to access it)
4. Don't initialize with README, .gitignore, or license (we already have these)

### Step 3: Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/leo-skills.git
git branch -M main
git push -u origin main
```

### Step 4: Update Repository URL

Edit `skill.json` and `README.md` to replace `yourusername` with your actual GitHub username:

```bash
# Update skill.json
sed -i '' 's/yourusername/YOUR_USERNAME/g' skill.json

# Update README.md
sed -i '' 's/yourusername/YOUR_USERNAME/g' README.md
```

Then commit and push:

```bash
git add skill.json README.md
git commit -m "chore: update repository URLs"
git push
```

## Using with Skillport

### Option 1: Via Skillport MCP (if configured)

If you have Skillport MCP configured, you can:

1. Search for your skill: `skillport search "react best practices"`
2. Load the skill: `skillport load leo-skills`
3. Follow the instructions in SKILLS.md

### Option 2: Direct GitHub Access

Others can clone or reference your repository:

```bash
git clone https://github.com/YOUR_USERNAME/leo-skills.git
cd leo-skills
# Review SKILLS.md and copy relevant template files
```

### Option 3: Add to Skillport Registry

If Skillport has a public registry:

1. Fork or submit a PR to the Skillport registry repository
2. Add your skill's GitHub URL to the registry
3. Follow Skillport's contribution guidelines

## Using in Your Projects

### For New Projects

1. Clone this repository or reference it
2. Copy template files to your project:
   ```bash
   cp lefthook.yml.example lefthook.yml
   cp .gitignore.example .gitignore
   cp .github/workflows/pr-checks.yml.example .github/workflows/pr-checks.yml
   cp docker-compose.yml.example docker-compose.yml
   ```
3. Customize configurations for your project
4. Review SKILLS.md and implement best practices

### For Existing Projects

1. Review SKILLS.md for relevant practices
2. Copy and adapt template files as needed
3. Gradually adopt practices (don't try to implement everything at once)

## Next Steps

- [ ] Update `skill.json` with your GitHub username
- [ ] Update `README.md` with your GitHub username
- [ ] Add a LICENSE file (MIT, Apache 2.0, etc.)
- [ ] Push to GitHub
- [ ] Share the repository with your team
- [ ] Consider adding more examples or use cases

