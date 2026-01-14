#!/bin/bash
# Pobiera najnowszą wersję stabilną terraformer z GitHub API
set -e

REPO="GoogleCloudPlatform/terraformer"

# Pobierz latest release (pomijamy prereleases)
LATEST=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | \
    grep '"tag_name":' | \
    sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST" ]; then
    echo "ERROR: Could not fetch latest version" >&2
    exit 1
fi

echo "$LATEST"
