global _start

section .data
    ; The file we want to read
    filepath db '/proc/loadavg', 0  

    ; Our formatted prefix (Includes ANSI escape code \033[1;36m for bold cyan)
    prefix db 'Load Average: ', 27, '[1;36m'
    prefix_len equ $ - prefix   ; Automatically calculates the length of the string

    ; Our formatted suffix (Resets color with \033[0m, adds text, and a newline)
    suffix db 27, '[0m (1m)', 10
    suffix_len equ $ - suffix

section .bss
    ; Reserve 64 bytes for the raw text from /proc/loadavg
    buffer resb 64                  

section .text
_start:
    ; ----------------------------------------------------
    ; 1. OPEN THE FILE
    ; ----------------------------------------------------
    mov rax, 2          ; sys_open
    mov rdi, filepath
    mov rsi, 0          ; O_RDONLY
    syscall
    mov r8, rax         ; Save the file descriptor to r8

    ; ----------------------------------------------------
    ; 2. READ THE FILE
    ; ----------------------------------------------------
    mov rax, 0          ; sys_read
    mov rdi, r8         ; The file descriptor
    mov rsi, buffer     ; Point to our empty buffer
    mov rdx, 64         ; Max bytes to read
    syscall             

    ; ----------------------------------------------------
    ; 3. CLOSE THE FILE (Clean up early)
    ; ----------------------------------------------------
    mov rax, 3          ; sys_close
    mov rdi, r8         ; The file descriptor
    syscall             

    ; ----------------------------------------------------
    ; 4. PARSE THE STRING (Find the first space)
    ; ----------------------------------------------------
    mov rcx, 0          ; Set our byte counter (length) to 0

.find_space:
    mov al, byte [buffer + rcx] ; Load a single byte from the buffer into the 'al' register
    cmp al, 0x20                ; Compare that byte to 0x20 (the hex value for an ASCII space)
    je .print_output            ; If it IS a space, jump out of the loop to print
    inc rcx                     ; If it is NOT a space, increment our counter by 1
    jmp .find_space             ; Jump back to the top of the loop to check the next byte

.print_output:
    ; At this point, rcx holds the exact number of bytes before the first space!
    mov r9, rcx         ; Save that exact length into r9 so we can use it during sys_write

    ; ----------------------------------------------------
    ; 5. PRINT THE PREFIX
    ; ----------------------------------------------------
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, prefix     ; Pointer to our "Load Average: " string
    mov rdx, prefix_len ; The pre-calculated length
    syscall

    ; ----------------------------------------------------
    ; 6. PRINT THE 1-MINUTE LOAD 
    ; ----------------------------------------------------
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, buffer     ; Pointer to the start of our raw loadavg data
    mov rdx, r9         ; The dynamic length we calculated in our loop!
    syscall

    ; ----------------------------------------------------
    ; 7. PRINT THE SUFFIX
    ; ----------------------------------------------------
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, suffix     ; Pointer to our " (1m)" string and newline
    mov rdx, suffix_len ; The pre-calculated length
    syscall

    ; ----------------------------------------------------
    ; 8. EXIT
    ; ----------------------------------------------------
    mov rax, 60         ; sys_exit
    mov rdi, 0          ; Exit code 0
    syscall
