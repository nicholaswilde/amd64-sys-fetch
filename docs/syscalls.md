# Linux x86_64 System Calls Reference

This document provides a reference for the Linux system calls (x86_64 architecture) used in the `sys-fetch` project.

## Architecture Register Map (x86_64)

| Register | Role |
| :--- | :--- |
| `RAX` | System call number / Return value |
| `RDI` | 1st argument |
| `RSI` | 2nd argument |
| `RDX` | 3rd argument |
| `R10` | 4th argument |
| `R8` | 5th argument |
| `R9` | 6th argument |

## System Call Opcodes & Arguments

### `sys_read` (0)
Used to read from a file descriptor.
- **Number:** `0`
- **Arguments:**
  - `RDI`: `unsigned int fd` (File descriptor)
  - `RSI`: `char *buf` (Pointer to buffer)
  - `RDX`: `size_t count` (Number of bytes to read)
- **Return Value:** Number of bytes read on success; `-1` on error.

### `sys_write` (1)
Used to write to a file descriptor.
- **Number:** `1`
- **Arguments:**
  - `RDI`: `unsigned int fd` (File descriptor, e.g., `1` for `stdout`)
  - `RSI`: `const char *buf` (Pointer to buffer)
  - `RDX`: `size_t count` (Number of bytes to write)
- **Return Value:** Number of bytes written on success; `-1` on error.

### `sys_open` (2)
Used to open a file.
- **Number:** `2`
- **Arguments:**
  - `RDI`: `const char *filename` (Path to the file)
  - `RSI`: `int flags` (Access mode, e.g., `O_RDONLY = 0`)
  - `RDX`: `umode_t mode` (File permissions if creating)
- **Return Value:** New file descriptor on success; `-1` on error.

### `sys_close` (3)
Used to close a file descriptor.
- **Number:** `3`
- **Arguments:**
  - `RDI`: `unsigned int fd` (File descriptor to close)
- **Return Value:** `0` on success; `-1` on error.

### `sys_exit` (60)
Used to terminate the calling process.
- **Number:** `60`
- **Arguments:**
  - `RDI`: `int error_code` (Exit status code)
- **Return Value:** None (does not return).
