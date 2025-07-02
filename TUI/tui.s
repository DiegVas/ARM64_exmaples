
.global _start

.extern carga_archivo
.extern intervalo
.extern calcular_media
.extern calcular_moda
.extern calcular_varianza
.extern desviacion_estandar
.extern minimo_maximo
.extern calcular_mediana 
.extern itoa
.extern media_movil
.extern suavizado_exponencial
.extern buffer_intervalo
.extern buffer_ordenado
.extern xml

.section .data

menu: .asciz "\n==============================\n        --- MENU ---\n==============================\nIngrese una de las opciones dadas:\n\n  1) Abrir archivo\n  2) Estadísticas\n  3) Predicciones\n  4) Reestablecer intervalo\n  5) Exportar XML\n  6) Salir\n\nOpción: "

exit_msg: .asciz "Saliendo del programa...\n"

file_opened_msg: .asciz "Archivo abierto correctamente.\n"

file_not_found_msg: .asciz "Archivo no encontrado.\n"

menu_estadisticas: .asciz "\n==============================\n   --- ESTADÍSTICAS ---\n==============================\nElija el dato a calcular:\n\n  1) Media\n  2) Mediana\n  3) Moda\n  4) Desviación estándar\n  5) Varianza\n  6) Mínimo/Máximo\n  7) Regresar\n  8) Todas\n\nOpción: "

menu_predicciones: .asciz "\n==============================\n  --- PREDICCIONES ---\n==============================\nSeleccione la predicción a realizar:\n\n  1) Media móvil\n  2) Suavizado exponencial\n  3) Regresar\n\nOpción: "

opcion_intervalo: .asciz "\n¿Desea seleccionar un intervalo?\n  1) Sí\n  2) No\n\nOpción: "

bienvenida: .asciz "--- BIENVENIDO AL TUI ---\n"

linea: .asciz "\n "


.section .bss
    .lcomm buffer, 2 

.section .text

_start:

    mov x0, 1
    ldr x1, =bienvenida
    bl print_string

    mov x0, 1
    ldr x1, =menu
    bl print_string

    mov x0, 0
    ldr x1, =buffer
    mov x2, 2
    mov x8, 63
    svc 0

    ldrb w1, [x1]
    cmp w1, '1'
    beq abrir_archivo
    cmp w1, '2'
    beq estadisticas
    cmp w1, '3'
    beq predicciones
    cmp w1, '4'
    beq intervalo_nuevo
    cmp w1, '5'
    beq exportar_xml
    cmp w1, '6'
    beq salir
    b _start


abrir_archivo:

    bl carga_archivo

    mov x0, 1
    ldr x1, =opcion_intervalo
    bl print_string
    
    mov x0, 0
    ldr x1, =buffer
    mov x2, 2
    mov x8, 63
    svc 0

    ldrb w1, [x1]
    cmp w1, '1'
    beq intervalo_
    cmp w1, '2'
    beq mover_ordenado_a_intervalo
    bl print_string


    mov x0, 1
    ldr x1, =file_opened_msg
    bl print_string
    b _start



estadisticas:
    mov x0, 1
    ldr x1, =menu_estadisticas
    bl print_string

    mov x0, 0
    ldr x1, =buffer
    mov x2, 2
    mov x8, 63
    svc 0
    mov x7, x27

    ldrb w1, [x1]
    cmp w1, '1'
    beq imprimir_media
    cmp w1, '2'
    beq imprimir_mediana
    cmp w1, '3'
    beq imprimir_moda
    cmp w1, '4'
    beq imprimir_desviacion
    cmp w1, '5'
    beq imprimir_varianza
    cmp w1, '6'
    beq imprimir_minmax
    cmp w1, '7'
    beq _start
    cmp w1, '8'
    beq calcular_todas

    b _start

imprimir_media:
    bl calcular_media
    bl print_string
    ldr x1, =linea
    bl print_string
    b _start

imprimir_mediana:
    bl calcular_mediana
    bl print_string
    ldr x1, =linea
    bl print_string
    b _start


imprimir_moda:
    bl calcular_moda
    bl print_string
    ldr x1, =linea
    bl print_string
    b _start

imprimir_desviacion:
    bl desviacion_estandar
    bl print_string
    ldr x1, =linea
    bl print_string
    b _start

imprimir_varianza:
    bl calcular_varianza
    bl print_string
    ldr x1, =linea
    bl print_string
    b _start

imprimir_minmax:
    bl minimo_maximo
    bl print_string
    ldr x1, =linea
    bl print_string

    bl minimo_maximo
    mov x1, x3
    bl print_string
    ldr x1, =linea
    bl print_string
    b _start


predicciones:

    ldr x1, =menu_predicciones
    mov x0, 1
    bl print_string

    mov x0, 0
    ldr x1, =buffer
    mov x2, 2
    mov x8, 63
    svc 0

   ldrb w1, [x1]
   cmp w1, '1'
   beq media_movil
   cmp w1, '2'
   beq suavizado_exponencial
   cmp w1, '3'
   beq _start

   bl _start

salir:
    mov x0, 1
    ldr x1, =exit_msg
    bl print_string
    mov x8, 93  
    svc 0

print_string:
    mov x2, 0

calc_length:
    ldrb w3, [x1, x2]
    cbz w3, done
    add x2, x2, 1
    b calc_length

done:
    mov x8, 64  
    mov x0, 1   
    svc 0      
    ret


calcular_todas:
    bl calcular_media
    bl print_string
    ldr x1, =linea
    bl print_string

    bl calcular_mediana
    bl print_string
    ldr x1, =linea
    bl print_string
    
    bl calcular_moda
    bl print_string
    ldr x1, =linea
    bl print_string

    bl desviacion_estandar
    bl print_string
    ldr x1, =linea
    bl print_string

    bl calcular_varianza
    bl print_string
    ldr x1, =linea
    bl print_string

    bl minimo_maximo
    bl print_string
    ldr x1, =linea
    bl print_string

    bl minimo_maximo
    mov x1, x3
    bl print_string
    ldr x1, =linea
    bl print_string
    b _start

intervalo_nuevo:

    mov x0, 1
    ldr x1, =opcion_intervalo
    bl print_string
    
    mov x0, 0
    ldr x1, =buffer
    mov x2, 2
    mov x8, 63
    svc 0

    ldrb w1, [x1]
    cmp w1, '1'
    beq intervalo_
    cmp w1, '2'
    beq mover_ordenado_a_intervalo
    bl print_string

exportar_xml:
    bl xml

intervalo_:

    bl intervalo
    b _start
mover_ordenado_a_intervalo:

    ldr x0, =buffer_ordenado
    ldr x1, =buffer_intervalo
    bl copiar_loop

copiar_loop:
    ldrb w2, [x0], #1 
    strb w2, [x1], #1 
    cbz w2, fin_copiar_loop
    b copiar_loop

fin_copiar_loop:
    b _start


