#!/bin/bash
set -e

BIN="bin/x86_64/sys-fetch"

echo "Checking if binary exists..."
if [ ! -f "$BIN" ]; then
    echo "Error: Binary $BIN not found."
    exit 1
fi

echo "Binary found. Checking output format..."
OUTPUT=$($BIN)
echo "Output: $OUTPUT"

# Extract load average line and check for three numbers
LOADAVG_LINE=$(echo "$OUTPUT" | grep "Load Average:")

if [[ $LOADAVG_LINE =~ [0-9]+\.[0-9]+.*[0-9]+\.[0-9]+.*[0-9]+\.[0-9]+ ]]; then
    echo "Verification successful: Output contains expected load average values."
else
    echo "Error: Output does not contain three load average values."
    exit 1
fi
