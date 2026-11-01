#!/usr/bin/env bash

# Debug install script
set -euo pipefail

TEST_HOME=$(mktemp -d)
export HOME="${TEST_HOME}"
export XDG_CONFIG_HOME="${HOME}/.config"

echo "=== DEBUG INSTALL ==="
echo "Test home: ${TEST_HOME}"

cd /home/devops/.data/agent/worktrees/w-2
echo "Running install.sh..."
bash install.sh

echo ""
echo "=== CHECKING RESULTS ==="
echo "Files in HOME:"
ls -la "${HOME}"
echo ""
echo "Files in XDG config:"
ls -la "${XDG_CONFIG_HOME}/git/"
echo ""
echo "Checking git config origin for pull.rebase:"
git config --show-origin --get pull.rebase
echo ""
echo "Checking what .gitconfig points to:"
if [ -L "${HOME}/.gitconfig" ]; then
    echo ".gitconfig is symlink to: $(readlink ${HOME}/.gitconfig)"
fi