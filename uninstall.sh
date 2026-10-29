#!/usr/bin/env bash
# ==============================================================================
# Uninstaller for ntfs-tool (macOS)
# Author: Atila Sevindi (https://github.com/atilasevindi)
# ==============================================================================

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BOLD}Uninstalling ntfs-tool from your system...${NC}"

# Remove LaunchDaemon if installed
PLIST_PATH="/Library/LaunchDaemons/com.github.ntfs-tool.automount.plist"
if [[ -f "$PLIST_PATH" ]]; then
    echo "Stopping and removing background daemon..."
    sudo launchctl unload "$PLIST_PATH" 2>/dev/null || true
    sudo rm -f "$PLIST_PATH"
fi

# Remove binary
TARGET_BIN="/usr/local/bin/ntfs-tool"
if [[ -f "$TARGET_BIN" ]]; then
    echo "Removing $TARGET_BIN..."
    sudo rm -f "$TARGET_BIN"
fi

ALT_BIN="/opt/homebrew/bin/ntfs-tool"
if [[ -f "$ALT_BIN" ]]; then
    echo "Removing $ALT_BIN..."
    sudo rm -f "$ALT_BIN"
fi

echo -e "${GREEN}✔ ntfs-tool has been completely uninstalled.${NC}"
