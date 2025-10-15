# Release Guide

This guide explains how to create releases for the Sayar app.

## Release Types

### 1. UAT Release (Beta Testing)
- **Trigger**: Automatic on every push to `develop` branch
- **Distribution**: Firebase App Distribution
- **Versioning**: Automatic build number increment
- **Icon**: BETA badge

**Process:**
```bash
# Simply push to develop
git push origin develop
```

### 2. Production Release (App Store/TestFlight)
- **Trigger**: Manual via git tag
- **Distribution**: TestFlight → App Store
- **Versioning**: Manual semantic versioning (v1.2.3)
- **Icon**: Clean production icon

## How to Create a Production Release

### Step 1: Prepare the Release

1. **Ensure all changes are merged to master**
   ```bash
   git checkout master
   git pull origin master
   ```

2. **Review unreleased changes**
   ```bash
   brew install git-cliff
   git-cliff --unreleased
   ```

3. **Verify the app builds successfully**
   ```bash
   tuist generate
   # Build in Xcode with Prod scheme
   ```

### Step 2: Create and Push the Version Tag

1. **Decide the version number** (Semantic Versioning):
   - **MAJOR** (1.0.0 → 2.0.0): Breaking changes, major redesign
   - **MINOR** (1.0.0 → 1.1.0): New features, backwards compatible
   - **PATCH** (1.0.0 → 1.0.1): Bug fixes, small improvements

2. **Create the tag**
   ```bash
   # Example for version 1.2.3
   git tag v1.2.3 -m "Release v1.2.3"
   ```

3. **Push the tag**
   ```bash
   git push origin v1.2.3
   ```

### Step 3: Monitor the Deployment

1. Go to [GitHub Actions](https://github.com/mkemalgokce/Sayar/actions)
2. Watch the "Deploy to Production" workflow
3. The workflow will:
   - ✅ Validate version format (must be v1.2.3)
   - ✅ Check for unreleased changes
   - ✅ Generate CHANGELOG
   - ✅ Build and archive the app
   - ✅ Upload to TestFlight
   - ✅ Commit CHANGELOG to master

### Step 4: TestFlight Distribution

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to TestFlight
3. The build will appear in 5-10 minutes
4. Add testing notes and submit for external testing
5. Once approved, distribute to testers

### Step 5: App Store Submission (Optional)

1. In App Store Connect, go to "App Store" tab
2. Create a new version (must match the tag version)
3. Select the TestFlight build
4. Fill in release notes and metadata
5. Submit for review

## Troubleshooting

### "No unreleased changes found"
**Problem**: The workflow fails because there are no new commits since the last release.

**Solution**: Make sure you have commits on master since the last tag. Check with:
```bash
git log $(git describe --tags --abbrev=0)..HEAD --oneline
```

### "Invalid version format"
**Problem**: The tag doesn't follow semantic versioning (v1.2.3).

**Solution**: Delete the tag and create a new one with correct format:
```bash
git tag -d v1.2  # Delete wrong tag
git push origin :refs/tags/v1.2  # Delete from remote
git tag v1.2.0 -m "Release v1.2.0"  # Create correct tag
git push origin v1.2.0
```

### "Version already exists in CHANGELOG"
**Problem**: Warning that the version was already released.

**Solution**: This is usually fine if you're re-deploying. If you want a new release, use a new version number (increment patch: 1.2.3 → 1.2.4).

### Deployment failed but tag exists
**Problem**: The deployment failed after creating the tag.

**Solution**: Fix the issue, then re-push the same tag:
```bash
# Deployment will retry with the same tag
git push origin v1.2.3
```

## Version History

Check [CHANGELOG.md](../CHANGELOG.md) for version history.

## Quick Reference

```bash
# Create a new patch release (1.0.0 → 1.0.1)
git tag v1.0.1 -m "Release v1.0.1" && git push origin v1.0.1

# Create a new minor release (1.0.0 → 1.1.0)
git tag v1.1.0 -m "Release v1.1.0" && git push origin v1.1.0

# Create a new major release (1.0.0 → 2.0.0)
git tag v2.0.0 -m "Release v2.0.0" && git push origin v2.0.0

# List all tags
git tag -l

# Delete a tag (if you made a mistake)
git tag -d v1.2.3
git push origin :refs/tags/v1.2.3
```
