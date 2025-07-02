.global media_movil

.extern itoa
.extern calcular_promedio

.section .bss
buffer: .skip 40960
numeros: .skip 40960
res_med_mov: .skip 1024

.section .data
error_msg: .asciz "Error: al calcular la media movil\n"
error_msg_tamaño = . - error_msg - 1

.section .text
media_movil:
    stp x29, x30, [sp, #-48]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x29, sp

    cbz x1, error_salir

    bl calcular_promedio

convercion_completada:

    mov x0, x17
    ldr x1, =res_med_mov
    mov x2, #64
    bl itoa
    
    mov x2, x0
    ldr x1, =res_med_mov
    mov w3, #10
    strb w3, [x1, x2]
    add x2, x2, #1


    bl salir

error_salir:
    mov x0, #2
    ldr x1, =error_msg
    mov x2, error_msg_tamaño
    mov x8, #64
    svc #0
    b salir

salir:
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    ldp x29, x30, [sp], #48
    mov x0, #0
    ret


    