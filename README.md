# :rocket: amd64-sys-fetch

**`amd64-sys-fetch`** is a fast, dependency-free CLI tool designed for headless Linux environments. Bypassing standard libraries entirely, this project interacts directly with the Linux kernel using x86_64 system calls to extract and display real-time system metrics. 

By reading directly from virtual files like `/proc/loadavg` and parsing the data in pure NASM assembly, this tool provides a hyper-optimized way to monitor server health without the overhead of heavy scripts or subshells.

## :sparkles: Key Features
* **Pure Assembly:** Written strictly in x86_64 assembly using NASM, giving absolute control over memory and 64-bit CPU registers.
* **Zero Dependencies:** Runs natively without the C standard library (libc) or any external package requirements.
* **Direct Kernel I/O:** Utilizes native Linux system calls (via the `syscall` instruction) for all file operations and terminal output.
* **Low Overhead:** Executes instantly, making it a perfectly lightweight monitoring tool for Debian servers.

## :books: Learning & Reference

To support the transition from C to x86_64 assembly, this project includes a reference snippet from the [Rosetta Stone](https://github.com/lowleveltv/rosetta-stone) project.

*   **Reference File:** `ref/rosetta.c` contains common C constructs (loops, function calls, syscalls).
*   **Build Task:** Run `task rosetta-amd64` to compile the reference file and generate an assembly listing (`ref/rosetta-amd64.s`).

Use these artifacts to compare high-level C logic with its low-level assembly implementation on the x86_64 architecture.

## :computer: x86_64 System Call Reference

For Linux on **x86_64**, system calls are invoked using the `syscall` instruction.

### :clipboard: Register Usage
| Role | Register |
| :--- | :--- |
| **Syscall Number** | `rax` |
| **Argument 1** | `rdi` |
| **Argument 2** | `rsi` |
| **Argument 3** | `rdx` |
| **Argument 4** | `r10` |
| **Argument 5** | `r8` |
| **Argument 6** | `r9` |
| **Return Value** | `rax` |

> **Note:** The `syscall` instruction clobbers `rcx` and `r11`.

### :hammer_and_wrench: Common Syscalls
| %rax | Name | %rdi | %rsi | %rdx | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **0** | `read` | `unsigned int fd` | `char *buf` | `size_t count` | Read data from a file descriptor into a buffer. |
| **1** | `write` | `unsigned int fd` | `const char *buf` | `size_t count` | Write data from a buffer to a file descriptor. |
| **2** | `open` | `const char *filename` | `int flags` | `umode_t mode` | Open a file and return a file descriptor. |
| **3** | `close` | `unsigned int fd` | - | - | Close an open file descriptor. |
| **60** | `exit` | `int error_code` | - | - | Terminate the calling process. |

### :mag: Other Available Syscalls (Uncommon)

For a complete, searchable, and up-to-date list with full argument details, refer to the [Online x86_64 Syscall Table](https://filippo.io/linux-syscall-table-x86_64/).

<details>
<summary>Click to expand all other available x86_64 system calls</summary>

| %rax | Name | Description |
| :--- | :--- | :--- |
| **4** | `stat` | Get file status (by filename). |
| **5** | `fstat` | Get file status (by file descriptor). |
| **6** | `lstat` | Get file status (for symlinks). |
| **7** | `poll` | Wait for some event on a file descriptor. |
| **8** | `lseek` | Reposition read/write file offset. |
| **9** | `mmap` | Map files or devices into memory. |
| **10** | `mprotect` | Set protection on a region of memory. |
| **11** | `munmap` | Unmap a previously mapped memory region. |
| **12** | `brk` | Change the amount of space allocated for the data segment. |
| **13** | `rt_sigaction` | Examine and change a signal action. |
| **14** | `rt_sigprocmask` | Examine and change blocked signals. |
| **15** | `rt_sigreturn` | Return from signal handler and cleanup stack frame. |
| **16** | `ioctl` | Control device-specific parameters. |
| **17** | `pread64` | Read from a file descriptor at a given offset. |
| **18** | `pwrite64` | Write to a file descriptor at a given offset. |
| **19** | `readv` | Read data into multiple buffers. |
| **20** | `writev` | Write data from multiple buffers. |
| **21** | `access` | Check user's permissions for a file. |
| **22** | `pipe` | Create a pipe for inter-process communication. |
| **23** | `select` | Synchronous I/O multiplexing. |
| **24** | `sched_yield` | Yield the processor. |
| **25** | `mremap` | Remap a virtual memory address. |
| **26** | `msync` | Synchronize a file with a memory map. |
| **27** | `mincore` | Determine whether pages are resident in memory. |
| **28** | `madvise` | Give advice about use of memory. |
| **29** | `shmget` | Allocate a shared memory segment. |
| **30** | `shmat` | Attach a shared memory segment. |
| **31** | `shmctl` | Shared memory control. |
| **32** | `dup` | Duplicate a file descriptor. |
| **33** | `dup2` | Duplicate a file descriptor to a specified number. |
| **34** | `pause` | Wait for a signal. |
| **35** | `nanosleep` | High-resolution sleep. |
| **36** | `getitimer` | Get value of an interval timer. |
| **37** | `alarm` | Set an alarm clock for delivery of a signal. |
| **38** | `setitimer` | Set value of an interval timer. |
| **39** | `getpid` | Get process identification. |
| **40** | `sendfile` | Transfer data between file descriptors. |
| **41** | `socket` | Create an endpoint for communication. |
| **42** | `connect` | Initiate a connection on a socket. |
| **43** | `accept` | Accept a connection on a socket. |
| **44** | `sendto` | Send a message on a socket. |
| **45** | `recvfrom` | Receive a message from a socket. |
| **46** | `sendmsg` | Send a message on a socket. |
| **47** | `recvmsg` | Receive a message from a socket. |
| **48** | `shutdown` | Shut down part of a full-duplex connection. |
| **49** | `bind` | Bind a name to a socket. |
| **50** | `listen` | Listen for connections on a socket. |
| **51** | `getsockname` | Get socket name. |
| **52** | `getpeername` | Get name of connected peer. |
| **53** | `socketpair` | Create a pair of connected sockets. |
| **54** | `setsockopt` | Set options on sockets. |
| **55** | `getsockopt` | Get options on sockets. |
| **56** | `clone` | Create a child process. |
| **57** | `fork` | Create a child process (legacy). |
| **58** | `vfork` | Create a child process and block parent. |
| **59** | `execve` | Execute program. |
| **61** | `wait4` | Wait for process to change state. |
| **62** | `kill` | Send signal to a process. |
| **63** | `uname` | Get name and information about current kernel. |
| **64** | `semget` | Get a System V semaphore set identifier. |
| **65** | `semop` | Semaphore operations. |
| **66** | `semctl` | Semaphore control operations. |
| **67** | `shmdt` | Detach shared memory segment. |
| **68** | `msgget` | Get a System V message queue identifier. |
| **69** | `msgsnd` | Send message to a System V message queue. |
| **70** | `msgrcv` | Receive message from a System V message queue. |
| **71** | `msgctl` | System V message control operations. |
| **72** | `fcntl` | Manipulate file descriptor. |
| **73** | `flock` | Apply or remove an advisory lock on an open file. |
| **74** | `fsync` | Synchronize a file's in-core state with storage. |
| **75** | `fdatasync` | Synchronize a file's in-core data state with storage. |
| **76** | `truncate` | Truncate a file to a specified length. |
| **77** | `ftruncate` | Truncate a file to a specified length. |
| **78** | `getdents` | Get directory entries. |
| **79** | `getcwd` | Get current working directory. |
| **80** | `chdir` | Change working directory. |
| **81** | `fchdir` | Change working directory (by file descriptor). |
| **82** | `rename` | Change the name or location of a file. |
| **83** | `mkdir` | Create a directory. |
| **84** | `rmdir` | Remove a directory. |
| **85** | `creat` | Create a file. |
| **86** | `link` | Create a hard link to a file. |
| **87** | `unlink` | Remove a name and possibly the file it refers to. |
| **88** | `symlink` | Make a new name for a file. |
| **89** | `readlink` | Read value of a symbolic link. |
| **90** | `chmod` | Change permissions of a file. |
| **91** | `fchmod` | Change permissions of an open file. |
| **92** | `chown` | Change ownership of a file. |
| **93** | `fchown` | Change ownership of an open file. |
| **94** | `lchown` | Change ownership of a file (no symlink follow). |
| **95** | `umask` | Set file mode creation mask. |
| **96** | `gettimeofday` | Get current time and time zone. |
| **97** | `getrlimit` | Get resource limits. |
| **98** | `getrusage` | Get resource usage statistics. |
| **99** | `sysinfo` | Get system-wide information and statistics. |
| **100** | `times` | Get process execution times. |
| **101** | `ptrace` | Process trace and debugging control. |
| **102** | `getuid` | Get real user identity. |
| **103** | `syslog` | Control kernel message ring buffer. |
| **104** | `getgid` | Get real group identity. |
| **105** | `setuid` | Set user identity. |
| **106** | `setgid` | Set group identity. |
| **107** | `geteuid` | Get effective user identity. |
| **108** | `getegid` | Get effective group identity. |
| **109** | `setpgid` | Set process group ID. |
| **110** | `getppid` | Get parent process ID. |
| **111** | `getpgrp` | Get process group ID (of current process). |
| **112** | `setsid` | Create session and set process group ID. |
| **113** | `setreuid` | Set real and/or effective user identity. |
| **114** | `setregid` | Set real and/or effective group identity. |
| **115** | `getgroups` | Get supplementary group IDs. |
| **116** | `setgroups` | Set supplementary group IDs. |
| **117** | `setresuid` | Set real, effective, and saved user IDs. |
| **118** | `getresuid` | Get real, effective, and saved user IDs. |
| **119** | `setresgid` | Set real, effective, and saved group IDs. |
| **120** | `getresgid` | Get real, effective, and saved group IDs. |
| **121** | `getpgid` | Get process group ID of a process. |
| **122** | `setfsuid` | Set user ID for file system checks. |
| **123** | `setfsgid` | Set group ID for file system checks. |
| **124** | `getsid` | Get session ID of a process. |
| **125** | `capget` | Get capabilities of thread(s). |
| **126** | `capset` | Set capabilities of thread(s). |
| **127** | `rt_sigpending` | Examine pending signals. |
| **128** | `rt_sigtimedwait` | Synchronously wait for queued signals. |
| **129** | `rt_sigqueueinfo` | Queue a signal and data. |
| **130** | `rt_sigsuspend` | Wait for a signal. |
| **131** | `sigaltstack` | Set and/or get signal stack context. |
| **132** | `utime` | Change access/modification times of an inode. |
| **133** | `mknod` | Create a special or ordinary file. |
| **134** | `uselib` | Select shared library (obsolete). |
| **135** | `personality` | Set the process execution domain. |
| **136** | `ustat` | Get file system statistics (obsolete). |
| **137** | `statfs` | Get file system statistics. |
| **138** | `fstatfs` | Get file system statistics (by file descriptor). |
| **139** | `sysfs` | Get file system type information. |
| **140** | `getpriority` | Get program scheduling priority. |
| **141** | `setpriority` | Set program scheduling priority. |
| **142** | `sched_setparam` | Set scheduling parameters. |
| **143** | `sched_getparam` | Get scheduling parameters. |
| **144** | `sched_setscheduler` | Set scheduling policy/parameters. |
| **145** | `sched_getscheduler` | Get scheduling policy/parameters. |
| **146** | `sched_get_priority_max` | Get max priority for a policy. |
| **147** | `sched_get_priority_min` | Get min priority for a policy. |
| **148** | `sched_rr_get_interval` | Get round-robin time quantum. |
| **149** | `mlock` | Lock a range of memory (prevent swap). |
| **150** | `munlock` | Unlock a range of memory. |
| **151** | `mlockall` | Lock all address space (prevent swap). |
| **152** | `munlockall` | Unlock all address space. |
| **153** | `vhangup` | Virtually hang up current terminal. |
| **154** | `modify_ldt` | Modify the local descriptor table. |
| **155** | `pivot_root` | Change the root filesystem. |
| **156** | `_sysctl` | Read/write system parameters (obsolete). |
| **157** | `prctl` | Process control operations. |
| **158** | `arch_prctl` | Set arch-specific thread state. |
| **159** | `adjtimex` | Adjust the kernel clock. |
| **160** | `setrlimit` | Set resource limits. |
| **161** | `chroot` | Change root directory. |
| **162** | `sync` | Commit filesystem buffers to disk. |
| **163** | `acct` | Switch process accounting on/off. |
| **164** | `settimeofday` | Set current time and time zone. |
| **165** | `mount` | Mount a filesystem. |
| **166** | `umount2` | Unmount a filesystem (with flags). |
| **167** | `swapon` | Start swapping to a file/device. |
| **168** | `swapoff` | Stop swapping to a file/device. |
| **169** | `reboot` | Reboot or enable/disable Ctrl-Alt-Del. |
| **170** | `sethostname` | Set hostname. |
| **171** | `setdomainname` | Set NIS domain name. |
| **172** | `iopl` | Change I/O privilege level. |
| **173** | `ioperm` | Set I/O port permissions. |
| **174** | `create_module` | Create loadable module entry (obsolete). |
| **175** | `init_module` | Load a kernel module. |
| **176** | `delete_module` | Unload a kernel module. |
| **177** | `get_kernel_syms` | Get kernel symbols (obsolete). |
| **178** | `query_module` | Query kernel module (obsolete). |
| **179** | `quotactl` | Manipulate disk quotas. |
| **180** | `nfsservctl` | Interface for NFS server (obsolete). |
| **181** | `getpmsg` | Get message from stream (obsolete). |
| **182** | `putpmsg` | Put message into stream (obsolete). |
| **183** | `afs_syscall` | AFS system call (not implemented). |
| **184** | `tuxcall` | TUX system call (not implemented). |
| **185** | `security` | Security system call (not implemented). |
| **186** | `gettid` | Get the current thread ID. |
| **187** | `readahead` | Initiate file readahead into page cache. |
| **188** | `setxattr` | Set an extended attribute. |
| **189** | `lsetxattr` | Set extended attribute (no symlink follow). |
| **190** | `fsetxattr` | Set extended attribute of an open file. |
| **191** | `getxattr` | Get an extended attribute. |
| **192** | `lgetxattr` | Get extended attribute (no symlink follow). |
| **193** | `fgetxattr` | Get extended attribute of an open file. |
| **194** | `listxattr` | List extended attributes. |
| **195** | `llistxattr` | List extended attributes (no symlink follow). |
| **196** | `flistxattr` | List extended attributes of an open file. |
| **197** | `removexattr` | Remove an extended attribute. |
| **198** | `lremovexattr` | Remove extended attribute (no symlink follow). |
| **199** | `fremovexattr` | Remove extended attribute of an open file. |
| **200** | `tkill` | Send a signal to a specific thread. |
| **201** | `time` | Get current time in seconds. |
| **202** | `futex` | Fast user-space locking. |
| **203** | `sched_setaffinity` | Set CPU affinity mask for a process. |
| **204** | `sched_getaffinity` | Get CPU affinity mask for a process. |
| **205** | `set_thread_area` | Set thread-local storage (TLS) area. |
| **206** | `io_setup` | Initialize asynchronous I/O context. |
| **207** | `io_destroy` | Destroy asynchronous I/O context. |
| **208** | `io_getevents` | Read AIO events from completion queue. |
| **209** | `io_submit` | Submit asynchronous I/O blocks. |
| **210** | `io_cancel` | Cancel an outstanding AIO operation. |
| **211** | `get_thread_area` | Get thread-local storage (TLS) area. |
| **212** | `lookup_dcookie` | Return path of a directory entry (obsolete). |
| **213** | `epoll_create` | Create an epoll file descriptor. |
| **214** | `epoll_ctl_old` | Control epoll descriptor (obsolete). |
| **215** | `epoll_wait_old` | Wait for I/O events (obsolete). |
| **216** | `remap_file_pages` | Create non-linear file mapping. |
| **217** | `getdents64` | Get directory entries (64-bit). |
| **218** | `set_tid_address` | Set pointer to thread ID. |
| **219** | `restart_syscall` | Restart a syscall after interruption. |
| **220** | `semtimedop` | Semaphore operations with timeout. |
| **221** | `fadvise64` | Declare access pattern for file data. |
| **222** | `timer_create` | Create a per-process POSIX timer. |
| **223** | `timer_settime` | Set expiration time for a POSIX timer. |
| **224** | `timer_gettime` | Get remaining time for a POSIX timer. |
| **225** | `timer_getoverrun` | Get overrun count for a POSIX timer. |
| **226** | `timer_delete` | Delete a POSIX per-process timer. |
| **227** | `clock_settime` | Set the current time of a clock. |
| **228** | `clock_gettime` | Get the current time of a clock. |
| **229** | `clock_getres` | Get the resolution of a clock. |
| **230** | `clock_nanosleep` | High-resolution sleep on a specific clock. |
| **231** | `exit_group` | Exit all threads in a process. |
| **232** | `epoll_wait` | Wait for events on epoll descriptor. |
| **233** | `epoll_ctl` | Control interface for epoll descriptor. |
| **234** | `tgkill` | Send signal to thread in thread group. |
| **235** | `utimes` | Change file access/modification times. |
| **236** | `vserver` | Not implemented (legacy). |
| **237** | `mbind` | Set memory policy for memory range. |
| **238** | `set_mempolicy` | Set default memory policy for process. |
| **239** | `get_mempolicy` | Get memory policy for a process. |
| **240** | `mq_open` | Open a message queue. |
| **241** | `mq_unlink` | Remove a message queue. |
| **242** | `mq_timedsend` | Send message to queue with timeout. |
| **243** | `mq_timedreceive` | Receive message from queue with timeout. |
| **244** | `mq_notify` | Register notification of message arrival. |
| **245** | `mq_getsetattr` | Get/set message queue attributes. |
| **246** | `kexec_load` | Load a new kernel for later execution. |
| **247** | `waitid` | Wait for process to change state. |
| **248** | `add_key` | Add key to kernel management facility. |
| **249** | `request_key` | Request a key from the kernel. |
| **250** | `keyctl` | Control/manipulate keys. |
| **251** | `ioprio_set` | Set I/O scheduling priority of process. |
| **252** | `ioprio_get` | Get I/O scheduling priority of process. |
| **253** | `inotify_init` | Initialize an inotify instance. |
| **254** | `inotify_add_watch` | Add watch to initialized inotify. |
| **255** | `inotify_rm_watch` | Remove watch from inotify instance. |
| **256** | `migrate_pages` | Move process pages to other nodes. |
| **257** | `openat` | Open file relative to dir file descriptor. |
| **258** | `mkdirat` | Create dir relative to dir file descriptor. |
| **259** | `mknodat` | Create node relative to dir file descriptor. |
| **260** | `fchownat` | Change ownership relative to dir fd. |
| **261** | `futimesat` | Change timestamps relative to dir fd. |
| **262** | `newfstatat` | Get file status relative to dir fd. |
| **263** | `unlinkat` | Remove entry relative to dir fd. |
| **264** | `renameat` | Rename file relative to dir fd. |
| **265** | `linkat` | Create link relative to dir fd. |
| **266** | `symlinkat` | Create symbolic link relative to dir fd. |
| **267** | `readlinkat` | Read symbolic link relative to dir fd. |
| **268** | `fchmodat` | Change file permissions relative to dir fd. |
| **269** | `faccessat` | Check file permissions relative to dir fd. |
| **270** | `pselect6` | I/O multiplexing with signal masking. |
| **271** | `ppoll` | Wait for events with signal masking. |
| **272** | `unshare` | Run programs with different namespaces. |
| **273** | `set_robust_list` | Set robust futex list of a process. |
| **274** | `get_robust_list` | Get robust futex list of a process. |
| **275** | `splice` | Splice data from/to a pipe. |
| **276** | `tee` | Duplicate a pipe content. |
| **277** | `sync_file_range` | Synchronization of file data. |
| **278** | `vmsplice` | Splice user pages from/to a pipe. |
| **279** | `move_pages` | Move process pages to other nodes. |
| **280** | `utimensat` | Change file timestamps (nanosecond). |
| **281** | `epoll_pwait` | Wait for events on epoll with masking. |
| **282** | `signalfd` | Receive signals via a file descriptor. |
| **283** | `timerfd_create` | Timer notifications via file descriptor. |
| **284** | `eventfd` | Event notifications via file descriptor. |
| **285** | `fallocate` | Manipulate/preallocate file space. |
| **286** | `timerfd_settime` | Set expiration time for timerfd timer. |
| **287** | `timerfd_gettime` | Get remaining time for timerfd timer. |
| **288** | `accept4` | Accept socket connection (with flags). |
| **289** | `signalfd4` | Create signalfd (with flags). |
| **290** | `eventfd2` | Create eventfd (with flags). |
| **291** | `epoll_create1` | Create epoll descriptor (with flags). |
| **292** | `dup3` | Duplicate file descriptor (with flags). |
| **293** | `pipe2` | Create a pipe (with flags). |
| **294** | `inotify_init1` | Initialize inotify (with flags). |
| **295** | `preadv` | Read vector I/O at a given offset. |
| **296** | `pwritev` | Write vector I/O at a given offset. |
| **297** | `rt_tgsigqueueinfo` | Send signal/data to thread in group. |
| **298** | `perf_event_open` | Monitor performance events. |
| **299** | `recvmmsg` | Receive multiple socket messages. |
| **300** | `fanotify_init` | Initialize fanotify group. |
| **301** | `fanotify_mark` | Manipulate fanotify marks. |
| **302** | `prlimit64` | Get/set resource limits. |
| **303** | `name_to_handle_at` | Get file handle for a given path. |
| **304** | `open_by_handle_at` | Open a file using its handle. |
| **305** | `clock_adjtime` | Adjust time/status of a clock. |
| **306** | `syncfs` | Commit filesystem buffers for specific FS. |
| **307** | `sendmmsg` | Send multiple socket messages. |
| **308** | `setns` | Reassociate thread with a namespace. |
| **309** | `getcpu` | Get CPU and NUMA node IDs. |
| **310** | `process_vm_readv` | Read from another process's VM. |
| **311** | `process_vm_writev` | Write into another process's VM. |
| **312** | `kcmp` | Compare shared resources between processes. |
| **313** | `finit_module` | Load kernel module via file descriptor. |
| **314** | `sched_setattr` | Set scheduling policy/attributes. |
| **315** | `sched_getattr` | Get scheduling policy/attributes. |
| **316** | `renameat2` | Rename file relative to dir fd (with flags). |
| **317** | `seccomp` | Control process secure computing state. |
| **318** | `getrandom` | Obtain sequence of random bytes. |
| **319** | `memfd_create` | Create anonymous file in RAM. |
| **320** | `kexec_file_load` | Load kernel for later exec via file descriptor. |
| **321** | `bpf` | Perform command on eBPF object. |
| **322** | `execveat` | Execute program relative to dir fd. |
| **323** | `userfaultfd` | Handle page faults in user space. |
| **324** | `membarrier` | Issue memory barrier on set of threads. |
| **325** | `mlock2` | Lock range of memory (with flags). |
| **326** | `copy_file_range` | Copy data from one file to another. |
| **327** | `preadv2` | Read vector I/O at offset (with flags). |
| **328** | `pwritev2` | Write vector I/O at offset (with flags). |
| **329** | `pkey_mprotect` | Set memory protection with keys. |
| **330** | `pkey_alloc` | Allocate a memory key. |
| **331** | `pkey_free` | Free a memory key. |
| **332** | `statx` | Enhanced file status information. |
| **333** | `io_pgetevents` | Read AIO events (with masking). |
| **334** | `rseq` | Restartable sequences. |
| **335** | `uretprobe` | Not implemented (legacy). |
| **424** | `pidfd_send_signal` | Send signal via pidfd. |
| **425** | `io_uring_setup` | Initialize io_uring context. |
| **426** | `io_uring_enter` | Submit/wait for io_uring events. |
| **427** | `io_uring_register` | Register files/buffers for io_uring. |
| **428** | `open_tree` | Clone a mount tree. |
| **429** | `move_mount` | Move a mount relative to dir fds. |
| **430** | `fsopen` | Open a filesystem context. |
| **431** | `fsconfig` | Configure a filesystem context. |
| **432** | `fsmount` | Create mount for filesystem context. |
| **433** | `fspick` | Pick FS for reconfiguration. |
| **434** | `pidfd_open` | Obtain a file descriptor for a process. |
| **435** | `clone3` | Create child process (extensible). |
| **436** | `close_range` | Close a range of file descriptors. |
| **437** | `openat2` | Open file relative to dir fd (extensible). |
| **438** | `pidfd_getfd` | Copy file descriptor from another process. |
| **439** | `faccessat2` | Check file permissions relative to dir fd. |
| **440** | `process_madvise` | Give memory advice to another process. |
| **441** | `epoll_pwait2` | Wait for events on epoll (nanosecond). |
| **442** | `mount_setattr` | Change mount attributes. |
| **443** | `quotactl_fd` | Manipulate quotas via file descriptor. |
| **444** | `landlock_create_ruleset` | Create Landlock ruleset. |
| **445** | `landlock_add_rule` | Add rule to Landlock ruleset. |
| **446** | `landlock_restrict_self` | Apply Landlock ruleset to self. |
| **447** | `memfd_secret` | Create secret memory area. |
| **448** | `process_mrelease` | Release memory of dying process. |
| **449** | `futex_waitv` | Wait on multiple futexes. |
| **450** | `set_mempolicy_home_node` | Set home node for memory range. |
| **451** | `cachestat` | Get page cache statistics for a file. |
| **452** | `fchmodat2` | Change permissions relative to dir fd. |
| **453** | `map_shadow_stack` | Map a shadow stack area. |
| **454** | `futex_wake` | Wake thread waiting on a futex. |
| **455** | `futex_wait` | Wait on a futex. |
| **456** | `futex_requeue` | Requeue threads waiting on futexes. |
| **457** | `statmount` | Get filesystem mount information. |
| **458** | `listmount` | List mounts in a namespace. |
| **459** | `lsm_get_self_attr` | Get LSM attributes of current process. |
| **460** | `lsm_set_self_attr` | Set LSM attributes of current process. |
| **461** | `lsm_list_modules` | List available Security Modules. |
| **462** | `mseal` | Seal memory area to prevent modification. |

</details>

## :balance_scale: License

​[​Apache License 2.0](./LICENSE)

---

## :pencil: Author

​This project was started in 2023 by [​Nicholas Wilde​](https://github.com/nicholaswilde/).
