.global itoa

.section .text

itoa:
    stp     x29, x30, [sp, #-32]!
    stp     x19, x20, [sp, #16]
    mov     x29, sp
    
    cbz     x1, error_itoa
    cbz     x2, error_itoa
    
    cbnz    x0, itoa_nocero
    mov     w3, #48
    strb    w3, [x1]
    mov     w3, #0
    strb    w3, [x1, #1]
    mov     x0, #1
    b       itoa_completado
    
itoa_nocero:
    mov     x19, x1
    add     x20, x1, x2
    sub     x20, x20, #1
    mov     w3, #0
    strb    w3, [x20]
    sub     x20, x20, #1
    
    mov     x4, #10
    mov     x5, x0
    
bucle_itoa:
    udiv    x6, x5, x4
    msub    x7, x6, x4, x5
    add     w7, w7, #48
    strb    w7, [x20]
    sub     x20, x20, #1
    mov     x5, x6
    cbnz    x5, bucle_itoa
    
    add     x20, x20, #1
    sub     x0, x1, x20
    neg     x0, x0
    mov     x3, x0
    
bucle_asignacion:
    ldrb    w5, [x20]
    strb    w5, [x1]
    add     x20, x20, #1
    add     x1, x1, #1
    subs    x3, x3, #1
    bne     bucle_asignacion
    
    b       itoa_completado

error_itoa:
    mov     x0, #-1

itoa_completado:
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #32
    ret
