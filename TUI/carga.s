.global carga_archivo
.global buffer_ordenado
.global buffer_no_ordenado
.global tamanio_buffer
.global tamanio_no_ordenado

.extern calcular_media
.extern calcular_mediana
.extern itoa

.section .bss
arg1: .space 32
buffer: .skip 40960
buffer_ordenado: .skip 40960
buffer_no_ordenado: .skip 40960
numeros: .skip 40960
indices: .skip 40960
tamanio_buffer: .skip 8
tamanio_no_ordenado: .skip 8

.section .data
linea_nueva: .asciz "\n"
error_msg: .asciz "Error: No se puede abrir el archivo\n"
ingresar_nombre_archivo: .asciz "Ingrese el nombre del archivo: "
error_msg_tamaño = . - error_msg - 1

.section .text

carga_archivo:
    ldr x1, = arg1
    mov x2, #0
    b solicitar_nombre_archivo

solicitar_nombre_archivo:

    mov x0, #1
    ldr x1, =ingresar_nombre_archivo
    mov x2, #31 
    mov x8, #64 
    svc #0

    mov x0, #0
    ldr x1, =arg1
    mov x2, #32
    mov x8, #63  
    svc #0
   
    mov x3, x0   
   
    cmp x3, #0
    ble error_abrir_archivo
    ldr x1, =arg1
    sub x3, x3, #1  
    ldrb w4, [x1, x3]
    cmp w4, #10     
    bne terminar_string
    mov w4, #0     
    strb w4, [x1, x3]
    b abrir_archivo

terminar_string:
    add x3, x3, #1
    mov w4, #0
    strb w4, [x1, x3]

abrir_archivo:
    mov x0, -100
    ldr x1, =arg1
    mov x2, #0
    mov x8, #56
    svc #0

    cmp x0, #0
    blt error_abrir_archivo
    mov x9, x0

leer_archivo:
    mov x0, x9
    ldr x1, =buffer
    mov x2, #40960
    mov x8, #63
    svc #0
    mov x10, x0

cerrar_archivo:
    mov x0, x9
    mov x8, #57
    svc #0

filtrar_buffer:
    ldr x1, =buffer
    mov x2, #0
    mov x3, #0

filtrar_loop:
    cmp x2, x10
    bge fin_filtro
    ldrb w4, [x1, x2]
    cmp w4, #36
    beq siguiente_byte
    strb w4, [x1, x3]
    add x3, x3, #1

siguiente_byte:
    add x2, x2, #1
    b filtrar_loop

