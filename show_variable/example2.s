.global _start
_start:
    mov x0, 1 // Mostrar en pantalla, set stdout
    ldr x1, =mensaje // Cargar la dirección del mensaje en x1
    mov x2, 15 // Longitud del mensaje
    mov x8, 64 // syscall write
    svc 0 // Llamada al sistema para escribir

    mov x0, 0 // Código de salida
    mov x8, 93 // syscall exit
    svc 0 // Llamada al sistema para salir

.data
mensaje:
    .asciz "Hola, mundo!\n" // Definir el mensaje a mostrar
    // .asciz asegura que el mensaje sea una cadena de caracteres terminada en nulo
    // La longitud del mensaje es 13 caracteres (incluyendo el salto de línea)
