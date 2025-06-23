#include "csd_zynq_peripherals.h"
#include "uart_regs.h"
#include "uart_init.s"

// private timer clock이 333MHz, prescalar이 9(+1)이므로 timer initial을 33300000으로 설정
#define	TIMER_INITIAL	0x01FC1E20

.align 5

// only need IRQ interrupt
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

	cpsID i

	cps #0x12	   	       // IRQ mode 
	ldr	r13,=irq_stack_top // Stack pointer setup for IRQ mode

	cps #0x1F	            // SYS mode

	ldr     r0, =csd_vector_table
	mcr     p15, 0, r0, c12, c0, 0
	dsb
	isb

	cpsIE i

	// GIC setup(info check)

	ldr r0, =GICC_IIDR
	ldr r3, [r0]

	ldr r0, =GICD_TYPER
	ldr r3, [r0]

	ldr r0, =GICC_BPR
	ldr r3, [r0]

	// GIC setup

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


	// Private Timer setup

	UART_init

	ldr r0, =PRIVATE_LOAD
 	ldr r1, =TIMER_INITIAL
 	str r1, [r0]

  	ldr r0, =PRIVATE_CONTROL
 	mov r1, #9 << 8   			// Prescalar
 	orr r1, r1, #7
 	str r1, [r0]

	ldr r0, =PRIVATE_COUNTER
	ldr r1, =PRIVATE_STATUS
	ldr r2, =GICD_ISPENDR0

	ldr r10, =uart_TX_RX_FIFO0
	ldr r11, =uart_Channel_sts_reg0

TX_init:
	ldr r12, [r11]
	and r12, r12, #0x8
	cmp r12, #0x8
	bne TX_init

	mov r12, #13
	strb r12, [r10]

	mov r12, #48
	strb r12, [r10]
	strb r12, [r10]

	mov r12, #58
	strb r12, [r10]

	mov r12, #48
	strb r12, [r10]
	strb r12, [r10]

	mov r12, #58
	strb r12, [r10]

	mov r12, #48
	strb r12, [r10]
	strb r12, [r10]


forever:
	ldr r5, [r0]
	ldr r6, [r1]
	ldr r7, [r2]
	b forever



// ISR of timer clock

csd_IRQ_ISR:

	stmfd sp!, {r0-r12, lr}

	ldr r0, =GICC_IAR
	ldr r9, [r0]

	bl time_info

	ldmia r0!, {r1-r6}
	add r1, r1, #48
	add r2, r2, #48
	add r3, r3, #48
	add r4, r4, #48
	add r5, r5, #48
	add r6, r6, #48

	mov r12, #13
	strb r12, [r10]

	strb r1, [r10]
	strb r2, [r10]

	mov r12, #58
	strb r12, [r10]

	strb r3, [r10]
	strb r4, [r10]

	mov r12, #58
	strb r12, [r10]

	strb r5, [r10]
	strb r6, [r10]

	// Clear Interrupt Status bit
 	ldr r0, =PRIVATE_STATUS
 	mov r1, #1
	str r1, [r0]

	// End-of-Interrupt
 	ldr r0, =GICC_EOIR
	str r9, [r0]

	ldmfd sp!, {r0-r12, lr}
	subs pc, lr, #4

// ----------------------------
// Interrupt Service Routines (ISRs) - End
// ----------------------------

.data
.align 4

irq_stack:     .space 1024
irq_stack_top:

