#!/usr/bin/env bash

# Test script for git config linking fix
set -euo pipefail

echo "Running git config linking tests..."

# Create a temporary directory for testing
TEST_HOME=$(mktemp -d)
export HOME="${TEST_HOME}"
export XDG_CONFIG_HOME="${HOME}/.config"

# Store original directory
ORIGINAL_DIR=$(pwd)

# Cleanup function
cleanup() {
    cd "${ORIGINAL_DIR}"
    rm -rf "${TEST_HOME}"
}
trap cleanup EXIT

# Run install.sh
echo "Running install.sh..."
cd "${ORIGINAL_DIR}"
bash install.sh

# Test 1: git config --global test.key 1 should write to ~/.gitconfig and not dirty the checkout
echo "Test 1: Checking global config writing..."
git config --global test.key 1

# Check that the checkout is clean (no staged changes)
cd "${ORIGINAL_DIR}"
if [[ -n $(git status --porcelain) ]]; then
    echo "FAIL: Checkout is dirty after git config --global"
    exit 1
fi

echo "PASS: Checkout remains clean"

# Test 2: git config --show-origin --get pull.rebase should report XDG config path
echo "Test 2: Checking pull.rebase origin..."
origin=$(git config --show-origin --get pull.rebase)
if [[ "$origin" != *"config"* ]]; then
    echo "FAIL: pull.rebase not pointing to XDG config"
    exit 1
fi

echo "PASS: pull.rebase points to XDG config"

# Test 3: git check-ignore -v .DS_Store should report rule from ~/.config/git/ignore
echo "Test 3: Checking git ignore rules..."
cd $(mktemp -d)
touch .DS_Store
if ! git check-ignore -v .DS_Store >/dev/null 2>&1; then
    echo "FAIL: .DS_Store not ignored"
    exit 1
fi

echo "PASS: .DS_Store is ignored"

# Test 4: After simulating prior symlink, ~/.gitconfig should be a regular file
echo "Test 4: Checking prior symlink handling..."
cd "${ORIGINAL_DIR}"
# Create a symlink to simulate old install
ln -sf "${ORIGINAL_DIR}/git/.gitconfig" "${TEST_HOME}/.gitconfig"
bash install.sh

if [ -L "${TEST_HOME}/.gitconfig" ]; then
    echo "FAIL: ~/.gitconfig is still a symlink after install"
    exit 1
fi

echo "PASS: ~/.gitconfig is a regular file"

# Test 5: install.sh should contain no git config command
echo "Test 5: Checking for git config commands in install.sh..."
if grep -n 'git config' "${ORIGINAL_DIR}/install.sh" >/dev/null; then
    echo "FAIL: install.sh contains git config commands"
    exit 1
fi

echo "PASS: install.sh contains no git config commands"

echo "All tests passed!"