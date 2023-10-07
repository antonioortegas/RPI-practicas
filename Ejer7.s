.include "0configuration.inc"
.include "0inter.inc"

                /*xx10987654321098765432109876543210 */
	mov r1, #0b00000000000000000000000000010000
	ldr r0, =GPBASE
	ldr r2, =STBASE
    
readbuttons:
	ldr r5, [r0, #GPLEV0]
            /*xx10987654321098765432109876543210*/
	tst r5, #0b00000000000000000000000000000100
	beq playdo
	tst r5, #0b00000000000000000000000000001000
	beq playre
	b readbuttons

playdo:
	ldr r3, =1433
	b play
playre:
	ldr r3, =1136
	b play

play:
	bl espera
	str r1, [r0, #GPSET0]
	bl espera
	str r1, [r0, #GPCLR0]
	beq readbuttons
espera:
	ldr r4, [r2, #STCLO]
	add r4, r3
ret1:
	ldr r5, [r2, #STCLO]
	cmp r5, r4
	blo ret1
	bx lr
