#!/bin/bash
# Generates changelog entry for spec file
set -e

VERSION="${1:?VERSION required}"
RELEASE="${2:?RELEASE required}"
REPO="GoogleCloudPlatform/terraformer"

# Fetch release notes from GitHub API
RELEASE_NOTES=$(curl -s "https://api.github.com/repos/${REPO}/releases/tags/${VERSION}" | \
    jq -r '.body // "No release notes available"' | \
    head -20 | \
    sed 's/^/  /')

# Date in RPM changelog format
DATE=$(date "+%a %b %d %Y")

# Generate entry
cat << EOF
* ${DATE} Automated Build <terraformer-copr@szydelscy.pl> - ${VERSION}-${RELEASE}
- Update to version ${VERSION}
${RELEASE_NOTES}

EOF
