#!/usr/bin/env bash

# Simple validation test
set -euo pipefail

echo "=== Simple Git Config Test ==="

# Create temp home
TEST_HOME=$(mktemp -d)
export HOME="${TEST_HOME}"
export XDG_CONFIG_HOME="${HOME}/.config"

cd /home/devops/.data/agent/worktrees/w-2

# Run install
echo "Running install.sh..."
bash install.sh

# Check that the git config is now properly linked
echo "Checking .gitconfig file:"
if [ -f "${HOME}/.gitconfig" ]; then
    echo ".gitconfig exists as regular file"
else
    echo ".gitconfig does not exist as regular file"
fi

echo "Checking XDG config path:"
ls -la "${XDG_CONFIG_HOME}/git/"

# Test that global config writes don't affect the repo
echo "Setting global config..."
git config --global test.key 1

# Check if we can run git status without dirtying the repo
cd /home/devops/.data/agent/worktrees/w-2
if [[ -n $(git status --porcelain) ]]; then
    echo "ERROR: Checkout is dirty"
    exit 1
else
    echo "SUCCESS: Checkout remains clean"
fi

echo "=== Test completed ==="