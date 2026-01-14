#!/bin/bash
# Buduje SRPM dla terraformer
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Odczytaj wersję i release
VERSION=$(cat "${PROJECT_DIR}/VERSION")
RELEASE=$(cat "${PROJECT_DIR}/RELEASE")

REPO_URL="https://github.com/GoogleCloudPlatform/terraformer"

echo "==> Preparing Terraformer SRPM for version ${VERSION}-${RELEASE}"

# Przejdź do katalogu projektu
cd "${PROJECT_DIR}"

# Pobierz źródła jeśli nie istnieją
echo "==> Downloading source tarball..."
if [ ! -f "SOURCES/${VERSION}.tar.gz" ]; then
    curl -L -o "SOURCES/${VERSION}.tar.gz" "${REPO_URL}/archive/refs/tags/${VERSION}.tar.gz"
fi

# Wygeneruj changelog entry i dodaj do spec
echo "==> Generating changelog entry..."
CHANGELOG_ENTRY=$("${SCRIPT_DIR}/generate-changelog-entry.sh" "${VERSION}" "${RELEASE}")

# Stwórz tymczasowy spec z changelog
SPEC_FILE="${PROJECT_DIR}/SPECS/terraformer.spec"
TEMP_SPEC="${PROJECT_DIR}/SPECS/terraformer-build.spec"

# Kopiuj spec i dodaj changelog
cp "${SPEC_FILE}" "${TEMP_SPEC}"
echo "${CHANGELOG_ENTRY}" >> "${TEMP_SPEC}"

# Zbuduj SRPM
echo "==> Building SRPM..."
rpmbuild -bs \
    --define "_topdir ${PROJECT_DIR}" \
    --define "_sourcedir ${PROJECT_DIR}/SOURCES" \
    --define "_specdir ${PROJECT_DIR}/SPECS" \
    --define "_srcrpmdir ${PROJECT_DIR}" \
    --define "_version ${VERSION}" \
    --define "_release ${RELEASE}" \
    "${TEMP_SPEC}"

# Usuń tymczasowy spec
rm -f "${TEMP_SPEC}"

echo "==> SRPM created successfully!"
ls -lh "${PROJECT_DIR}"/*.src.rpm
