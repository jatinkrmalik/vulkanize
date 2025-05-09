#!/bin/bash

# Release Automation Script for Vulkanize
# This script automates the process of creating a new release

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if version argument is provided
if [ $# -ne 1 ]; then
    echo -e "${RED}Error: Version number required${NC}"
    echo "Usage: $0 <version>"
    echo "Example: $0 1.1.0"
    exit 1
fi

# Strip 'v' prefix if provided
VERSION=${1#v}

# Validate version format (semver)
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Version must be in format X.Y.Z${NC}"
    exit 1
fi

# Confirm with the user
echo -e "${YELLOW}About to create release v$VERSION${NC}"
echo "This will:"
echo "1. Update version references in files"
echo "2. Commit the changes"
echo "3. Create a new tag v$VERSION"
echo "4. Push changes and tag to GitHub"
echo
read -p "Continue? (y/n): " CONFIRM
if [[ $CONFIRM != "y" && $CONFIRM != "Y" ]]; then
    echo "Release process canceled."
    exit 0
fi

# Make sure we're on the main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}Error: You must be on the main branch to create a release${NC}"
    exit 1
fi

# Make sure we have the latest changes
echo -e "${GREEN}Pulling latest changes...${NC}"
git pull

# Update version references in files
echo -e "${GREEN}Updating version references...${NC}"

# Update README.md badge
sed -i "s|/release/v[0-9]\+\.[0-9]\+\.[0-9]\+\.svg|/release/v$VERSION.svg|g" README.md

# Update releases/README.md
sed -i "s|### v[0-9]\+\.[0-9]\+\.[0-9]\+ (Upcoming)|### v$VERSION ($(date +'%B %d, %Y'))|g" releases/README.md

# Commit the changes
echo -e "${GREEN}Committing changes...${NC}"
git add README.md releases/README.md
git commit -m "Prepare for v$VERSION release"

# Create the tag
echo -e "${GREEN}Creating tag v$VERSION...${NC}"
git tag -a "v$VERSION" -m "Release v$VERSION"

# Push changes and tag
echo -e "${GREEN}Pushing changes and tag...${NC}"
git push origin main
git push origin "v$VERSION"

echo -e "${GREEN}Release v$VERSION created and pushed to GitHub${NC}"
echo "The GitHub Actions workflow will now automatically build and publish the release."
echo "You can monitor the progress at: https://github.com/[your-username]/vulkanize/actions"
