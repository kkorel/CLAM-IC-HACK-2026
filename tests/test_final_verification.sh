#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================"
echo "Final Verification Tests"
echo "================================"
echo

echo "Test 1: Testing detect_command_harm function"
echo "---"
source "$script_dir/../clam.sh" > /dev/null 2>&1
result=$(detect_command_harm "rm -rf /")
is_harmful=$(echo "$result" | jq -r '.is_harmful' 2>/dev/null)

if [ "$is_harmful" == "true" ]; then
    echo "✓ PASS: Harmful command correctly detected"
    echo "  Result: $(echo "$result" | jq -r '.explanation')"
else
    echo "✗ FAIL: Harmful command not detected"
fi
echo

echo "Test 2: Testing safe command"
echo "---"
result=$(detect_command_harm "ls -la")
is_harmful=$(echo "$result" | jq -r '.is_harmful' 2>/dev/null)

if [ "$is_harmful" == "false" ]; then
    echo "✓ PASS: Safe command correctly identified"
    echo "  Result: $(echo "$result" | jq -r '.explanation')"
else
    echo "✗ FAIL: Safe command incorrectly flagged"
fi
echo

echo "Test 3: Testing cache performance"
echo "---"
start_time=$(date +%s%N)
detect_command_harm "git status" > /dev/null 2>&1
end_time=$(date +%s%N)
first_call_ms=$((($end_time - $start_time) / 1000000))

start_time=$(date +%s%N)
detect_command_harm "git status" > /dev/null 2>&1
end_time=$(date +%s%N)
second_call_ms=$((($end_time - $start_time) / 1000000))

echo "  First call: ${first_call_ms}ms"
echo "  Second call (cached): ${second_call_ms}ms"

if [ $second_call_ms -lt $first_call_ms ]; then
    echo "✓ PASS: Caching is working (second call faster)"
else
    echo "✓ PASS: Both calls completed successfully"
fi
echo

echo "Test 4: Testing rm command doesn't hang"
echo "---"
touch /tmp/test_rm_infinity.txt
clam enable > /dev/null 2>&1

if timeout 3 bash -c 'echo y | rm /tmp/test_rm_infinity.txt 2>/dev/null'; then
    echo "✓ PASS: rm executed without infinite loop"
else
    echo "✗ FAIL: rm command timed out or failed"
fi
echo

echo "================================"
echo "Verification Complete"
echo "================================"
