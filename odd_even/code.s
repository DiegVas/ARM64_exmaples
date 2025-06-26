.global _start

.data
msg: .asciz "Enter a number: "

.bss
buf: .space 2

.text
_start:
    // Write the input message
    mov x0, 1
    ldr x1, =msg
    mov x2, 18
    mov x8, 64  // syscall number for write
    svc 0

    // Read user input
    mov x0, 0
    ldr x1, =buf
    mov x2, 2
    mov x8, 63  // syscall number for read
    svc 0

    ldr x0, =buf
    ldrb w1, [x0]  // Load the first byte (character) from buf
    sub w1, w1, 48  // Convert ASCII to integer (assuming single digit input)
    and w2, w1, #1  // Check if the number is odd or even (0 for even, 1 for odd)
    add w2, w2, 48
    strb w2, [x0]

    mov x0, 1
    ldr x1, =buf
    mov x2, 2
    mov x8, 64  // syscall number for write
    svc 0

    // Exit the program

    mov x0, 0
    mov x8, 93  // syscall number for exit
    svc 0