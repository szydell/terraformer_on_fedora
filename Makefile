.PHONY: all clean srpm test check-version help

VERSION := $(shell cat VERSION)
RELEASE := $(shell cat RELEASE)

all: srpm

install-deps:
	@echo "Installing build dependencies..."
	sudo dnf install -y rpm-build rpmdevtools golang git curl jq

srpm: clean
	@echo "Building SRPM for terraformer $(VERSION)-$(RELEASE)..."
	chmod +x scripts/*.sh
	./scripts/prepare-srpm.sh

check-version:
	@echo "Checking for new upstream version..."
	@LATEST=$$(./scripts/get-latest-version.sh); \
	CURRENT=$$(cat VERSION); \
	echo "Upstream: $$LATEST"; \
	echo "Current:  $$CURRENT"; \
	if [ "$$LATEST" != "$$CURRENT" ]; then \
		echo "New version available!"; \
	else \
		echo "Up to date."; \
	fi

update-version:
	@echo "Updating to latest upstream version..."
	@LATEST=$$(./scripts/get-latest-version.sh); \
	echo "$$LATEST" > VERSION; \
	echo "1" > RELEASE; \
	echo "Updated to $$LATEST-1"

bump-release:
	@echo "Bumping release number..."
	@CURRENT=$$(cat RELEASE); \
	NEW=$$((CURRENT + 1)); \
	echo "$$NEW" > RELEASE; \
	echo "Release bumped to $$NEW"

clean:
	@echo "Cleaning build artifacts..."
	rm -rf *.src.rpm BUILD BUILDROOT RPMS SRPMS
	rm -f SOURCES/*.tar.gz
	rm -f SPECS/terraformer-build.spec

help:
	@echo "Terraformer COPR Build System"
	@echo ""
	@echo "Current: terraformer-$(VERSION)-$(RELEASE)"
	@echo ""
	@echo "Usage:"
	@echo "  make install-deps   - Install required build tools"
	@echo "  make srpm           - Build SRPM package"
	@echo "  make check-version  - Check for new upstream version"
	@echo "  make update-version - Update VERSION to latest upstream"
	@echo "  make bump-release   - Increment RELEASE number"
	@echo "  make clean          - Clean build artifacts"
	@echo ""
	@echo "GitHub Actions handles automatic builds."
	@echo "Configure secrets in repository settings:"
	@echo "  - COPR_API_TOKEN: Your COPR API token"
	@echo ""
	@echo "Configure variables:"
	@echo "  - COPR_USER: Your COPR username"
	@echo "  - COPR_PROJECT: COPR project name (default: terraformer)"
