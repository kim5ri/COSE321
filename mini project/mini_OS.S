#include "csd_zynq_peripherals.h"
#include "uart_regs.h"
#include "uart_init.s"

#define	TIMER_INITIAL	333000

.align 5

csd_vector_table:
	b .
	b .
	b .
	b .
	b .
	b .
	b csd_IRQ_ISR
	b .

.global main
main:
	// disable interrupt(CPSR의 I = 1)
	cpsID i

	cps #0x12	   	       // IRQ mode
	ldr	r13,=irq_stack_top // Stack pointer setup for IRQ mode

	cps #0x13	            // supervisor mode

	//set VBAR to vector table
	ldr     r0, =csd_vector_table
	mcr     p15, 0, r0, c12, c0, 0
	dsb
	isb

	// enable interrupt
	cpsIE i




	/* ----------------- GIC setup(bigin) ----------------- */

	// Distributor Control Register
	ldr r0, =GICD_CTLR
	ldr r1, [r0]
	mov r2, #1				//enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	 // Interrupt Set-Enable Register 0
	ldr r0, =GICD_ISENABLER0
	ldr r1, [r0]
	mov r2, #1 << 29		// Enable #29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// Interrupt Priority Register #7
	ldr r0, =GICD_PRIOR7
	ldr r1, [r0]
	mov r2, #0x10 << 8    	// Priority 16 for ID# 29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// CPU Interface Control Register
	ldr r0, =GICC_CTLR
	ldr r1, [r0]
	mov r2, #1        		// Enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

 	// CPU Interface Interrupt Priority Mask Register
	ldr r0, =GICC_PMR
	ldr r1, [r0]
	mov r2, #0xFF     		// Lowest
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	/* ----------------- GIC setup(end) ----------------- */



	/* ----------------- private timer setup(begin) ----------------- */

	// Private Timer setup
	ldr r0, =PRIVATE_LOAD
 	ldr r1, =TIMER_INITIAL
 	str r1, [r0]

  	ldr r0, =PRIVATE_CONTROL
 	mov r1, #9 << 8   			// Prescalar
 	orr r1, r1, #7
 	str r1, [r0]
	/* ----------------- private timer setup(end) ----------------- */

	/* ----------------- UART configuration(begin) ----------------- */

	// UART initialize
	UART_init

	// UART console address
	ldr r11, =uart_TX_RX_FIFO0
	ldr r12, =uart_Channel_sts_reg0

TX_check:
	ldr r1, [r12]
	and r1, r1, #0x8
	cmp r1, #0x8
	bne TX_check

	/* ----------------- UART configuration(end) ----------------- */

	/* ----------------- TCB setup(begin) ----------------- */
	ldr r0, =t1_reg
	ldr r1, =t1_stack_top
	ldr r2, =t1_TCB

	add r0, r0, #52				// r13 = sp address
	str r1, [r0]

	mrs r3, cpsr				// read CPSR
	bic r3, r3, #0x1f			// remove CPSR's mode bit
	orr r3, r3, #0x10			// user mode set
	str r3, [r2]				// store to SPSR

	add r2, r2, #4
	ldr r3, =task1_c
	str r3, [r2]



	ldr r0, =t2_reg
	ldr r1, =t2_stack_top
	ldr r2, =t2_TCB

	add r0, r0, #52				// r13 = sp address
	str r1, [r0]

	mrs r3, cpsr				// read CPSR
	bic r3, r3, #0x1f			// remove CPSR's mode bit
	orr r3, r3, #0x10			// user mode set
	str r3, [r2]				// store to SPSR

	add r2, r2, #4
	ldr r3, =task2_c
	add r3, r3, #4
	str r3, [r2]



	ldr r0, =t3_reg
	ldr r1, =t3_stack_top
	ldr r2, =t3_TCB

	add r0, r0, #52				// r13 = sp address
	str r1, [r0]

	mrs r3, cpsr				// read CPSR
	bic r3, r3, #0x1f			// remove CPSR's mode bit
	orr r3, r3, #0x10			// user mode set
	str r3, [r2]				// store to SPSR

	add r2, r2, #4
	ldr r3, =task3_c
	add r3, r3, #4
	str r3, [r2]

/* ----------------- TCB setup(end) ----------------- */



// start application //

	cps #0x10 					// user mode
	b task1_c



/* ----------------- ISR(begin) ----------------- */

