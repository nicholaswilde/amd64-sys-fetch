# Specification: feature_armv7_20260301

## Overview
Add support for the ARMv7 (32-bit) architecture to the `sys-fetch` project. This track targets Raspberry Pi OS (32-bit) with the hard-float (armhf) ABI, ensuring parity with the existing x86_64 and AArch64 implementations.

## Functional Requirements
1.  **Directory Structure:** Create `src/armv7/` for architecture-specific assembly files.
2.  **Build Automation:**
    -   Add `assy:armv7`, `link:armv7`, `build:armv7`, and `run:armv7` tasks to `Taskfile.yml`.
    -   Update the generic `build` and `test` tasks in `Taskfile.yml` to support ARMv7 (`armv7l`).
3.  **Documentation:**
    -   Update `docs/syscalls.md` with the ARMv7 register map and specific system call numbers (e.g., `sys_open` is 5, `sys_read` is 3).
4.  **Verification:**
    -   Implement a dedicated verification script `tests/verify_armv7.sh` to validate the ARMv7 binary's output format.

## Acceptance Criteria
-   `task build` successfully selects and executes the ARMv7 build process on an ARMv7 host.
-   `docs/syscalls.md` includes a clear ARMv7 reference section.
-   `tests/verify_armv7.sh` accurately confirms that the ARMv7 binary output contains the expected load average and hostname information.
-   Build artifacts are properly managed in `bin/armv7/` and `src/armv7/*.o`.

## Out of Scope
-   Support for ARMv7 soft-float (armel) ABI.
-   Cross-compilation setup (unless specifically requested by the user during implementation).
-   Implementation of the actual `.S` assembly code (to be performed by the user).
