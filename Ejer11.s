.include "0configuration.inc"
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
	
	mov r0, #0b11010011
	msr cpsr_c, r0
	mov sp, #0x8000000
	
	ldr r0, =GPBASE
		   /* xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000001000000
	str r1, [r0, #GPFSEL2]
		   /* xx999888777666555444333222111000 */
	ldr r1, =0b00000000001000000000000000001001
	str r1, [r0, #GPFSEL1]
		   /* xx999888777666555444333222111000 */
	ldr r1, =0b00001000000000000000000001000000
	str r1, [r0, #GPFSEL0]
	
	ldr r0, =STBASE
	ldr r1, [r0, #STCLO]
	add r1, #0x50000
	str r1, [r0, #STC3]
	
	ldr r0, =INTBASE
	mov r1, #0b1000
	str r1, [r0, #INTENIRQ1]
	
	mov r0, #0b01010011 @ SVC mode, IRQ enabled
	msr cpsr_c, r0
buc: b buc

irq_handler:
	push {r0, r1, r2, r3}
	ldr r0, =GPBASE
	
	ldr r1, =onoff
	ldr r2, [r1]
	cmp r2, #6
	addne r2, #1
	ldreq r2, =1
	str r2, [r1]
	
	/*ldr r1, =0b00001000010000100000111000000000*/
	ldr r1, =0b00001000000000000000000000000000
	cmp r2, #1
	streq r1, [r0, #GPSET0]
	ldr r1, =0b00000000000000000000001000000000
	streq r1, [r0, #GPCLR0]
	
	ldr r1, =0b00000000010000000000000000000000
	cmp r2, #2
	streq r1, [r0, #GPSET0]
	ldr r1, =0b00001000000000000000000000000000
	streq r1, [r0, #GPCLR0]
	
	ldr r1, =0b00000000000000100000000000000000
	cmp r2, #3
	streq r1, [r0, #GPSET0]
	ldr r1, =0b00000000010000000000000000000000
	streq r1, [r0, #GPCLR0]
	
	ldr r1, =0b00000000000000000000100000000000
	cmp r2, #4
	streq r1, [r0, #GPSET0]
	ldr r1, =0b00000000000000100000000000000000
	streq r1, [r0, #GPCLR0]
	
	ldr r1, =0b00000000000000000000010000000000
	cmp r2, #5
	streq r1, [r0, #GPSET0]
	ldr r1, =0b00000000000000000000100000000000
	streq r1, [r0, #GPCLR0]
	
	ldr r1, =0b00000000000000000000001000000000
	cmp r2, #6
	streq r1, [r0, #GPSET0]
	ldr r1, =0b00000000000000000000010000000000
	streq r1, [r0, #GPCLR0]
	
	ldr r0, =STBASE
	mov r1, #0b1000
	str r1, [r0, #STCS]
	
	ldr r1, [r0, #STCLO]
	add r1, #0x50000
	str r1, [r0, #STC3]
	
	pop {r0, r1, r2, r3}
	subs pc, lr, #4

onoff: .word 6
