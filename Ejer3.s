.include "0configuration.inc"
.include "0inter.inc"

	.set GPBASE, 0x3F200000
	.set GPFSEL2, 0x08
	.set GPSET0, 0x1c

	ldr r0, =GPBASE
		    /* xx999888777666555444333222111000 */
	mov r1, #0b00000000000000000000000001000000
	str r1, [r0, #GPFSEL2]
				  /* 10987654321098765432109876543210 */
	mov r1, #0b00000000010000000000000000000000
encender:
		    
	str r1, [r0, #GPSET0]
    b apagar

apagar:
    str r1, [r0, #GPCLR0]
    b encender