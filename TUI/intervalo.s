.extern buffer_ordenado
.extern tamanio_buffer
.extern buffer_intervalo

.section .bss

buffer_ascii: .space 32
buffer_intervalo: .skip 8192
tamanio_intervalo: .skip 8

.section .data

ingreso_min_msg: .asciz "Ingrese el valor mínimo del rango: "
ingreso_max_msg: .asciz "Ingrese el valor máximo del rango: "
error_msg: .asciz "Error: Índices no válidos o fuera de rango\n"

.section .text

.global intervalo
.global buffer_intervalo

intervalo:
    stp x29, x30, [sp, #-32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    mov x0, #1
    ldr x1, =ingreso_min_msg
    mov x2, #35
    mov x8, #64
    svc #0

    mov x0, #0
    mov x2, #32
    ldr x1, =buffer_ascii
    mov x8, #63
    svc #0

    ldr x1, =buffer_ascii
    bl parse_number
    mov x19, x20 

    mov x0, #1
    ldr x1, =ingreso_max_msg
    mov x2, #35
    mov x8, #64
    svc #0

    mov x0, #0
    mov x2, #32
    ldr x1, =buffer_ascii
    mov x8, #63
    svc #0

    ldr x1, =buffer_ascii
    bl parse_number

    cmp x19, #0
    blt error_indices
    cmp x20, x19
    blt error_indices

    bl contar_lineas_ordenadas
    mov x3, x0 

    cmp x20, x3
    bgt error_indices

    sub x19, x19, #1
    sub x20, x20, #1

    bl encontrar_posiciones_intervalo
    bl copiar_intervalo

    bl mostrar_intervalo

    ldr x1, =buffer_intervalo
    ldr x2, =tamanio_intervalo
    ldr x2, [x2]

    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

error_indices:
    ldr x0, =1
    ldr x1, =error_msg
    mov x2, #43
    mov x8, #64
    svc #0

    ldr x1, =buffer_intervalo
    mov x2, #0
    ldr x3, =tamanio_intervalo
    str x2, [x3]

    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

contar_lineas_ordenadas:
    ldr x1, =buffer_ordenado
    ldr x2, =tamanio_buffer
    ldr x2, [x2]
    mov x3, #0 
    mov x4, #0

contar_loop:
    cmp x4, x2
    bge fin_contar
    ldrb w5, [x1, x4]
    cmp w5, #10
    bne continuar_contar
    add x3, x3, #1

continuar_contar:
    add x4, x4, #1
    b contar_loop

fin_contar:
    cmp x4, #0
    beq fin_contar_ret
    sub x4, x4, #1
    ldrb w5, [x1, x4]
    cmp w5, #10
    beq fin_contar_ret
    add x3, x3, #1

fin_contar_ret:
    mov x0, x3
    ret

encontrar_posiciones_intervalo:
    ldr x1, =buffer_ordenado
    ldr x2, =tamanio_buffer
    ldr x2, [x2]
    mov x3, #0
    mov x4, #0
    mov x5, #0   
    mov x6, #0   
    mov x7, #0    
buscar_posiciones:
    cmp x4, x2
    bge fin_buscar_posiciones

    cmp x3, x19
    bne check_final
    mov x5, x7  

check_final:
    ldrb w8, [x1, x4]
    cmp w8, #10
    bne continuar_buscar_pos

    cmp x3, x20
    bne siguiente_linea
    mov x6, x4  
    add x6, x6, #1

    b fin_buscar_posiciones

siguiente_linea:
    add x3, x3, #1
    add x4, x4, #1
    mov x7, x4   
    b buscar_posiciones

continuar_buscar_pos:
    add x4, x4, #1
    b buscar_posiciones

fin_buscar_posiciones:
    cmp x6, #0
    bne posiciones_encontradas
    mov x6, x2

posiciones_encontradas:
    mov x4, x5
    mov x5, x6 
    ret

copiar_intervalo:
    ldr x1, =buffer_ordenado
    ldr x2, =buffer_intervalo
    mov x3, #0 
    sub x6, x5, x4

copiar_loop_intervalo:
    cmp x3, x6
    bge fin_copiar_intervalo
    add x7, x4, x3
    ldrb w8, [x1, x7]
    strb w8, [x2, x3]
    add x3, x3, #1
    b copiar_loop_intervalo

fin_copiar_intervalo:
    ldr x7, =tamanio_intervalo
    str x6, [x7]
    ret

mostrar_intervalo:
    ldr x1, =buffer_intervalo
    ldr x2, =tamanio_intervalo
    ldr x2, [x2]

    mov x0, #1
    mov x8, #64
    svc #0

    ret

parse_number:
    mov x20, #0

parse_loop:
    ldrb w2, [x1], #1
    cmp w2, #'0'
    blt end_parse
    cmp w2, #'9'
    bgt end_parse
    cmp w2, #10
    beq end_parse
    cmp w2, #13
    beq end_parse
    cmp w2, #0
    beq end_parse
    sub w2, w2, #'0'
    mov x3, #10
    mul x20, x20, x3
    add x20, x20, x2
    b parse_loop

end_parse:
    ret
    