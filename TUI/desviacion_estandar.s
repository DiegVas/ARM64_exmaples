.global desviacion_estandar
.global res_desv

.extern itoa
.extern calcular_varianza
.extern buffer_intervalo
.extern tamanio_buffer

.section .bss
buffer_: .skip 64
res_desv: .skip 16

.section .data
error_msg: .asciz "Error: Al calcular la varianza\n"
error_msg_tamaño = . - error_msg - 1
linea_nueva: .asciz "\n"

.section .text
desviacion_estandar:
    stp x29, x30, [sp, #-48]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x29, sp

    bl calcular_varianza

    scvtf d0, x17
    fsqrt d1, d0
    fcvtzs x20, d1

    mov x0, x20
    ldr x1, =res_desv
    mov x2, #64
    bl itoa
    
    mov x2, x0
    ldr x1, =res_desv
    mov w3, #10
    strb w3, [x1, x2]
    add x2, x2, #1
    
    mov x0, #1
    ldr x1, =res_desv

    mov x0, #0
    
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    ldp x29, x30, [sp], #48
    ret
    
    