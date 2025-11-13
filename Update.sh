#!/usr/bin/env bash
#
# This script updates the local NixOS configuration from the Git repository
# and then rebuilds the system to apply the changes.
#
# Run this script *without* sudo: bash /etc/nixos/update.sh

set -e

# --- 1. Navigate to the configuration directory ---
echo "Navigating to /etc/nixos..."
cd /etc/nixos

# --- 2. Pull latest changes from the Git repo ---
# This is run as the regular user who owns the .git directory.
echo "Pulling latest changes from GitHub..."
git pull

# --- 3. Rebuild the NixOS System ---
# This command requires root, so it uses 'sudo'.
echo "Applying changes and rebuilding the system..."
sudo nixos-rebuild switch

echo "---"
echo "Update complete!"
