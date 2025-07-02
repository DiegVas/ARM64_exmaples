.global _start

.text
_start:
    mov x0, 2

    mov x1, 1

    sub x2, x0, x1 // x2 = 2 - 1 = 1

    mul x3, x0, x0 // x3 = 2 * 2 = 4

    mul x4, x0, x1  // x4 = 2 * 1 = 2

    mul x5, x1, x1 // x5 = 1 * 1 = 1

    add x6, x3, x4 // x6 = 4 + 2 = 6

    add x6, x6, x5 // x6 = 6 + 1 = 7

    mov x8, 93          // sys_exit
    mov x0, x6           // status code
    svc 0