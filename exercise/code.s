.global _start

.section .data
// Buffer que convierte el número a texto
toText: .space 8 

.section .text
_start:
    mov x0, #1234
    ldr x1, =toText
    bl itoa

itoa:
    mov x2, x1
    mov x3, #1000


loop:
    udiv x4, x0, x3
    msub x0, x4, x3, x0
    add x4, x4, #'0'
    strb w4, [x2], #1
    mov x5, #10
    udiv x3, x3, x5
    cbnz x3, loop


    mov x0, #1
    ldr x1, =toText
    mov x2, #5
    mov x8, #64
    svc #0

    mov x0, #0
    mov x8, #93
    svc #0