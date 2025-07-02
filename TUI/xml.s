.global xml

.extern res_desv
.extern res_varianza
.extern res_media
.extern res_moda
.extern res_mediana
.extern resultado_minimo
.extern resultado_maximo
.extern calcular_media
.extern calcular_moda
.extern calcular_varianza
.extern desviacion_estandar
.extern minimo_maximo
.extern calcular_mediana 

.data
filename: .asciz "resultados.xml"
xml_header: .asciz "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<resultados>\n"
xml_footer: .asciz "</resultados>\n"
xml_media_start: .asciz "<media>"
xml_media_end: .asciz "</media>\n"
xml_mediana_start: .asciz "<mediana>"
xml_mediana_end: .asciz "</mediana>\n"
xml_moda_start: .asciz "<moda>"
xml_moda_end: .asciz "</moda>\n"
xml_varianza_start: .asciz "<varianza>"
xml_varianza_end: .asciz "</varianza>\n"
xml_desviacion_start: .asciz "<desviacion>"
xml_desviacion_end: .asciz "</desviacion>\n"
xml_minimo_start: .asciz "<minimo>"
xml_minimo_end: .asciz "</minimo>\n"
xml_maximo_start: .asciz "<maximo>"
xml_maximo_end: .asciz "</maximo>\n"

.text
xml:
    // Preservar registros
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    
    bl calcular_media
    bl calcular_mediana
    bl calcular_moda
    bl calcular_varianza
    bl minimo_maximo
    bl desviacion_estandar





    // Crear archivo XML
    mov x8, #56                // sys_openat
    mov x0, #-100             // AT_FDCWD
    adr x1, filename
    mov x2, #577              // O_WRONLY | O_CREAT | O_TRUNC
    mov x3, #420              // permisos 0644
    svc #0
    
    cmp x0, #0
    blt error_exit
    mov x19, x0               // Guardar file descriptor
    
    // Escribir header XML
    mov x8, #64               // sys_write
    mov x0, x19
    adr x1, xml_header
    mov x2, #57
    svc #0
    
    // Escribir todos los valores
    bl write_media
    bl write_mediana
    bl write_moda
    bl write_varianza
    bl write_desviacion
    bl write_minimo
    bl write_maximo
    
    // Escribir footer XML
    mov x8, #64     
    mov x0, x19
    adr x1, xml_footer
    mov x2, #14
    svc #0
    
    // Cerrar archivo
    mov x8, #57               // sys_close
    mov x0, x19
    svc #0
    
    mov x0, #0                // Exit code 0
    b exit_clean

write_media:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Escribir tag de apertura
    mov x8, #64
    mov x0, x19
    adr x1, xml_media_start
    mov x2, #7
    svc #0

    
    // Escribir valor ASCII directamente
    adr x1, res_media
    bl write_ascii_value
    
    // Escribir tag de cierre
    mov x8, #64
    mov x0, x19
    adr x1, xml_media_end
    mov x2, #9
    svc #0
    
    ldp x29, x30, [sp], #16
    ret

write_mediana:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_mediana_start
    mov x2, #10
    svc #0

    
    adr x1, res_mediana
    bl write_ascii_value
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_mediana_end
    mov x2, #12
    svc #0
    
    ldp x29, x30, [sp], #16
    ret

write_moda:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_moda_start
    mov x2, #6
    svc #0


    adr x1, res_moda
    bl write_ascii_value
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_moda_end
    mov x2, #8
    svc #0
    
    ldp x29, x30, [sp], #16
    ret

write_varianza:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_varianza_start
    mov x2, #11
    svc #0
    

    adr x1, res_varianza
    bl write_ascii_value
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_varianza_end
    mov x2, #13
    svc #0
    
    ldp x29, x30, [sp], #16
    ret

write_desviacion:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_desviacion_start
    mov x2, #13
    svc #0
    

    adr x1, res_desv
    bl write_ascii_value
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_desviacion_end
    mov x2, #15
    svc #0
    
    ldp x29, x30, [sp], #16
    ret

write_minimo:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_minimo_start
    mov x2, #8
    svc #0
    

    adr x1, resultado_minimo
    bl write_ascii_value
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_minimo_end
    mov x2, #10
    svc #0
    
    ldp x29, x30, [sp], #16
    ret

write_maximo:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_maximo_start
    mov x2, #8
    svc #0

    
    adr x1, resultado_maximo
    bl write_ascii_value
    
    mov x8, #64
    mov x0, x19
    adr x1, xml_maximo_end
    mov x2, #10
    svc #0
    
    ldp x29, x30, [sp], #16
    ret

// Función para escribir valor ASCII y calcular su longitud
write_ascii_value:
    // x1 = dirección del string ASCII
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Calcular longitud del string ASCII
    bl get_ascii_length
    
    // Escribir el valor
    mov x8, #64
    mov x0, x19
    // x1 ya contiene la dirección
    mov x2, x0                // x0 contiene la longitud
    svc #0
    
    ldp x29, x30, [sp], #16
    ret

// Función para calcular longitud de string ASCII
get_ascii_length:
    // x1 = dirección del string
    // Retorna longitud en x0
    mov x0, #0
    
length_loop:
    ldrb w2, [x1, x0]
    cbz w2, length_done       // Si es null terminator, salir
    cmp w2, #10               // Si es newline, salir
    beq length_done
    cmp w2, #13               // Si es carriage return, salir  
    beq length_done
    add x0, x0, #1
    cmp x0, #20               // Límite de seguridad
    blt length_loop
    
length_done:
    ret

error_exit:
    mov x0, #1
    b exit_clean

exit_clean:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

salir:
    mov x0, #0
    b exit_clean
    