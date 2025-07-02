.global minimo_maximo
.global resultado_minimo
.global resultado_maximo
.extern itoa
.extern buffer_intervalo

.section .bss
buffer_: .skip 64
resultado_minimo: .skip 64
resultado_maximo: .skip 64

.section .data
error_msg: .asciz "Error: Al calcular la minimo y maximo\n"
error_msg_tamaño = . - error_msg - 1
linea_nueva: .asciz "\n"

.section .text
minimo_maximo:
    stp     x29, x30, [sp, #-48]!
    stp     x19, x20, [sp, #16]
    stp     x21, x22, [sp, #32]
    mov     x29, sp

    ldr x19, =buffer_intervalo
    cbz     x19, error_salir
    
    mov     x20, #-1
    mov     x21, #-1
    mov     x22, #0

buscar_primer_numero:
    ldrb    w23, [x19, x22]
    cmp     w23, #0
    beq     string_vacio
    
    cmp     w23, #'0'
    blt     siguiente_char_inicio
    cmp     w23, #'9'
    bgt     siguiente_char_inicio
    
    mov     x24, #0
    
parsear_primer_numero:
    ldrb    w23, [x19, x22]
    cmp     w23, #0
    beq     guardar_primer_numero
    
    cmp     w23, #'0'
    blt     guardar_primer_numero
    cmp     w23, #'9'
    bgt     guardar_primer_numero
    
    sub     w23, w23, #48
    mov     x25, #10
    mul     x24, x24, x25
    add     x24, x24, x23
    
    add     x22, x22, #1
    b       parsear_primer_numero

guardar_primer_numero:
    mov     x20, x24
    mov     x21, x24

    ldrb    w23, [x19, x22]
    cmp     w23, #0
    beq     convertir_resultados

buscar_ultimo_numero:
    mov     x25, #0
    
encontrar_longitud:
    ldrb    w23, [x19, x25]
    cmp     w23, #0
    beq     buscar_desde_final
    add     x25, x25, #1
    b       encontrar_longitud

buscar_desde_final:
    cmp     x25, #0
    beq     convertir_resultados
    
    sub     x25, x25, #1
    
encontrar_ultimo_digito:
    ldrb    w23, [x19, x25]
    cmp     w23, #'0'
    blt     retroceder
    cmp     w23, #'9'
    bgt     retroceder
    
    mov     x22, x25
    b       buscar_inicio_ultimo_numero

retroceder:
    cmp     x25, #0
    beq     convertir_resultados
    sub     x25, x25, #1
    b       encontrar_ultimo_digito

buscar_inicio_ultimo_numero:
    cmp     x22, #0
    beq     parsear_ultimo_numero
    
    sub     x26, x22, #1
    ldrb    w23, [x19, x26]
    cmp     w23, #'0'
    blt     parsear_ultimo_numero
    cmp     w23, #'9'
    bgt     parsear_ultimo_numero
    
    mov     x22, x26
    b       buscar_inicio_ultimo_numero

parsear_ultimo_numero:
    mov     x24, #0
    
parsear_ultimo_loop:
    ldrb    w23, [x19, x22]
    cmp     w23, #0
    beq     guardar_ultimo_numero
    
    cmp     w23, #48
    blt     guardar_ultimo_numero
    cmp     w23, #57
    bgt     guardar_ultimo_numero
    
    sub     w23, w23, #48
    mov     x25, #10
    mul     x24, x24, x25
    add     x24, x24, x23
    
    add     x22, x22, #1
    b       parsear_ultimo_loop

guardar_ultimo_numero:
    mov     x21, x24
    b       convertir_resultados

siguiente_char_inicio:
    add     x22, x22, #1
    b       buscar_primer_numero

string_vacio:
    b       error_salir

convertir_resultados:
    cmp     x20, #-1
    beq     error_salir
    
    mov     x0, x20
    ldr     x1, =resultado_minimo
    mov     x2, #64
    bl      itoa
    
    mov     x0, x21
    ldr     x1, =resultado_maximo
    mov     x2, #64
    bl      itoa
    
    ldr     x1, =resultado_minimo
    mov     x8, #0
calcular_len_min:
    ldrb    w0, [x1, x8]
    cmp     w0, #0
    beq     len_min_calculada
    add     x8, x8, #1
    b       calcular_len_min
len_min_calculada:
    mov     x9, x8
    
    ldr     x1, =resultado_maximo
    mov     x8, #0
calcular_len_max:
    ldrb    w0, [x1, x8]
    cmp     w0, #0
    beq     len_max_calculada
    add     x8, x8, #1
    b       calcular_len_max
len_max_calculada:
    mov     x10, x8
    ldr x1, =resultado_minimo
    ldr x3, =resultado_maximo

    mov     x0, #0
    ldp     x21, x22, [sp, #32]
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #48
    ret

error_salir:
    mov     x0, #1
    ldr     x1, =error_msg
    mov     x2, error_msg_tamaño
    mov     x8, #64
    svc     #0
    
    mov     x0, #1
    ldp     x21, x22, [sp, #32]
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #48
    ret

