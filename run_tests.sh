#!/bin/bash

if ! command -v bats &> /dev/null; then
    echo "bats not found. Installing..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y bats
    elif command -v brew &> /dev/null; then
        brew install bats-core
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y bats
    elif command -v yum &> /dev/null; then
        sudo yum install -y bats
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm bats
    else
        echo "Error: Could not detect package manager. Please install bats manually."
        echo "Visit: https://github.com/bats-core/bats-core"
        exit 1
    fi

    if ! command -v bats &> /dev/null; then
        echo "Error: bats installation failed."
        exit 1
    fi

    echo "bats installed successfully!"
fi

bats tests/

tests/test_final_verification.sh
tests/test_harm_basic.sh
tests/test_harm_detection.sh
tests/test_rm.sh
