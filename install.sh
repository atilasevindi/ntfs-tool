#!/usr/bin/env bash
# ==============================================================================
# Installer for ntfs-tool (macOS)
# Author: Atila Sevindi (https://github.com/atilasevindi)
# ==============================================================================

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BOLD}${CYAN}Installing ntfs-tool for macOS...${NC}"

# Verify macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}Error: ntfs-tool is designed specifically for macOS.${NC}"
    exit 1
fi

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
BIN_SOURCE="$SOURCE_DIR/bin/ntfs-tool"

# Target installation directory
TARGET_DIR="/usr/local/bin"
if [[ ! -d "$TARGET_DIR" ]]; then
    sudo mkdir -p "$TARGET_DIR"
fi

TARGET_BIN="$TARGET_DIR/ntfs-tool"

echo -e "Copying binary to ${BOLD}$TARGET_BIN${NC}..."
sudo cp "$BIN_SOURCE" "$TARGET_BIN"
sudo chmod +x "$TARGET_BIN"

echo -e "${GREEN}✔ ntfs-tool successfully installed to $TARGET_BIN!${NC}\n"

# Run doctor check
echo -e "${BOLD}Running environment doctor check:${NC}"
"$TARGET_BIN" doctor || true

echo -e "\n${BOLD}Quick Start Guide:${NC}"
echo -e "  List drives:      ${CYAN}ntfs-tool list${NC}"
echo -e "  Mount Read/Write: ${CYAN}sudo ntfs-tool mount${NC}"
echo -e "  Interactive TUI:  ${CYAN}sudo ntfs-tool${NC}"
echo -e "  Auto-mount loop:  ${CYAN}sudo ntfs-tool watch${NC}\n"
