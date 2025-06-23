// ------------------------------------------
//  Author: Prof. Taeweon Suh
//          Computer Science & Engineering
//          College of Informatics, Korea Univ.
//  Date:   May 06, 2020
// ------------------------------------------

#include "csd_zynq_peripherals.h"

// Vector table base location should be aligned at 2^5
.align 5
// --------------------------
// Our interrupt vector table
// --------------------------
csd_vector_table:
	b csd_reset
	b csd_undefined
	b csd_software_interrupt
	b csd_prefetch
	b csd_data
	b csd_not_used
	b csd_irq
	b csd_fiq

.global main
main:

	// -------------------------------------
	// Set VBAR (Vector Base Address Register) to 
	// the base location of our interrupt vector table
	// -------------------------------------
	ldr     r0, =csd_vector_table
	mcr     p15, 0, r0, c12, c0, 0
	dsb
	isb

	mrs	r0, cpsr			// Read CPSR
	mvn	r1, #0x1f		// Clear M[4:0] in CPSR 
	and	r2, r1, r0
	orr	r2, r2, #0x13	// 0x13: Supervisor (SVC) mode
	msr	cpsr, r2       // Change to SVC mode
	ldr	r13, =svc_stack_top	// Set SVC mode's SP

	cpsie aif,  #0x10		// Change to User Mode
	                		// Enable A, I, F

forever:
	svc #10
	nop
	b forever


// -----------------------
// Software Interrupt ISR
// -----------------------
csd_software_interrupt:

	// Push CPU context to SVC Stack
	stmfd sp!, {r0-r12}

 	// Toggle LEDs connected to GPIO
	ldr  r0, =csd_LED_ADDR
	ldr  r1, =led_initial
	ldr  r2, [r1]
	eor  r2, r2, #0xFF  // toggle the data
	strb r2,[r0]        // turn on LEDs
	str  r2, [r1]       // store a new value to led_initial

	// Pop CPU context from SVC Stack
	ldmfd sp!, {r0-r12}

	// Return to the User Program
	movs  pc, lr

// -------------------------------
// The other interrupt & Exception
// -------------------------------
csd_reset:
csd_undefined:
csd_prefetch:
csd_data:
csd_not_used:
csd_irq:
csd_fiq:
	b .


.data
.align 4

svc_stack:     .space 1024
svc_stack_top:

led_initial: .word 0xC3
