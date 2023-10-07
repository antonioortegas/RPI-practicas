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
	ldr r1, =0b00001000000000000001000000000000
	str r1, [r0, #GPFSEL0]
	ldr r1, =0b00000000001000000000000000001001
	str r1, [r0, #GPFSEL1]
	ldr r1, =0b00000000001000000000000001000000
	str r1, [r0, #GPFSEL2]
	
	ldr r0, =STBASE
	ldr r1, [r0, #STCLO]
	add r1, #0x50000
	str r1, [r0, #STC1]
	str r1, [r0, #STC3]
	
	ldr r0, =INTBASE
	ldr r1, =0b0010
	str r1, [r0, #INTENIRQ1]
	mov r1, #0b10000011
	str r1, [r0, #INTFIQCON]
	
	ldr r0, =0b00010011
	msr cpsr_c, r0
loop: b loop

fiq_handler:
	push {r0, r1, r2}
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
	b selectnote

irq_handler:
	push {r0, r1, r2}
	
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
	
	ldr r1, =note
	ldr r2, [r1]
	cmp r2, #25
	addne r2, #1
	ldreq r2, =1
	str r2, [r1]
	
	ldr r0, =STBASE
	mov r1, #0b0010
	str r1, [r0, #STCS]
	
	ldr r1, [r0, #STCLO]
	add r1, #0x50000
	str r1, [r0, #STC1]
	b finish

selectnote:
	push {r0, r1, r2}
	ldr r0, =STBASE
	ldr r1, =note
	ldr r2, [r1]
	cmp r2, #1
	ldreq r1, =1706
	cmp r2, #2
	ldreq r1, =1706
	cmp r2, #3
	ldreq r1, =1515
	cmp r2, #4
	ldreq r1, =1706
	cmp r2, #5
	ldreq r1, =1275
	cmp r2, #6
	ldreq r1, =1351
	cmp r2, #7
	ldreq r1, =1706
	cmp r2, #8
	ldreq r1, =1706
	cmp r2, #9
	ldreq r1, =1515
	cmp r2, #10
	ldreq r1, =1706
	cmp r2, #11
	ldreq r1, =1136
	cmp r2, #12
	ldreq r1, =1275
	cmp r2, #13
	ldreq r1, =1706
	cmp r2, #14
	ldreq r1, =1706
	cmp r2, #15
	ldreq r1, =851
	cmp r2, #16
	ldreq r1, =1012
	cmp r2, #17
	ldreq r1, =1275
	cmp r2, #18
	ldreq r1, =1351
	cmp r2, #19
	ldreq r1, =1515
	cmp r2, #20
	ldreq r1, =956
	cmp r2, #21
	ldreq r1, =956
	cmp r2, #22
	ldreq r1, =1012
	cmp r2, #23
	ldreq r1, =1275
	cmp r2, #24
	ldreq r1, =1136
	cmp r2, #25
	ldreq r1, =1275
	
	ldr r2, [r0, #STCLO]
	add r2, r1
	str r2, [r0, #STC3]
	pop {r0, r1, r2}
	b finish
	
finish:
	pop {r0, r1, r2}
	subs pc, lr, #4

onoff: .word 6
note: .word 1
sound: .word 0
	