#!/bin/bash

# Test script to validate tmux configuration
# This script checks that:
# 1. default-terminal is not set to xterm* value
# 2. Tc terminfo override is present

echo "Testing tmux configuration..."

# Check that no line contains default-terminal with xterm value
if grep -q 'default-terminal.*xterm' tmux/.tmux.conf; then
    echo "FAIL: Found default-terminal line with xterm value"
    exit 1
else
    echo "PASS: No default-terminal line with xterm value found"
fi

# Check that Tc terminfo override is present
if grep -q 'Tc' tmux/.tmux.conf; then
    echo "PASS: Tc terminfo override found"
else
    echo "FAIL: Tc terminfo override not found"
    exit 1
fi

echo "All tests passed!"
exit 0