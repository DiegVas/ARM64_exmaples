.global calcular_moda
.global res_moda

.extern buffer_intervalo
.extern tamanio_buffer
.extern itoa

.section .bss
buffer_: .skip 64
res_moda: .skip 64

.section .data
error_msg: .asciz "Error: Al calcular la moda\n"
error_msg_tamaño = . - error_msg - 1
linea_nueva: .asciz "\n"

.section .text
calcular_moda:
    stp     x29, x30, [sp, #-48]!
    stp     x19, x20, [sp, #16]
    stp     x21, x22, [sp, #32]
    mov     x29, sp  

    ldr x19, =buffer_intervalo
mov     x20, #0
    mov     x21, #-1
    mov     x22, #0
    mov     x2, #0
    mov     x3, #0
bucle_lectura:
    ldrb    w4, [x19, x20]
    cbz     w4, fin 
    cmp     x20, #40960
    bge     fin

    mov     x5, #0
parsear:
    ldrb    w6, [x19, x20]
    cbz     w6, evaluar_num
    cmp     w6, #10
    beq     evaluar_num
    cmp     w6, #48
    blt     ignorar
    cmp     w6, #57
    bgt     ignorar

    sub     w6, w6, #48
    mov    x7, #10
    mul     x5, x5, x7
    add     x5, x5, x6
    add     x20, x20, #1
    b parsear

ignorar:
    add     x20, x20, #1
    b parsear

evaluar_num:
    cmp     x21, x5
    beq     mismo
    mov     x21, x5
    mov     x22, #1
    b comparar_max

mismo:
    add     x22, x22, #1

comparar_max:
    cmp     x22, x3
    ble     avanzar
    mov     x3, x22
    mov     x2, x5

avanzar:
    add     x20, x20, #1
    b bucle_lectura
    
fin:
    mov x0, x2
    ldr x1, =res_moda
    mov x2, #64
    bl itoa

    mov x2, x0
    ldr x1, =res_moda
    mov w3, #10
    strb w3, [x1, x2]
    add x2, x2, #1

    ldr x1, =res_moda

    ldp x29, x30, [sp], #48
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    ret

error_salir:
    b       salir

salir:
    ldp     x29, x30, [sp], #48
    ldp     x19, x20, [sp, #16]
    ldp     x21, x22, [sp, #32]

    mov x0, 1
    ldr x1, =error_msg
    mov x2, error_msg_tamaño
    mov x8, 64
    svc 0
    mov x0, 0
    ret
  

