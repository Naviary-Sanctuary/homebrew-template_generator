#!/bin/bash

# Template Generator - SHA256 Hash Calculator
# Usage: ./sha.sh <version>
# Example: ./sha.sh v0.1.0

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
REPO_OWNER="Naviary-Sanctuary"
REPO_NAME="template_generator"
VERSION="${1}"

# Function to print colored messages
info() {
    echo -e "${GREEN}✓${NC} $1"
}

warn() {
    echo -e "${YELLOW}!${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
    exit 1
}

# Check if version is provided
if [ -z "$VERSION" ]; then
    error "Version is required!\nUsage: $0 <version>\nExample: $0 v0.1.0"
fi

# Ensure version starts with 'v'
if [[ ! "$VERSION" =~ ^v ]]; then
    VERSION="v${VERSION}"
fi

# Construct URL
URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/tags/${VERSION}.tar.gz"

echo "=================================================="
echo "  Template Generator - SHA256 Hash Calculator"
echo "=================================================="
echo ""
info "Repository: ${REPO_OWNER}/${REPO_NAME}"
info "Version: ${VERSION}"
info "URL: ${URL}"
echo ""

# Calculate SHA256 without downloading
info "Fetching and calculating SHA256 hash..."
echo "  (This may take a moment, streaming from GitHub)"
echo ""

if command -v shasum &> /dev/null; then
    HASH=$(curl -sL -f "${URL}" | shasum -a 256 | awk '{print $1}')
elif command -v sha256sum &> /dev/null; then
    HASH=$(curl -sL -f "${URL}" | sha256sum | awk '{print $1}')
else
    error "Neither 'shasum' nor 'sha256sum' found on this system"
fi

# Check if download was successful
if [ -z "$HASH" ] || [ "$HASH" == "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]; then
    error "Failed to calculate hash\nPlease check if the version tag exists on GitHub: ${URL}"
fi

info "Hash calculated successfully (no file saved)"

echo ""
echo "=================================================="
info "SHA256 Hash:"
echo "  ${HASH}"
echo "=================================================="
echo ""

# Generate Formula snippet
info "Formula snippet for homebrew-tg/Formula/tg.rb:"
echo ""
cat << EOF
  url "https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/tags/${VERSION}.tar.gz"
  sha256 "${HASH}"
EOF

echo ""
info "Done!"