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

# --- 2. Ensure Git Configuration for Smooth Updates ---
# This function sets the necessary git config options to prevent
# "divergent branches" and "uncommitted changes" errors.
configure_git() {
    echo "Configuring Git for smooth updates..."

    # Set pull.rebase to true:
    # This prevents merge bubbles and keeps history linear.
    git config pull.rebase true

    # Set rebase.autoStash to true:
    # This automatically stashes uncommitted changes before pulling
    # and pops them afterwards. This fixes the "uncommitted changes" error.
    git config rebase.autoStash true
}

# Run the configuration function
configure_git

# --- 3. Pull latest changes from the Git repo ---
# This is run as the regular user who owns the .git directory.
echo "Pulling latest changes from GitHub..."
git pull

# --- 4. Rebuild the NixOS System ---
# This command requires root, so it uses 'sudo'.
echo "Applying changes and rebuilding the system..."
sudo nixos-rebuild switch

echo "---"
echo "Update complete!"
