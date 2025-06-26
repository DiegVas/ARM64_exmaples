.global _start

_start:
    mov x0, #0          // Initialize x0 to 1 (likely a counter or result accumulator)
    mov x19, #1         // Initialize x19 to 1 (outer loop counter, 'i' in a typical for loop)

loop1:
    cmp x19, #50        // Compare x19 with 50
    b.gt endloop1       // If x19 > 50, branch to endloop1 (exit outer loop)

    mov x20, #1         // Initialize x20 to 1 (middle loop counter, 'j')

loop2:
    cmp x20, x19        // Compare x20 with x19
    b.gt endloop2       // If x20 >= x19, branch to endloop2 (exit middle loop)
    mov x21, x20        // Initialize x21 with x20 (inner loop counter, 'k')

loop3:
    cmp x21, x19        // Compare x21 with x19
    b.ge endloop3       // If x21 >= x19, branch to endloop3 (exit inner loop)

    mul x22, x19, x19   // x22 = x19 * x19
    mul x23, x20, x20   // x23 = x20 * x20
    mul x24, x21, x21   // x24 = x21 * x21
    add x25, x23, x24   // x25 = x23 + x24 (x25 = x20*x20 + x21*x21)

    cmp x22, x25        // Compare x22 with x25 (x19*x19 == x20*x20 + x21*x21 ?)
    b.ne skip           // If x22 != x25, branch to skip
    add x0, x0, #1      // If x22 == x25, increment x0

skip:
    add x21, x21, #1    // Increment x21
    b loop3             // Branch back to loop3

endloop3:
    add x20, x20, #1    // Increment x20
    b loop2             // Branch back to loop2

endloop2:            // Call system service (exit)
    add x19, x19, #1    // Increment x19
    b loop1             // Branch back to loop1

endloop1:    // Set x0 to 0 (exit code)
    mov x8, #93         // Set x8 to 93 (syscall number for exit)
    svc #0              // Call system service (exit)