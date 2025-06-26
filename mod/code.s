.global _start

.text
_start:
    mov x0, #10       
    mov x1, #3       

    // División mod
    udiv x2, x0, x1    
    mul x3, x2, x1    
    sub x4, x0, x3    

    mov x0, x4         

    // salir del programa (exit syscall)
    mov x8, #93       
    svc 0
