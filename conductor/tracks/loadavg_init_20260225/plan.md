# Implementation Plan: loadavg_init_20260225

## Phase 1: Build & Documentation Scaffolding
- [x] Task: Create `docs/syscalls.md` with detailed register maps and opcodes for project system calls. [1e1ccbb]
    - [x] Research and document `sys_open` (2).
    - [x] Research and document `sys_read` (0).
    - [x] Research and document `sys_write` (1).
    - [x] Research and document `sys_close` (3).
    - [x] Research and document `sys_exit` (60).
- [x] Task: Enhance `Taskfile.yml` with a `build` task that chains `assy` and `link`. [92b8554]
    - [x] Add `build` task.
    - [x] Add `clean` task to remove object files and binary.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Build & Documentation Scaffolding' (Protocol in workflow.md)

## Phase 2: Automated Verification
- [ ] Task: Implement a shell-based verification script `tests/verify_loadavg.sh`.
    - [ ] Check if `bin/sys-fetch` exists.
    - [ ] Check if output of `bin/sys-fetch` matches expected format (contains three space-separated numbers).
- [ ] Task: Add a `test` task to `Taskfile.yml` that invokes the verification script.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Automated Verification' (Protocol in workflow.md)