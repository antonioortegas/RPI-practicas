	.include "0inter.inc"
.text
	mrs r0, cpsr
	mov r0, #0b11010011 @Modo SVC, FIQ&IRQ desact
	msr spsr_cxsf, r0
	add r0, pc, #4
	msr ELR_hyp, r0
	eret
	
	mov r0, #0
	ADDEXC 0x18, irq_handler
	
	mov r0, #0b11010010
	msr cpsr_c, r0
	mov sp, #0x8000
	
	mov r0, #0b01010011
	msr cpsr_c, r0
	mov sp, #0x8000000
	ldr r0, =GPBASE
	ldr r1, =0b00001000000000000001000000000000
	str r1, [r0, #GPFSEL0]
	ldr r1, =0b00000000001000000000000000001001
	str r1, [r0, #GPFSEL1]
	ldr r1, =0b00000000001000000000000001000000
	str r1, [r0, #GPFSEL2]
	
	ldr r0, =STBASE
	ldr r1, [r0, #STCLO]
	add r1, #0x20000
	str r1, [r0, #STC1]
	str r1, [r0, #STC3]
	
	ldr r0, =INTBASE
	ldr r1, =0b1010
	str r1, [r0, #INTENIRQ1]
	
	ldr r0, =0b01010011
	msr cpsr_c, r0
loop: b loop

irq_handler:
	push {r0, r1, r2}
	
	ldr r0, =STBASE
	ldr r1 , [r0, #STCS]
	cmp r1, #0b1000
	beq play
	
	ldr r0, =GPBASE
	ldr r1, =onoff
	ldr r2, [r1]
	cmp r2, #6
	addne r2, #1
	ldreq r2, =1
	str r2, [r1]
	
	ldr r1, =	0b11111111111111111111111111111111
	str r1, [r0, #GPCLR0]
	cmp r2, #6
	ldreq r1, =0b00000000000000000000001000000000
	cmp r2, #5
	ldreq r1, =0b00000000000000000000010000000000
	cmp r2, #4
	ldreq r1, =0b00000000000000000000100000000000
	cmp r2, #3
	ldreq r1, =0b00000000000000100000000000000000
	cmp r2, #2
	ldreq r1, =0b00000000010000000000000000000000
	cmp r2, #1
	ldreq r1, =0b00001000000000000000000000000000
	str r1, [r0, #GPSET0]
	
	ldr r0, =STBASE
	mov r1, #0b0010
	str r1, [r0, #STCS]
	
	ldr r1, [r0, #STCLO]
	add r1, #0x20000
	str r1, [r0, #STC1]
	b finish
	
play:
	ldr r0, =GPBASE
	ldr r1, =sound
	ldr r2, [r1]
	eors r2, #1
	str r2, [r1]
	mov r1, #0b00000000000000000000000000010000
	streq r1, [r0, #GPSET0]
	strne r1, [r0, #GPCLR0]
	
	ldr r0, =STBASE
	mov r1, #0b1000
	str r1, [r0, #STCS]
	ldr r2, [r0, #STCLO]
	ldr r1, =1136
	add r2, r1
	str r2, [r0, #STC3]
	b finish

finish:
	pop {r0, r1, r2}
	subs pc, lr, #4

onoff: .word 6
sound: .word 0
	