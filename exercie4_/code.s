.global _start
.text
_start:
    mov x0, 4

    mov x1, 2

    add x2, x0, x1

    add x3, x0, x1

    mul x0, x2, x3
    
    // Terminar el programa
    mov x8, 93      // sys_exit
    svc 0