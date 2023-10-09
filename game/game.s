	.include "0gpioconf.inc"		@# GPIO setup, configures all GPIOs correctly as input ot output
	.include "0offsets.inc"			@# Offset values for GPIO ports and Interruptions macro
	.include "0model3b.inc"		@# Only necessary if using later version of RPI, to set mode to SVC from HYP
	.include "0interruptionsconf.inc"	@# Basic configuration instructions to allow both IRQ and FIQ interruptions
	
	# We will use r0 as a function parameter to pass values between routines
	# We will use r1 to r7 as general data operation registers
	
	# When including function files:
		# variableName: possible values
			# indicates the file has a variable .word with that name
			# the possible values it can take will be passed by r0
		# function (parameter)
			# the name of the function, accesible by "bl function"
			# parameter the function needs, given by r0
		# function
			# a function also accesible by "bl function"
			# does not need a parameter
	
.text
	b main @#This is here just so we can include external functions and variables at the top instead of at the end of the file

	.include "0leds.inc" // Functions for led control
	# led: 9/10/11/17/22/27
	# turnonled (led GPIO)
	# turnoffled (led GPIO)
	# turnoffleds
	
main:
	
	ldr r0, =9
	bl turnonled
	
	ldr r0, =22
	bl turnonled
	
	bl turnoffleds
	
	ldr r0, =17
	bl turnonled
	
	loop : b loop



irq_handler:
	push {r1, r2}
	
	# does nothing for now
	
	pop {r1, r2}
	subs pc, lr, #4
	
	
	
fiq_handler:
	push {r1, r2}
	
	# does nothing for now
	
	pop {r1, r2}
	subs pc, lr, #4
	