# ARM64 Assembly - Recordatorio Básico

## Registros

### Registros de Propósito General
- **x0-x30**: Registros de 64 bits
- **w0-w30**: Registros de 32 bits (parte baja de x0-x30)
- **x29 (fp)**: Frame pointer
- **x30 (lr)**: Link register (dirección de retorno)
- **sp**: Stack pointer
- **pc**: Program counter

### Registros Especiales para Argumentos/Retorno
- **x0-x7**: Argumentos de función y valores de retorno
- **x8**: Registro indirecto de retorno (para structs grandes)
- **x9-x15**: Registros temporales
- **x16-x17**: Registros de llamada intra-procedimiento
- **x18**: Registro reservado por plataforma
- **x19-x28**: Registros callee-saved

## Instrucciones Básicas

### Movimiento de Datos
```assembly
mov  x0, x1        // x0 = x1
mov  x0, #42       // x0 = 42 (inmediato)
movz x0, #0x1234   // x0 = 0x1234 (limpiar otros bits)
movk x0, #0x5678, lsl #16  // x0 |= 0x5678 << 16
```

### Carga y Almacenamiento
```assembly
ldr  x0, [x1]      // x0 = *x1
ldr  x0, [x1, #8]  // x0 = *(x1 + 8)
ldr  x0, [x1, x2]  // x0 = *(x1 + x2)
str  x0, [x1]      // *x1 = x0
str  x0, [x1, #8]  // *(x1 + 8) = x0

ldp  x0, x1, [x2]  // Cargar par: x0 = *x2, x1 = *(x2+8)
stp  x0, x1, [x2]  // Almacenar par: *x2 = x0, *(x2+8) = x1
```

### Operaciones Aritméticas
```assembly
add  x0, x1, x2    // x0 = x1 + x2
add  x0, x1, #10   // x0 = x1 + 10
sub  x0, x1, x2    // x0 = x1 - x2
mul  x0, x1, x2    // x0 = x1 * x2
sdiv x0, x1, x2    // x0 = x1 / x2 (con signo)
udiv x0, x1, x2    // x0 = x1 / x2 (sin signo)
```

### Operaciones Lógicas
```assembly
and  x0, x1, x2    // x0 = x1 & x2
orr  x0, x1, x2    // x0 = x1 | x2
eor  x0, x1, x2    // x0 = x1 ^ x2
mvn  x0, x1        // x0 = ~x1
```

### Desplazamientos
```assembly
lsl  x0, x1, #2    // x0 = x1 << 2
lsr  x0, x1, #2    // x0 = x1 >> 2 (lógico)
asr  x0, x1, #2    // x0 = x1 >> 2 (aritmético)
ror  x0, x1, #2    // x0 = rotar x1 a la derecha 2 bits
```

## Comparaciones y Saltos

### Comparaciones
```assembly
cmp  x0, x1        // Comparar x0 con x1
cmp  x0, #42       // Comparar x0 con 42
tst  x0, x1        // Test (AND) x0 con x1
```

### Saltos Condicionales
```assembly
b    label         // Salto incondicional
beq  label         // Salto si igual (Zero flag set)
bne  label         // Salto si no igual (Zero flag clear)
blt  label         // Salto si menor (con signo)
ble  label         // Salto si menor o igual (con signo)
bgt  label         // Salto si mayor (con signo)
bge  label         // Salto si mayor o igual (con signo)
blo  label         // Salto si menor (sin signo)
bls  label         // Salto si menor o igual (sin signo)
bhi  label         // Salto si mayor (sin signo)
bhs  label         // Salto si mayor o igual (sin signo)
```

### Llamadas a Funciones
```assembly
bl   function      // Branch with link (llamar función)
blr  x0            // Branch with link register
ret                // Retorno (equivale a br lr)
br   x0            // Branch register
```

## Estructura de Programa

### Plantilla Básica
```assembly
.global _start

.text
_start:
    // Código principal
    mov x0, #0          // Código de salida
    mov x8, #93         // Syscall exit
    svc #0              // System call

.data
    // Datos inicializados

.bss
    // Datos no inicializados
```

### Definición de Función
```assembly
.global my_function
my_function:
    // Prólogo
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Cuerpo de la función
    // x0-x7 contienen argumentos
    // Retornar valor en x0
    
    // Epílogo
    ldp x29, x30, [sp], #16
    ret
```

## Syscalls Linux Comunes

```assembly
// Syscall numbers para ARM64 Linux
mov x8, #63         // read
mov x8, #64         // write  
mov x8, #93         // exit
mov x8, #56         // openat
mov x8, #57         // close
mov x8, #222        // mmap
mov x8, #215        // munmap

// Ejemplo: write(1, buffer, length)
mov x0, #1          // stdout
ldr x1, =buffer     // dirección del buffer
mov x2, #13         // longitud
mov x8, #64         // syscall write
svc #0              // system call
```

## Direccionamiento

### Modos de Direccionamiento
```assembly
ldr x0, [x1]           // Directo: x0 = *x1
ldr x0, [x1, #8]       // Offset: x0 = *(x1 + 8)
ldr x0, [x1, x2]       // Indexado: x0 = *(x1 + x2)
ldr x0, [x1, x2, lsl #3] // Indexado escalado: x0 = *(x1 + x2*8)
ldr x0, [x1, #8]!      // Pre-indexado: x1 += 8, x0 = *x1
ldr x0, [x1], #8       // Post-indexado: x0 = *x1, x1 += 8
```

### Carga de Direcciones
```assembly
adr  x0, label      // x0 = dirección de label (PC-relativa)
adrp x0, label      // x0 = página de label
ldr  x0, =value     // Pseudo-instrucción para cargar constante
```

## Flags de Condición (NZCV)

- **N**: Negative (resultado negativo)
- **Z**: Zero (resultado cero)
- **C**: Carry (acarreo en suma, no-borrow en resta)
- **V**: Overflow (desbordamiento con signo)

## Tamaños de Datos

- **byte**: 8 bits
- **halfword**: 16 bits  
- **word**: 32 bits
- **doubleword**: 64 bits

### Instrucciones por Tamaño
```assembly
ldrb w0, [x1]       // Cargar byte
ldrh w0, [x1]       // Cargar halfword
ldr  w0, [x1]       // Cargar word (32-bit)
ldr  x0, [x1]       // Cargar doubleword (64-bit)
```

## Consejos Rápidos

1. **Alineación**: Las direcciones deben estar alineadas (4 bytes para word, 8 para doubleword)
2. **Stack**: Crece hacia abajo, siempre mantener SP alineado a 16 bytes
3. **Calling Convention**: Primeros 8 argumentos en x0-x7, resto en stack
4. **Callee-saved**: x19-x28 deben preservarse en funciones
5. **Immediate values**: Limitados según la instrucción, usar MOV para valores grandes