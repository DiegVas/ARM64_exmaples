.global _start

.text
_start:
    mov x0, 3

    mov x1, 5

    mul x2, x0, x0 //9

    mov x3, 2

    mul x4, x0, x1 // 15

    mul x3, x3, x4 //30

    mul x5, x1, x1 // 25

    add x6, x2, x3 // 39

    sub x0, x6, x5 // 14

    mov x8, 93          // sys_exit
    svc 0