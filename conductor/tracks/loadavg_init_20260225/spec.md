# Specification: loadavg_init_20260225

## Problem Statement
The project `sys-fetch` lacks a formal build and verification system, and the documentation for the system calls used in `src/x86_64/main.S` is not centralized for quick reference during learning.

## Goals
1.  **Build Automation:** Simplify the multi-step `assy` and `link` process into a single `build` command.
2.  **Centralized References:** Document the x86_64 Linux system calls used in the project to support the human developer's learning.
3.  **Automated Verification:** Create a non-interactive script to verify the correctness of the build and basic functionality of the binary.

## Requirements
- No modification of `.S` files by the AI agent.
- `Taskfile.yml` must support `build`, `test`, and `clean` tasks.
- Documentation must include register maps and opcodes for `sys_open`, `sys_read`, `sys_write`, `sys_close`, and `sys_exit`.

## Constraints
- Must remain dependency-free (no libc).
- Target platform: Linux x86_64.