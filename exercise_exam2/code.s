.global _start

.data
string: .ascii "aeiou"

.text
_start:
    // Cargar la dirección de la cadena "aeiou" en X0
    ldr x0, =string
    
    // Cargar cada byte de la cadena en X1 a X5 (usando registros w para ldrb)
    ldrb w1, [x0]        // Carga 'a' (ASCII 97) en W1 (que se extiende a X1)
    ldrb w2, [x0, #1]    // Carga 'e' (ASCII 101) en W2 (que se extiende a X2)
    ldrb w3, [x0, #2]    // Carga 'i' (ASCII 105) en W3 (que se extiende a X3)
    ldrb w4, [x0, #3]    // Carga 'o' (ASCII 111) en W4 (que se extiende a X4)
    ldrb w5, [x0, #4]    // Carga 'u' (ASCII 117) en W5 (que se extiende a X5)
    
    // Ejecutar la operación SUB X0, X2, X3
    // X0 = X2 - X3 = 101 - 105 = -4
    sub x0, x2, x3
    
    // Terminar el programa
    mov x8, #93          // sys_exit
    //mov x0, w1           // status code
    svc #0
