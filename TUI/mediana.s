.global calcular_mediana
.global res_mediana

.extern itoa
.extern buffer_intervalo
.extern tamanio_buffer

.section .bss
buffer_: .skip 64
res_mediana: .skip 64

.section .data
error_msg: .asciz "Error: Al calcular la mediana\n"
error_msg_tamaño = . - error_msg - 1
linea_nueva: .asciz "\n"

.section .text
calcular_mediana:
    stp     x29, x30, [sp, #-48]!
    stp     x19, x20, [sp, #16]
    stp     x21, x22, [sp, #32]
    mov     x29, sp      

    mov x7, x27
    mov x0, x1
    cbz x0, error_salir

    mov x1, #2
    udiv x10, x7, x1        
    
    and x4, x7, #1          

    b encontrar_centro

encontrar_centro:
    ldr x19, =buffer_intervalo          
    mov x20, #0            
    mov x25, #0            
    mov x21, #0            
    mov x8, #0             
    
procesar_numero:
    ldrb    w22, [x19, x21]
    cbz     w22, convercion_completada
    
    cmp     x21, #40960
    bge     convercion_completada

    mov     x22, #0        
    
bucle_parseo:
    ldrb    w23, [x19, x21]
    cbz     w23, final_numero
    cmp     w23, #10
    beq     final_numero
    cmp     w23, #48
    blt     saltar_invalido
    cmp     w23, #57
    bgt     saltar_invalido
    
    sub     w23, w23, #48
    mov     x24, #10
    mul     x22, x22, x24
    add     x22, x22, x23
    
    add     x21, x21, #1
    b       bucle_parseo

saltar_invalido:
    add     x21, x21, #1
    b       bucle_parseo
    
final_numero:
    add     x21, x21, #1
    
    cmp     x8, x10
    beq     guardar_medio
    
    add     x11, x10, #1
    cmp     x8, x11
    beq     guardar_segundo_medio
    
    add     x8, x8, #1
    b       procesar_numero

guardar_medio:
    mov     x20, x22
    add     x8, x8, #1
    b       procesar_numero
    
guardar_segundo_medio:
    mov     x25, x22
    b       convercion_completada
    
continuar_procesamiento:
    add     x8, x8, #1
    b       procesar_numero

convercion_completada:
    cmp x4, #0
    beq caso_par
    
    mov x0, x20
    b convertir_resultado
    
caso_par:
    add x0, x20, x25
    mov x1, #2
    udiv x0, x0, x1

convertir_resultado:
    ldr x1, =res_mediana
    mov x2, #64
    bl itoa

    mov x2, x0

    ldr x1, =res_mediana
    mov w3, #10
    strb w3, [x1, x2]
    add x2, x2, #1
 
    svc 0 

    ldp     x19, x20, [sp, #16]
    ldp     x21, x22, [sp, #32]
    ldp     x29, x30, [sp], #48

    ret

error_salir:
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

