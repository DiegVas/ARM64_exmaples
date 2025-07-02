.global suavizado_exponencial
.global res_suav
.extern itoa
.extern buffer_ordenado

.section .bss
buffer: .skip 40960
numeros: .skip 40960
res_suav: .skip 64
suavizados: .skip 40960


.section .data
error_msg: .asciz "Error: al calcular el suavizado exponencial\n"
error_msg_tamaño = . - error_msg - 1
.align 3
const_0_5: .double 0.5
const_1_0: .double 1.0
const_0_0: .double 0.0

.section .text
suavizado_exponencial:
    stp x29, x30, [sp, #-48]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x29, sp

    cbz x1, error_salir

    ldr x19, =buffer_ordenado
    mov x21, #0
    mov x8, #0
    mov x25, #0

    adr x0, const_0_5
    ldr d0, [x0]
    adr x0, const_1_0
    ldr d4, [x0]
    adr x0, const_0_0
    ldr d3, [x0]


procesar_numero:
    ldrb w22, [x19, x21]
    cbz w22, convercion_completada
    cmp x21, #40960
    bge convercion_completada

    mov x22, #0

bucle_parseo:
    ldrb w23, [x19, x21]
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
    b bucle_parseo

saltar_invalido:
    add x21, x21, #1
    b bucle_parseo

final_numero:
    scvtf d1, x22
    cmp x25, #0
    beq primer_valor

    fmul d1, d1, d0
    fsub d2, d4, d0
    fmul d2, d2, d3
    fadd d3, d1, d2

    fcvtzs x0, d3
    ldr x1, =suavizados
    str w0, [x1, x8, LSL #2]

    b continuar_loop

primer_valor:
    fmov d3, d1
    fcvtzs x0, d3
    ldr x1, =suavizados
    str w0, [x1, x8, LSL #2]
    mov x25, #1

continuar_loop:
    add x21, x21, #1
    add x8, x8, #1
    b procesar_numero

convercion_completada:
    mov x9, #0    
    mov x10, x8
    ldr x11, =suavizados

imprimir_bucle:
    cmp x9, x10
    bge salir

    ldr w0, [x11, x9, LSL #2]
    ldr x1, =res_suav
    mov x2, #64
    bl itoa

    mov x2, x0
    ldr x1, =res_suav
    mov w3, #10
    strb w3, [x1, x2]
    add x2, x2, #1

    mov x0, #1
    ldr x1, =res_suav
    mov x8, #64
    svc #0

    add x9, x9, #1
    b imprimir_bucle

error_salir:
    mov x0, #2
    ldr x1, =error_msg
    mov x2, error_msg_tamaño
    mov x8, #64
    svc #0

salir:
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    ldp x29, x30, [sp], #48
    mov x0, #0
    ret
