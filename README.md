# :rocket: amd64-sys-fetch :zap:

[![task](https://img.shields.io/badge/Task-Enabled-brightgreen?style=for-the-badge&logo=task&logoColor=white)](https://taskfile.dev/#/)

**`amd64-sys-fetch`** is a fast, dependency-free CLI tool designed for headless Linux environments. Bypassing standard libraries entirely, this project interacts directly with the Linux kernel using native system calls to extract and display real-time system metrics. 

By reading directly from virtual files like `/proc/loadavg` and parsing the data in pure [GNU Assembler (GAS)](https://sourceware.org/binutils/docs/as/), this tool provides a hyper-optimized way to monitor server health without the overhead of heavy scripts or subshells.

## :sparkles: Key Features
* **Multi-Architecture Support:** Written strictly in assembly for both `x86_64` (amd64) and `aarch64` (arm64) architectures.
* **Pure Assembly:** Gives absolute control over memory and CPU registers using the GNU Assembler.
* **Zero Dependencies:** Runs natively without the C standard library (libc) or any external package requirements.
* **Direct Kernel I/O:** Utilizes native Linux system calls (via `syscall` on x86_64 and `svc` on aarch64) for all file operations and terminal output.
* **Low Overhead:** Executes instantly, making it a perfectly lightweight monitoring tool for headless servers.

## :package: Installation

This project requires the **GNU Assembler (as)** and standard build tools. 

### amd64 (x86_64)
On Debian/Ubuntu:
```bash
sudo apt update
sudo apt install binutils build-essential
```

### arm64 (aarch64)
For cross-compilation on an amd64 host:
```bash
sudo apt update
sudo apt install binutils-aarch64-linux-gnu build-essential
```

If you have [Task](https://taskfile.dev/) installed, you can also run:
```bash
task deps:amd64  # or task deps:arm64
```

## :hammer_and_wrench: Development

### Using Task (Recommended)

To build and run the tool for your architecture:

```bash
task build-run:amd64
# or
task build-run:arm64
```

### Manual Build

#### amd64 (x86_64)
1. **Assemble:** `as src/x86_64/main.S -o src/x86_64/main.o`
2. **Link:** `ld src/x86_64/main.o -o bin/sys-fetch-amd64`

#### arm64 (aarch64)
1. **Assemble:** `aarch64-linux-gnu-as src/aarch64/main.S -o src/aarch64/main.o`
2. **Link:** `aarch64-linux-gnu-ld src/aarch64/main.o -o bin/sys-fetch-arm64`

### Debugging (amd64)

To build with debug symbols and start a [GDB](https://www.sourceware.org/gdb/) session:

```bash
task dbg:amd64
```

Once inside the GDB session, you can use the following commands to step through the program:

```gdb
(gdb) break _start   # Set a breakpoint at the entry point
(gdb) run            # Start execution
(gdb) stepi          # Step one instruction at a time
(gdb) <enter>        # Repeat the previous command (stepi)
(gdb) info registers # Show all register values
(gdb) print $rax     # Print the value of a specific register (e.g., rax)
(gdb) x/s &filepath  # Examine the filepath as a string
(gdb) x/16xb &filepath # Examine 16 bytes of memory at filepath in hex
(gdb) x/64xb &buffer # Examine 64 bytes of the buffer in hex
(gdb) x/s &buffer    # Examine the buffer as a string
```

### Inspection

To disassemble and inspect the machine code, you can use `objdump`:

```bash
# amd64
task inspect:bin:amd64
# arm64
task inspect:bin:arm64
```

### System Call Tracing

To trace the system calls made by the binary in real-time, use `strace`:

```bash
task strace:amd64
# or (on arm64 host)
task strace:arm64
```

## :books: Learning & Reference

To support the transition from C to assembly, this project includes a reference snippet from the [Rosetta Stone](https://github.com/lowleveltv/rosetta-stone) project.

*   **Reference File:** `ref/rosetta.c` contains common C constructs (loops, function calls, syscalls).
*   **Build Task:** Run `task rosetta-amd64` to compile the reference file and generate an assembly listing (`ref/rosetta-amd64.s`).

## :computer: System Call Reference

### Register Usage

| Role | x86_64 | aarch64 |
| :--- | :--- | :--- |
| **Syscall Number** | `rax` | `x8` |
| **Argument 1** | `rdi` | `x0` |
| **Argument 2** | `rsi` | `x1` |
| **Argument 3** | `rdx` | `x2` |
| **Argument 4** | `r10` | `x3` |
| **Argument 5** | `r8` | `x4` |
| **Argument 6** | `r9` | `x5` |
| **Return Value** | `rax` | `x0` |

### Common Syscalls

| Name | x86_64 (%rax) | aarch64 (%x8) | Description |
| :--- | :--- | :--- | :--- |
| `read` | **0** | **63** | Read data from a file descriptor. |
| `write` | **1** | **64** | Write data to a file descriptor. |
| `open` | **2** | **-** | Open a file (x86_64). |
| `openat` | **257** | **56** | Open a file relative to dir FD (modern standard). |
| `close` | **3** | **57** | Close an open file descriptor. |
| `exit` | **60** | **93** | Terminate the calling process. |

## :file_folder: GAS Section Reference

*   **`.text`**: Contains the actual executable code.
*   **`.data`**: Used for declaring initialized data or constants.
*   **`.bss`**: Used for declaring uninitialized variables (Block Started by Symbol).

## :memo: GAS Data Declaration Directives

| Directive | Purpose | Standard Size |
| :--- | :--- | :--- |
| **`.byte`** | Define Byte | 1 byte |
| **`.short`** | Define Short (Word) | 2 bytes |
| **`.long`** | Define Long (Doubleword) | 4 bytes |
| **`.quad`** | Define Quadword | 8 bytes |
| **`.octa`** | Define Octoword | 16 bytes |

## :balance_scale: License

​[​Apache License 2.0](./LICENSE)

---

## :pencil: Author

This project was started in 2026 by [Nicholas Wilde](https://github.com/nicholaswilde/).
