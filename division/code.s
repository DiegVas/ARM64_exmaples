.global _start

.text
_start:
    mov x0, 1
    mov x1, 2
    mov x3, 3
    mov x4, 4

    sub x5, x4,x1
    sub x6, x3,x0

    sdiv x0, x5, x6


    mov x8, 93
    svc 0
