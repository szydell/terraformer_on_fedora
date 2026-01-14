#!/bin/bash
# Generuje wpis changelog dla spec file
set -e

VERSION="${1:?VERSION required}"
RELEASE="${2:?RELEASE required}"
REPO="GoogleCloudPlatform/terraformer"

# Pobierz release notes z GitHub API
RELEASE_NOTES=$(curl -s "https://api.github.com/repos/${REPO}/releases/tags/${VERSION}" | \
    jq -r '.body // "No release notes available"' | \
    head -20 | \
    sed 's/^/  /')

# Data w formacie RPM changelog
DATE=$(date "+%a %b %d %Y")

# Generuj wpis
cat << EOF
* ${DATE} Automated Build <terraformer-copr@szydelscy.pl> - ${VERSION}-${RELEASE}
- Update to version ${VERSION}
${RELEASE_NOTES}

EOF