fin_filtro:
    mov x10, x3

    ldr x1, =buffer
    ldr x2, =indices
    mov x3, #0
    mov x4, #0
    str x3, [x2, x4, lsl #3]
    add x4, x4, #1

buscar_lineas:
    cmp x3, x10
    bge fin_buscar_lineas
    ldrb w5, [x1, x3]
    cmp w5, #10
    bne continuar_buscar
    add x6, x3, #1
    cmp x6, x10
    bge fin_buscar_lineas
    str x6, [x2, x4, lsl #3]
    add x4, x4, #1

continuar_buscar:
    add x3, x3, #1
    b buscar_lineas

fin_buscar_lineas:
    ldr x6, =numeros
    ldr x15, =indices
    mov x7, #0

convertir_numeros:
    cmp x7, x4
    bge fin_convertir
    ldr x8, [x15, x7, lsl #3]
    add x9, x7, #1
    cmp x9, x4
    bge usar_fin_buffer
    ldr x9, [x15, x9, lsl #3]
    sub x9, x9, #1
    b continuar_conversion

usar_fin_buffer:
    mov x9, x10
    sub x9, x9, #1

continuar_conversion:
    mov x11, #0
    mov x12, x8

convertir_loop:
    cmp x12, x9
    bgt fin_convertir_loop
    ldrb w13, [x1, x12]
    cmp w13, #10
    beq fin_convertir_loop
    sub w13, w13, #48
    mov x14, #10
    mul x11, x11, x14
    add x11, x11, x13
    add x12, x12, #1
    b convertir_loop

fin_convertir_loop:
    str x11, [x6, x7, lsl #3]
    add x7, x7, #1
    b convertir_numeros

fin_convertir:
    // Copiar original sin ordenar
    mov x7, #0
    ldr x15, =indices
    ldr x22, =buffer
    ldr x21, =buffer_no_ordenado
    mov x20, #0

copiar_a_buffer_no_ordenado:
    cmp x7, x4
    bge fin_copiar_no_ordenado
    ldr x8, [x15, x7, lsl #3]
    mov x9, x8
buscar_fin_copiar_no:
    cmp x9, x10
    bge fin_buscar_fin_copiar_no
    ldrb w13, [x22, x9]
    cmp w13, #10
    beq fin_buscar_fin_copiar_no
    add x9, x9, #1
    b buscar_fin_copiar_no
fin_buscar_fin_copiar_no:
    sub x19, x9, x8
    add x19, x19, #1
    mov x16, #0
copiar_bytes_no:
    cmp x16, x19
    bge fin_copiar_bytes_no
    add x23, x22, x8
    ldrb w13, [x23, x16]
    strb w13, [x21, x20]
    add x16, x16, #1
    add x20, x20, #1
    b copiar_bytes_no

fin_copiar_bytes_no:
    add x7, x7, #1
    b copiar_a_buffer_no_ordenado

fin_copiar_no_ordenado:
    // Guardar tamaño sin ordenar
    ldr x1, =tamanio_no_ordenado
    mov x2, x20
    str x2, [x1]

    // Ordenamiento burbuja
    mov x2, #0
    ldr x15, =indices
    b bucle_externo_numeros

bucle_externo_numeros:
    sub x3, x4, #1
    cmp x2, x3
    bge ordenamiento_terminado
    mov x5, #0
    sub x3, x3, x2

bucle_interno_numeros:
    cmp x5, x3
    bge bucle_externo_incrementar_numeros
    ldr x11, [x6, x5, lsl #3]
    add x12, x5, #1
    ldr x13, [x6, x12, lsl #3]
    cmp x11, x13
    ble bucle_interno_incrementar_numeros
    str x13, [x6, x5, lsl #3]
    str x11, [x6, x12, lsl #3]
    ldr x11, [x15, x5, lsl #3]
    ldr x13, [x15, x12, lsl #3]
    str x13, [x15, x5, lsl #3]
    str x11, [x15, x12, lsl #3]

bucle_interno_incrementar_numeros:
    add x5, x5, #1
    b bucle_interno_numeros

bucle_externo_incrementar_numeros:
    add x2, x2, #1
    b bucle_externo_numeros

ordenamiento_terminado:
    mov x7, #0
    ldr x15, =indices
    ldr x22, =buffer
    ldr x21, =buffer_ordenado
    mov x20, #0

copiar_a_buffer_ordenado:
    cmp x7, x4
    bge fin_copiar
    ldr x8, [x15, x7, lsl #3]
    mov x9, x8

buscar_fin_copiar:
    cmp x9, x10
    bge fin_buscar_fin_copiar
    ldrb w13, [x22, x9]
    cmp w13, #10
    beq fin_buscar_fin_copiar
    add x9, x9, #1
    b buscar_fin_copiar

fin_buscar_fin_copiar:
    sub x19, x9, x8
    add x19, x19, #1
    mov x16, #0

copiar_bytes:
    cmp x16, x19
    bge fin_copiar_bytes
    add x23, x22, x8  
    ldrb w13, [x23, x16]    
    strb w13, [x21, x20]
    add x16, x16, #1
    add x20, x20, #1
    b copiar_bytes
    
fin_copiar_bytes:
    add x7, x7, #1
    b copiar_a_buffer_ordenado

fin_copiar:
    // Guardar tamaño ordenado
    mov x27, x7
    ldr x1, =tamanio_buffer
    mov x2, x20
    str x2, [x1]

    // Imprimir buffer ordenado
/*     mov x0, #1
    ldr x1, =buffer_ordenado
    ldr x2, =tamanio_buffer
    ldr x2, [x2]
    mov x8, #64
    svc #0 */

    b salida

error_abrir_archivo:
    mov x0, #2
    ldr x1, =error_msg
    mov x2, error_msg_tamaño
    mov x8, #64
    svc #0
    b salir_error

salir_error:
    ret

salida:
    ret