csd_IRQ_ISR:
	ldr sp, =irq_stack_top
	stmfd sp!, {r0-lr}^			// use ^ to access user mode register
	mrs r10, spsr
	mov r11, lr

	// 라운드로빈 flag는 0, 1, 2 순으로 task 1, 2, 3
	ldr r1, = RR_flag
	ldr r2, [r1]

	cmp r2, #0
	beq t1

	cmp r2, #1
	beq t2

	cmp r2, #2
	beq t3


t1:
	ldr r5, =t1_TCB
	str r10, [r5]				// SPSR store
	add r5, r5, #4
	str r11, [r5]				// lr(return address) store

	ldmfd sp!, {r0-r11}			// register load from irq stack
	mov r12, sp					// store stack pointer to r12
	ldr sp, =t1_reg				// t1 register TCB pointer -> sp
	stmia sp, {r0-r11}			// store register to TCB

	mov sp, r12					// irq sp(in r12) -> sp
	ldmfd sp!, {r0-r2}			// load r12, r13, r14
	ldr r10, =t1_reg
	add r10, r10, #48			// r10 = t1 TCB pointer(12개 저장했으므로 +48)
	mov sp, r10					// sp = r10
	stmia sp, {r0-r2}			// store r12, 13, r14 to TCB

	ldr r1, =RR_flag
	mov r2, #1
	str r2, [r1]

	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]

	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]

 	// EOI(to task 2)
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldr r5, =t2_TCB
	ldr r10, [r5]
	msr spsr, r10
	add r5, r5, #4

	ldr lr, [r5]
	ldr sp, =t2_reg
	ldmfd sp, {r0-lr}^
	subs pc, lr, #4 			// t2 실행


t2:
	ldr r5, =t2_TCB
	str r10, [r5]				// SPSR store
	add r5, r5, #4
	str r11, [r5]				// lr(return address) store

	ldmfd sp!, {r0-r11}			// register load from irq stack
	mov r12, sp					// store stack pointer to r12
	ldr sp, =t2_reg				// t1 register TCB pointer -> sp
	stmia sp, {r0-r11}			// store register to TCB

	mov sp, r12					// irq sp(in r12) -> sp
	ldmfd sp!, {r0-r2}			// load r12, r13, r14
	ldr r10, =t2_reg
	add r10, r10, #48			// r10 = t1 TCB pointer(12개 저장했으므로 +48)
	mov sp, r10					// sp = r10
	stmia sp, {r0-r2}			// store r12, 13, r14 to TCB

	ldr r1, =RR_flag
	mov r2, #2
	str r2, [r1]

	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]

	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]

 	// EOI(to task 3)
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldr r5, =t3_TCB
	ldr r10, [r5]
	msr spsr, r10
	add r5, r5, #4

	ldr lr, [r5]
	ldr sp, =t3_reg
	ldmfd sp, {r0-lr}^
	subs pc, lr, #4

t3:
	ldr r5, =t3_TCB
	str r10, [r5]				// SPSR store
	add r5, r5, #4
	str r11, [r5]				// lr(return address) store

	ldmfd sp!, {r0-r11}			// register load from irq stack
	mov r12, sp					// store stack pointer to r12
	ldr sp, =t3_reg				// t1 register TCB pointer -> sp
	stmia sp, {r0-r11}			// store register to TCB

	mov sp, r12					// irq sp(in r12) -> sp
	ldmfd sp!, {r0-r2}			// load r12, r13, r14
	ldr r10, =t3_reg
	add r10, r10, #48			// r10 = t1 TCB pointer(12개 저장했으므로 +48)
	mov sp, r10					// sp = r10
	stmia sp, {r0-r2}			// store r12, 13, r14 to TCB

	ldr r1, =RR_flag
	mov r2, #0
	str r2, [r1]

	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]

	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]

 	// EOI(to task 1)
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldr r5, =t1_TCB
	ldr r10, [r5]
	msr spsr, r10
	add r5, r5, #4

	ldr lr, [r5]
	ldr sp, =t1_reg
	ldmfd sp, {r0-lr}^
	subs pc, lr, #4


/* ----------------- ISR(end) ----------------- */

.data
.align 4

irq_stack:	.space 1024
irq_stack_top:

t1_stack:	.space 1024
t1_stack_top:

t2_stack:	.space 1024
t2_stack_top:

t3_stack:	.space 1024
t3_stack_top:

// SPSR, lr to TCB
// r0 ~ r14 to reg
t1_TCB:
	.word 	0, 0
t1_reg:
	.word 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

t2_TCB:
	.word 	0, 0
t2_reg:
	.word 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

t3_TCB:
	.word 	0, 0
t3_reg:
	.word 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

RR_flag:
	.word 	0



