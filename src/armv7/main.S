.global _start

# ----------------------------------------------------
# MACROS (GAS Style - ARMv7)
# ----------------------------------------------------
# Print a string defined by a label
.macro print str, len
    mov r7, #4              @ sys_write
    mov r0, #1              @ stdout
    ldr r1, =\str           @ Pointer to string
    ldr r2, =\len           @ Length
    svc #0
.endm

# Print a string from a memory address stored in a register
.macro print_reg reg, len
    mov r7, #4              @ sys_write
    mov r0, #1              @ stdout
    mov r1, \reg            @ Pointer from register
    mov r2, \len            @ Length
    svc #0
.endm

.data
    load_path: .asciz "/proc/loadavg"

    load_err:  .ascii "Error: Could not open /proc/loadavg\n"
    .equ load_err_len, . - load_err

    prefix:    .ascii "Load Average: \033[1;36m"
    .equ prefix_len, . - prefix

    sep1:      .ascii "\033[0m (1m) | \033[1;36m"
    .equ sep1_len, . - sep1

    sep2:      .ascii "\033[0m (5m) | \033[1;36m"
    .equ sep2_len, . - sep2

    suffix:    .ascii "\033[0m (15m)\n"
    .equ suffix_len, . - suffix

    host_path: .asciz "/proc/sys/kernel/hostname"
    host_err:  .ascii "Error: Could not open /proc/sys/kernel/hostname\n"
    .equ host_err_len, . - host_err

    host_pref: .ascii "Hostname: \033[1;32m"  @ Green text
    .equ host_pref_len, . - host_pref

.bss
    .lcomm buffer, 2048
    .lcomm host_buffer, 256

.text
_start:
    # ----------------------------------------------------
    # 1. OPEN & READ /proc/loadavg
    # ----------------------------------------------------
    mov r7, #5              @ sys_open
    ldr r0, =load_path
    mov r1, #0              @ O_RDONLY
    mov r2, #0
    svc #0

    cmp r0, #0
    blt .load_error
    mov r4, r0              @ Save FD in r4 (callee-saved)

    mov r7, #3              @ sys_read
    mov r0, r4
    ldr r1, =buffer
    mov r2, #2048
    svc #0

    mov r7, #6              @ sys_close
    mov r0, r4
    svc #0

    # ----------------------------------------------------
    # 2. PARSE THE BUFFER
    # ----------------------------------------------------
    mov r5, #0              @ Byte counter/offset
    ldr r6, =buffer         @ Base address

.find_1m:
    ldrb r1, [r6, r5]       @ Load 1 byte from buffer + offset
    cmp r1, #0x20           @ Space character
    beq .found_1m
    add r5, r5, #1
    b .find_1m

.found_1m:
    mov r8, r5              @ Length of 1m
    add r5, r5, #1          @ Skip space
    add r9, r6, r5          @ Start address of 5m
    mov r10, r5             @ Start offset of 5m

.find_5m:
    ldrb r1, [r6, r5]
    cmp r1, #0x20
    beq .found_5m
    add r5, r5, #1
    b .find_5m

.found_5m:
    sub r11, r5, r10        @ Length of 5m
    add r5, r5, #1          @ Skip space
    add r12, r6, r5          @ Start address of 15m
    mov r2, r5              @ Start offset of 15m (temporary reuse of r2)

.find_15m:
    ldrb r1, [r6, r5]
    cmp r1, #0x20
    beq .found_15m
    add r5, r5, #1
    b .find_15m

.found_15m:
    sub r3, r5, r2          @ Length of 15m (r3 is temporary)
    @ We need to keep lengths safe, so move r3 to a callee-saved register if needed
    @ but we'll print shortly so it's fine.

    # ----------------------------------------------------
    # 3. OPEN & READ /proc/sys/kernel/hostname
    # ----------------------------------------------------
    mov r7, #5              @ sys_open
    ldr r0, =host_path
    mov r1, #0              @ O_RDONLY
    svc #0

    cmp r0, #0
    blt .host_error

    mov r4, r0              @ Save FD
    mov r7, #3              @ sys_read
    mov r0, r4
    ldr r1, =host_buffer
    mov r2, #256
    svc #0
    mov r5, r0              @ Save hostname length in r5

    mov r7, #6              @ sys_close
    mov r0, r4
    svc #0

    # ----------------------------------------------------
    # 4. PRINT THE OUTPUT
    # ----------------------------------------------------
    @ Note: Macros re-load r7, r0, r1, r2, so we must be careful
    @ with what we store in those registers before calling them.

    print prefix, prefix_len
    print_reg r6, r8
    print sep1, sep1_len
    print_reg r9, r11
    print sep2, sep2_len
    print_reg r12, r3
    print suffix, suffix_len

    print host_pref, host_pref_len
    ldr r1, =host_buffer
    print_reg r1, r5

    # ----------------------------------------------------
    # 5. EXIT
    # ----------------------------------------------------
.exit:
    mov r7, #1              @ sys_exit
    mov r0, #0
    svc #0

.load_error:
    print load_err, load_err_len
    mov r7, #1
    mov r0, #1
    svc #0

.host_error:
    print host_err, host_err_len
    mov r7, #1
    mov r0, #1
    svc #0
