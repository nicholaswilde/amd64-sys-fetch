# Implementation Plan: loadavg_init_20260225

## Phase 1: Build & Documentation Scaffolding [checkpoint: e622eae]
- [x] Task: Create `docs/syscalls.md` with detailed register maps and opcodes for project system calls. [1e1ccbb]
    - [x] Research and document `sys_open` (2).
    - [x] Research and document `sys_read` (0).
    - [x] Research and document `sys_write` (1).
    - [x] Research and document `sys_close` (3).
    - [x] Research and document `sys_exit` (60).
- [x] Task: Enhance `Taskfile.yml` with a `build` task that chains `assy` and `link`. [92b8554]
    - [x] Add `build` task.
    - [x] Add `clean` task to remove object files and binary.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Build & Documentation Scaffolding' (Protocol in workflow.md) [e622eae]

## Phase 2: Automated Verification [checkpoint: 61f46e4]
- [x] Task: Implement a shell-based verification script `tests/verify_loadavg.sh`. [132228b]
    - [x] Check if `bin/sys-fetch` exists.
    - [x] Check if output of `bin/sys-fetch` matches expected format (contains three space-separated numbers).
- [x] Task: Add a `test` task to `Taskfile.yml` that invokes the verification script. [92b8554]
- [x] Task: Conductor - User Manual Verification 'Phase 2: Automated Verification' (Protocol in workflow.md) [61f46e4]