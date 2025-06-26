.global _start

_start:
    // Escribir el mensaje de entrada
    
    mov x0, 1
    ldr x1, =msg
    mov x2, 18
    mov x8, 64  // syscall number for write
    svc 0

    // Leer la entrada del usuario

    mov x0, 0
    ldr x1, =buf
    mov x2, 16
    mov x8, 63  // syscall number for read
    svc 0

    // Mostrar el texto ingresado

    mov x0, 1
    ldr x1, =buf
    mov x2, 16
    mov x8, 64  // syscall number for write
    svc 0

    // Terminar el programa

    mov x0, 0
    mov x8, 93  // syscall number for exit
    svc 0




.data
msg: .asciz "Enter a text: "

.bss
buf: .space 16