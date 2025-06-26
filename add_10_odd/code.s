.global _start
_start:
    mov x0, #5
    mov x1, #10
    mov x2, #8
    mov x3, #5
    mov x4, #9
    mov x5, #11
    mov x6, #13
    mov x7, #15
    mov x8, #17
    mov x9, #19
    mov x10, #22

    add x0 , x0, x1
    add x0 , x0, x2
    add x0 , x0, x3
    add x0 , x0, x4
    add x0 , x0, x5
    add x0 , x0, x6
    add x0 , x0, x7
    add x0 , x0, x8
    add x0 , x0, x9
    add x0 , x0, x10

if:
    ands x0,x0,1
    beq else

    mov x0,1
    ldr x1, =odd_msg
    mov x2, 20
    mov x8, 64
    svc 0
    b endif
    
    

else:
    mov x0,1
    ldr x1, =even_msg
    mov x2, 20
    mov x8, 64
    svc 0

endif:
    mov x0, 0
    mov x8, 93  // syscall number for exit
    svc 0

.data
odd_msg: .asciz "The result is odd\n"
even_msg: .asciz "The result is even\n"