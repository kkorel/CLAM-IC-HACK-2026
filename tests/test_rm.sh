#!/bin/bash

echo "test" > /tmp/test_rm_file.txt

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/../clam.sh" > /dev/null 2>&1
clam enable > /dev/null 2>&1

echo "Testing rm command..."
echo "y" | timeout 3 rm /tmp/test_rm_file.txt 2>&1

if [ $? -eq 0 ]; then
    echo "Success: rm executed without hanging"
    exit 0
else
    echo "Failed: rm command timed out or errored"
    exit 1
fi
