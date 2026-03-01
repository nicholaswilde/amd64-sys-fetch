#!/bin/bash
set -e

BIN="bin/armv7/sys-fetch"

echo "Checking if ARMv7 binary exists..."
if [ ! -f "$BIN" ]; then
    echo "Error: Binary $BIN not found."
    exit 1
fi

echo "Binary found. Checking output format..."
# If on x86_64, use qemu-arm
if [ "$(uname -m)" != "armv7l" ]; then
    if command -v qemu-arm > /dev/null; then
        RUNNER="qemu-arm"
    else
        echo "Error: Not on ARMv7 and qemu-arm not found. Cannot run verification."
        exit 1
    fi
else
    RUNNER=""
fi

OUTPUT=$( $BIN)
echo "Output: $OUTPUT"

# Extract load average line and check for three numbers
LOADAVG_LINE=$(echo "$OUTPUT" | grep "Load Average:")

if [[ $LOADAVG_LINE =~ [0-9]+\.[0-9]+.*[0-9]+\.[0-9]+.*[0-9]+\.[0-9]+ ]]; then
    echo "Verification successful: Output contains expected load average values."
else
    echo "Error: Output does not contain three load average values."
    exit 1
fi
