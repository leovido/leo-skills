# Testing and Validation

## Ensuring Setup Script Reliability

To guarantee the setup script works in one try, we've implemented several measures:

## 1. Robust Error Handling

The script uses `set -euo pipefail` which means:
- **`-e`**: Exit immediately if any command fails
- **`-u`**: Exit if any undefined variable is used
- **`-o pipefail`**: Return value of a pipeline is the status of the last command to exit with a non-zero status

## 2. Pre-flight Checks

Before attempting any setup, the script:
- ✅ Verifies the directory is writable
- ✅ Checks Node.js is installed and version >= 18
- ✅ Verifies npm or pnpm is available
- ✅ Validates git can be initialized if needed

## 3. Fallback Mechanisms

The script includes fallbacks for common issues:

### pnpm Installation
- Tries `npm install -g pnpm` first
- Falls back to `corepack` if available
- Provides clear error messages if both fail

### Lefthook Installation
- Checks for global installation first
- Falls back to dev dependency installation
- Continues without failing if installation isn't possible

### File Creation
- Tries to copy from `.example` templates first
- Falls back to creating default files
- Validates files were actually created

## 4. Validation Script

Run the validation script to test the setup:

```bash
./validate-setup.sh
```

This script:
- Creates isolated test environments
- Tests setup on empty directories
- Tests setup with existing package.json
- Verifies all required files are created
- Verifies directory structure is correct
- Cleans up after testing

## 5. Safe Execution

The script is designed to be:
- **Idempotent**: Can be run multiple times safely
- **Non-destructive**: Never overwrites existing files
- **Informative**: Provides clear feedback on what's happening
- **Resilient**: Continues even if some optional steps fail

## 6. Common Scenarios Tested

### Scenario 1: Brand New Project
```bash
mkdir my-new-project
cd my-new-project
../setup.sh
```
✅ Should work - creates everything from scratch

### Scenario 2: Project with package.json
```bash
mkdir my-project
cd my-project
pnpm init
../setup.sh
```
✅ Should work - installs dependencies and sets up hooks

### Scenario 3: Existing Project
```bash
cd existing-project
../setup.sh
```
✅ Should work - only adds missing files, doesn't overwrite

### Scenario 4: No Node.js
```bash
# Without Node.js installed
../setup.sh
```
❌ Should fail gracefully with clear error message

### Scenario 5: No Network Access
```bash
# Without internet
../setup.sh
```
⚠️ Will skip network-dependent steps (pnpm install, biome init) but continue with file creation

## 7. Manual Testing Checklist

Before using the script in production, test:

- [ ] Run on empty directory
- [ ] Run on directory with package.json
- [ ] Run on existing project (should be idempotent)
- [ ] Verify all files are created correctly
- [ ] Verify directory structure is correct
- [ ] Test with Node.js 18+
- [ ] Test with Node.js < 18 (should fail gracefully)
- [ ] Test without npm/pnpm (should fail gracefully)
- [ ] Test without network (should handle gracefully)

## 8. Troubleshooting

### Script fails immediately
- Check Node.js version: `node --version`
- Check write permissions: `ls -ld .`
- Check bash version: `bash --version`

### Files not created
- Check disk space: `df -h .`
- Check permissions: `ls -la`
- Review error messages in script output

### Lefthook not working
- Verify installation: `pnpm lefthook --version`
- Check package.json has lefthook: `grep lefthook package.json`
- Try manual install: `pnpm lefthook install`

### Biome not initialized
- Check network connection
- Try manually: `pnpm dlx @biomejs/biome init`
- Verify pnpm is working: `pnpm --version`

## 9. Continuous Validation

To ensure the script stays reliable:

1. **Run validation script** before committing changes
2. **Test on different environments** (macOS, Linux)
3. **Test with different Node.js versions** (18, 20, 22)
4. **Test with and without existing files**
5. **Monitor for common failure patterns**

## 10. Reporting Issues

If the script fails:

1. Note the exact error message
2. Check Node.js and pnpm versions
3. Verify you have write permissions
4. Try running with verbose output: `bash -x setup.sh`
5. Check if it's a network issue
6. Report with full context

## Success Criteria

The setup script is considered successful if:

✅ All required files are created
✅ Directory structure is correct
✅ Configuration files are valid
✅ Git hooks are installed (if possible)
✅ No critical errors occurred
✅ Script exits with code 0

Minor warnings are acceptable (e.g., optional tools not installed), but the core setup should complete successfully.

