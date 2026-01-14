#!/bin/bash
# Build SRPM for terraformer
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read version and release
VERSION=$(cat "${PROJECT_DIR}/VERSION")
RELEASE=$(cat "${PROJECT_DIR}/RELEASE")

REPO_URL="https://github.com/GoogleCloudPlatform/terraformer"

echo "==> Preparing Terraformer SRPM for version ${VERSION}-${RELEASE}"

# Change to project directory
cd "${PROJECT_DIR}"

# Download sources if not exists
echo "==> Downloading source tarball..."
if [ ! -f "SOURCES/${VERSION}.tar.gz" ]; then
    curl -L -o "SOURCES/${VERSION}.tar.gz" "${REPO_URL}/archive/refs/tags/${VERSION}.tar.gz"
fi

# Generate changelog entry and add to spec
echo "==> Generating changelog entry..."
CHANGELOG_ENTRY=$("${SCRIPT_DIR}/generate-changelog-entry.sh" "${VERSION}" "${RELEASE}")

# Create temporary spec with changelog
SPEC_FILE="${PROJECT_DIR}/SPECS/terraformer.spec"
TEMP_SPEC="${PROJECT_DIR}/SPECS/terraformer-build.spec"

# Copy spec and add changelog
cp "${SPEC_FILE}" "${TEMP_SPEC}"
echo "${CHANGELOG_ENTRY}" >> "${TEMP_SPEC}"

# Build SRPM
echo "==> Building SRPM..."
rpmbuild -bs \
    --define "_topdir ${PROJECT_DIR}" \
    --define "_sourcedir ${PROJECT_DIR}/SOURCES" \
    --define "_specdir ${PROJECT_DIR}/SPECS" \
    --define "_srcrpmdir ${PROJECT_DIR}" \
    --define "_version ${VERSION}" \
    --define "_release ${RELEASE}" \
    "${TEMP_SPEC}"

# Remove temporary spec
rm -f "${TEMP_SPEC}"

echo "==> SRPM created successfully!"
ls -lh "${PROJECT_DIR}"/*.src.rpm
