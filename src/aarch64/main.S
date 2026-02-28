.global _start

# ----------------------------------------------------
# MACROS (GAS Style - AArch64)
# ----------------------------------------------------
# Print a string defined by a label
.macro print str, len
    mov x8, #64             // sys_write
    mov x0, #1              // stdout
    adrp x1, \str           // Page-aligned address
    add x1, x1, :lo12:\str  // Low 12 bits
    mov x2, \len            // Length
    svc #0
.endm

# Print a string from a memory address stored in a register
.macro print_reg reg, len
    mov x8, #64             // sys_write
    mov x0, #1              // stdout
    mov x1, eg            // Pointer from register
    mov x2, \len            // Length
    svc #0
.endm

.data
    load_path: .asciz "/proc/loadavg"    // Null-terminated path
    
    load_err:  .ascii "Error: Could not open /proc/loadavg
"
    .equ load_err_len, . - load_err

    prefix:    .ascii "Load Average: \033[1;36m"
    .equ prefix_len, . - prefix

    sep1:      .ascii "\033[0m (1m) | \033[1;36m"
    .equ sep1_len, . - sep1

    sep2:      .ascii "\033[0m (5m) | \033[1;36m"
    .equ sep2_len, . - sep2

    suffix:    .ascii "\033[0m (15m)
"
    .equ suffix_len, . - suffix

.bss
    .lcomm buffer, 2048     // Allocate 2KB of uninitialized memory

.text
_start:
    # ----------------------------------------------------
    # 1. OPEN & READ THE FILE
    # ----------------------------------------------------
    # AArch64 prefers sys_openat (56) over sys_open (1024)
    mov x8, #56             // sys_openat
    mov x0, #-100           // AT_FDCWD (Special constant to use relative paths)
    adrp x1, load_path
    add x1, x1, :lo12:load_path
    mov x2, #0              // O_RDONLY
    mov x3, #0              // mode (ignored)
    svc #0

    cmp x0, #0
    blt .load_error      
    mov x19, x0             // Save file descriptor in x19 (callee-saved)
    
    mov x8, #63             // sys_read
    mov x0, x19         
    adrp x1, buffer     
    add x1, x1, :lo12:buffer
    mov x2, #2048         
    svc #0             

    mov x8, #57             // sys_close
    mov x0, x19         
    svc #0             

    # ----------------------------------------------------
    # 2. PARSE THE BUFFER
    # ----------------------------------------------------
    mov x20, #0             // Byte counter
    adrp x21, buffer
    add x21, x21, :lo12:buffer // Base address of buffer

.find_1m:
    ldrb w22, [x21, x20]    // Load 1 byte from buffer + offset
    cmp w22, #0x20          // Space character
    beq .found_1m
    add x20, x20, #1
    b .find_1m

.found_1m:
    mov x23, x20            // Length of 1m
    add x20, x20, #1        // Skip space
    add x24, x21, x20       // Start address of 5m
    mov x25, x20            // Start offset of 5m

.find_5m:
    ldrb w22, [x21, x20]
    cmp w22, #0x20
    beq .found_5m
    add x20, x20, #1
    b .find_5m

.found_5m:
    sub x26, x20, x25       // Length of 5m
    add x20, x20, #1        // Skip space
    add x27, x21, x20       // Start address of 15m
    mov x28, x20            // Start offset of 15m

.find_15m:
    ldrb w22, [x21, x20]
    cmp w22, #0x20
    beq .found_15m
    add x20, x20, #1
    b .find_15m

.found_15m:
    sub x29, x20, x28       // Length of 15m

    # ----------------------------------------------------
    # 3. PRINT THE OUTPUT
    # ----------------------------------------------------
    print prefix, prefix_len
    print_reg x21, x23            
    print sep1, sep1_len
    print_reg x24, x26              
    print sep2, sep2_len
    print_reg x27, x29              
    print suffix, suffix_len

    # ----------------------------------------------------
    # 4. EXITS
    # ----------------------------------------------------
.exit:
    mov x8, #93             // sys_exit
    mov x0, #0            
    svc #0             

.load_error:
    print load_err, load_err_len
    mov x8, #93         
    mov x0, #1            
    svc #0
