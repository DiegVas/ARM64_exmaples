.global _start


.data
_welcome:
    .asciz "/--------- Welcome to the TUI ---------/\n\n"
_menu:
    .asciz "/--------- Select a option ---------/\n 1. select file\n 2. select range\n 3. calculate sum\n 4. calculate median\n 5. calculate average\n 6. calculate mode\n 7. calculate standard deviation\n 8. calculate variance\n 9. median movile\n 10. exit\n\n"

_input_show:
    .asciz "Please select an option: "

_exit_message:
    .asciz "Exiting TUI...\n"
.bss
_option:
    .space 2

.text
_start:
    // Mostrar el mensa de bienvenida
    mov x0, 1 
    ldr x1, =_welcome
    mov x2, 42
    mov x8, 64 // syscall: write
    svc 0

    // Mostrar el menu
    mov x0, 1 
    ldr x1, =_menu
    mov x2, 236 
    mov x8, 64 // syscall: write
    svc 0

    // Mostrar el mensaje para ingresar una opción
    mov x0, 1
    ldr x1, =_input_show
    mov x2, 25 
    mov x8, 64 // syscall: write
    svc 0

    // Leer la opción del usuario
    mov x0, 0
    ldr x1, =_option
    mov x2, 2 
    mov x8, 63 // syscall: read
    svc 0

_final:

    mov x8, 93
    svc 0 // syscall: exit





