.include "0configuration.inc"
.include "0inter.inc"

	ldr r0, =GPBASE
               /* xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000001000000
	str r1, [r0, #GPFSEL2]
               /* 10987654321098765432109876543210 */
	ldr r1, =0b00001000000000000000000000000000
   

    ldr r2, =STBASE
loop:
    ldr r3, =500000
    bl espera
    str r1, [r0, #GPSET0]
    bl espera
    str r1, [r0, #GPCLR0]
    
    ldr r3, =250000
    bl espera
    str r1, [r0, #GPSET0]
    bl espera
    str r1, [r0, #GPCLR0]
    
    ldr r3, =125000
    bl espera
    str r1, [r0, #GPSET0]
    bl espera
    str r1, [r0, #GPCLR0]
    
    ldr r3, =250000
    bl espera
    str r1, [r0, #GPSET0]
    bl espera
    str r1, [r0, #GPCLR0]
    
    b loop
espera:
    ldr r4, [r2, #STCLO]
    add r4, r3
ret1:
    ldr r5, [r2, #STCLO]
    cmp r5, r4
    blo ret1
    bx lr