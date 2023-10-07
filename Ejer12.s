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
	
	mov r1, #0b00000000000000000000000000001100
	str r1, [r0, #GPFEN0]
	
	ldr r0, =INTBASE
	mov r1, #0b00000000000100000000000000000000
	str r1, [r0, #INTENIRQ2]
	
	mov r0, #0b01010011 @ SVC mode, IRQ enabled
	msr cpsr_c, r0
buc: b buc

irq_handler:
	push {r0, r1, r2, r3}
	ldr r0, =GPBASE
	
	ldr r2, [r0, #GPEDS0]
	ands r2, #0b00000000000000000000000000000100
		      /*xx10987654321098765432109876543210*/
	movne r1, #0b00000000010000000000000000000000
	strne r1, [r0, #GPSET0]
		    /*xx10987654321098765432109876543210*/
	ldrne r1, =0b00001000000000000000000000000000
	strne r1, [r0, #GPCLR0]
	movne r1, #0b00000000000000000000000000000100
	strne r1, [r0, #GPEDS0]
	
	ldr r2, [r0, #GPEDS0]
	ands r2, #0b00000000000000000000000000001000
		      /*xx10987654321098765432109876543210*/
	movne r1, #0b00001000000000000000000000000000
	strne r1, [r0, #GPSET0]
		    /*xx10987654321098765432109876543210*/
	ldrne r1, =0b00000000010000000000000000000000
	strne r1, [r0, #GPCLR0]
	movne r1, #0b00000000000000000000000000001000
	strne r1, [r0, #GPEDS0]
	
	pop {r0, r1, r2, r3}
	subs pc, lr, #4
