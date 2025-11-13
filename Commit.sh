#!/usr/bin/env bash
#
# This script is for the REPOSITORY MAINTAINER to easily commit and
# push updates to the shared configuration.
#
# Run this script *without* sudo: bash /etc/nixos/commit.sh

set -e

# --- 1. Navigate to the configuration directory ---
echo "Navigating to /etc/nixos..."
cd /etc/nixos

# --- 2. Get Commit Message ---
echo "---"
read -p "Enter your commit message: " COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
    echo "Commit message cannot be empty. Aborting."
    exit 1
fi

# --- 3. Add, Commit, and Push ---
# This runs as the regular user who owns the .git directory.
# The .gitignore file will automatically exclude all private files.
echo "Adding all tracked changes..."
git add .

echo "Committing changes..."
git commit -m "$COMMIT_MSG"

echo "Pushing changes to GitHub..."
git push origin main

echo "---"
echo "Update pushed successfully!"
