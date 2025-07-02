.global calcular_promedio

.extern itoa
.extern buffer_intervalo

.section .bss
buffer_: .skip 40960
resultado: .skip 64

.section .text
calcular_promedio:
    stp x29, x30, [sp, #-48]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x29, sp

    cbz x1, error_salir

    ldr x19, =buffer_intervalo
    mov x20, #0
    mov x21, #0
    mov x8, #0
    
procesar_numero:
    ldrb    w22, [x19, x21]
    cbz w22, convercion_completada
    cmp x21, #40960
    bge convercion_completada

    mov x22, #0
    
bucle_parseo:
    ldrb    w23, [x19, x21]
    cbz w23, final_numero
    cmp w23, #10
    beq final_numero
    cmp w23, #48
    blt saltar_invalido
    cmp w23, #57
    bgt saltar_invalido
    
    sub w23, w23, #48
    mov x24, #10
    mul x22, x22, x24
    add x22, x22, x23
    
    add x21, x21, #1
    b   bucle_parseo

saltar_invalido:
    add x21, x21, #1
    b   bucle_parseo
    
final_numero:
    add x20, x20, x22
    
    add x21, x21, #1
    add x8, x8, #1
    b procesar_numero

convercion_completada:
    mov x24, x8
    udiv x20, x20, x24

    mov x0, x20
    mov x17, x0
    ldr x1, =resultado
    mov x2, #64
    bl itoa
    
    mov x2, x0
    ldr x1, =resultado
    mov w3, #10
    strb    w3, [x1, x2]
    add x2, x2, #1
    
    mov x0, #1
    ldr x1, =resultado
    
    mov x0, #0
    
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    ldp x29, x30, [sp], #48
    ret

error_salir:
    mov x0, #-1
    b   salir

salir:
    ldp x29, x30, [sp], #48
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    ret
