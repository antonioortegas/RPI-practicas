.include "0configuration.inc"
.include "0inter.inc"

				/* 10987654321098765432109876543210 */
	ldr r1, = 0b00001000010000000000000000000000
	str r1, [r0, #GPSET0]
readbutton:
	ldr r2, [r0, #GPLEV0]
				  /* 10987654321098765432109876543210 */
	tst r2, #0b00000000000000000000000000000100
	beq buttonone
				  /* 10987654321098765432109876543210 */
	tst r2, #0b00000000000000000000000000001000
	beq buttontwo
	b readbutton

buttonone:
				  /* 10987654321098765432109876543210 */
	mov r1, #0b00001000000000000000000000000000
	str r1, [r0, #GPCLR0]
	mov r1, #0b00000000010000000000000000000000
	str r1, [r0, #GPSET0]
	b readbutton

buttontwo:
			   /* 10987654321098765432109876543210 */
	ldr r1, =0b00000000010000000000000000000000
	str r1, [r0, #GPCLR0]
	ldr r1, =0b00001000000000000000000000000000
	str r1, [r0, #GPSET0]
	b readbutton
	