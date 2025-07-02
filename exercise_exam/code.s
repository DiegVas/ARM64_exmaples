.global _start

.text
_start:
    mov x0, 2

    mov x1, 2

    mul x2, x0, x0 //4

    mul x3, x2, x0 //8

    mov x4, 3

    mul x5, x4, x2 //12

    mul x5, x5, x1 //24

    mul x6, x1, x1 //4

    mul x7, x4, x0 //6

    mul x7, x7, x6 //24

    add x0, x3, x5 // 32

    add x0, x0, x7 // 56

    add x0, x0, x6 // 60

    # System call para salir
    mov x8, 93       // número de system call para exit
    svc 0            // llamada al sistema