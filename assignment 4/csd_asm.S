#include "uart_regs.h"
#include "csd_debug.s"
#include "uart_init.s"
#include "print_register.s"

#define csd_LED_ADDR 0x41200000

.extern csd_main

.global main


main:
	UART_init
	print_register
	debug_register @1

	ldr r0, =src				// r0 = input_data memory address
	ldr r10, =dst				// r10 = output_data memory address
	mov r1, #0					// r1 = outside loop index number(repeat count)
	debug_register @2


loop_i:							// loop_i is outer loop of bubble sort(in C code, i is index of outer loop)
	mov r2, #31					// r2 = max repeat count of inner loop(innitiate with 31)
	sub r2, r2, r1				// inner loop bound
	mov r3, #0					// initiate repeat count of inner loop
	debug_register @3

loop_j:							// loop_j is inner loop of bubble sort(in C code, j is index of inner loop)
	mov r4, r0					// r4 = copy input data memory address
	add r4, r4, r3, LSL #2		// r4 + r3 left shift 2 = r3 * 4, current address of data will be compared
	ldr r5, [r4]				// r5 = data in address r4
	ldr r6, [r4, #4]			// r6 = data next to address r4
	debug_register @4

	cmp r5, r6					// compare two data
	ble no_swap					// if r5 <= r6 then no swap, branch
	debug_register @5
								// if r5 > r6 then swap r5 and r6 using r9
	mov r9, r5					// r5 -> r9
	mov r5, r6					// r5 -> r6
	mov r6, r9					// r6 -> r9
	str r5, [r4]				// store r5 to address r4
	str r6, [r4, #4]			// store r6 to address r4 + 4
	debug_register @6

	no_swap:					// no swap branch

	add r3, r3, #1				// add 1 to r3, loop repeat count +1
	cmp r3, r2					// compare r3, r2 to check loop end condition
	blt loop_j					// if r3 is less than r2, then repeat inner loop
	debug_register @7

	add r1, r1, #1				// the condition of inner loop is not satisfied which means inner loop ends, then +1 to r1(outer loop repeat count)
	cmp r1, #31					// compare r1 and 31 to cheak max repeat count of outer loop is satisfied
	ble loop_i					// if r1 is less or equal 31, keep sorting(repeat outer loop)
	debug_register @8

	mov r7, #0					// initiate r7 to copy

copy:
	ldr r8, [r0, r7, LSL #2]	// r8 -> data in address r0 + r7<<2(4 byte)
	str r8, [r10, r7, LSL #2]	// store r8 data to destination memory address
	add r7, r7, #1				// r7 + 1 to next address
	cmp r7, #32					// compare r7 and 32
	debug_register @9
	blt copy					// if r7 is smaller, loop copy
	debug_register @10
	bl csd_main

forever:
    nop
    b forever

.data
.align 4

src:
    .word 2, 0, -7, -1, 3, 8, -4, 10
    .word -9, -16, 15, 13, 1, 4, -3, 14
    .word -8, -10, -15, 6, -13, -5, 9, 12
    .word -11, -14, -6, 11, 5, 7, -2, -12

dst:
    .space 128    // 32 words × 4 bytes
