.text
	
	mov r0, #0
	ADDEXC 0x18, irq_handler
	ADDEXC 0x1c, fiq_handler	

	mov r0, #0b11010001
	msr cpsr_c, r0
	mov sp, #0x4000

	mov r0, #0b11010010
	msr cpsr_c, r0
	mov sp, #0x8000

	mov r0, #0b01010011
	msr cpsr_c, r0
	mov sp, #0x8000000

	ldr r0, =GPBASE
	mov r1, #0b00000000000000000000000000001100
	str r1, [r0, #GPFEN0]

	ldr r0, =INTBASE
	ldr r1, =0b1010
	str r1, [r0, #INTENIRQ1]

	mov r1, #0b10000011
	str r1, [r0, #INTFIQCON]

	ldr r0, =0b00010011
	msr cpsr_c, r0
