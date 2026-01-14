# Terraformer RPM for Fedora

Automated RPM packaging for [Terraformer](https://github.com/GoogleCloudPlatform/terraformer) - CLI tool to generate Terraform files from existing infrastructure.

**COPR:** https://copr.fedorainfracloud.org/coprs/szydell/terraformer/

## 🚀 Features

- **Automatic version detection** - checks for new upstream releases every 6 hours
- **Automatic builds** - triggers COPR build when new version is detected
- **Multi-arch support** - builds for x86_64 and aarch64 (configure in COPR)
- **Release notes** - automatically includes upstream release notes in changelog

## 📦 Installation (for users)

```bash
# Enable the repository
sudo dnf copr enable szydell/terraformer

# Install terraformer
sudo dnf install terraformer

# Verify installation
terraformer --version
```

## ⚙️ Setup (for maintainers)

### 1. Create COPR Project

1. Go to https://copr.fedorainfracloud.org
2. Create new project named `terraformer`
3. Enable desired chroots (Fedora versions, architectures)
4. Enable email notifications in project settings

### 2. Get COPR API Token

1. Go to https://copr.fedorainfracloud.org/api/
2. Copy your API token

### 3. Configure GitHub Repository

Add the following in repository **Settings → Secrets and variables → Actions**:

#### Secrets
| Name | Value |
|------|-------|
| `COPR_API_TOKEN` | Your COPR API token |

#### Variables
| Name | Value |
|------|-------|
| `COPR_USER` | Your COPR username |
| `COPR_PROJECT` | `terraformer` |

### 4. Enable GitHub Actions

The workflows will automatically:
- Check for new releases every 6 hours
- Build and publish to COPR when new version is detected

## 🔧 Manual Operations

### Trigger manual build

Go to **Actions → Build and Publish to COPR → Run workflow**

Options:
- Leave version empty to use current VERSION file
- Specify version to build specific release
- Check "Force rebuild" to rebuild same version

### Check for new version manually

Go to **Actions → Check for New Release → Run workflow**

### Local development

```bash
# Install dependencies
make install-deps

# Check for new upstream version
make check-version

# Update to latest version
make update-version

# Build SRPM locally
make srpm

# Clean build artifacts
make clean
```

## 📁 Project Structure

```
terraformer_on_fedora/
├── .github/
│   └── workflows/
│       ├── check-new-release.yml   # Cron: checks every 6h
│       └── build-and-publish.yml   # Builds SRPM, uploads to COPR
├── SPECS/
│   └── terraformer.spec            # RPM spec file
├── SOURCES/                        # Downloaded source tarballs
├── scripts/
│   ├── get-latest-version.sh       # Fetches latest release from GitHub
│   ├── generate-changelog-entry.sh # Generates RPM changelog
│   └── prepare-srpm.sh             # Builds SRPM locally
├── VERSION                         # Current upstream version
├── RELEASE                         # Current release number
├── Makefile                        # Local development commands
└── README.md
```

## 📋 Version Scheme

Package version follows the pattern: `{upstream_version}-{release_number}`

- New upstream release: `0.8.31-1`
- Rebuild of same version: `0.8.31-2`, `0.8.31-3`, etc.

## 🔗 Links

- **Upstream:** https://github.com/GoogleCloudPlatform/terraformer
- **COPR:** https://copr.fedorainfracloud.org/coprs/szydell/terraformer/

## 📄 License

This packaging is provided under MIT license.
Terraformer itself is licensed under Apache-2.0.
