#define csd_LED_ADDR 0x41200000

.extern led_delay
.global main

main:

	ldr r10, =csd_LED_ADDR 			// r10 = led base address
	mov r4, #1						// r4 = specific led address value for turn on led

loop:
	str r4, [r10]					// turn on current led
	bl led_delay					// branch to led_dealy function in main.c

	lsl r4, r4, #1					// logical shift left for next led. each led charge 1-bit
	cmp r4, #0x100					// compare r4 with 0x100 to check all led is turned on. led 7 is 0x80
	movge r4, #1					// if r4 is greater than or equal with 0x100, r4 = 1(first led's address)
	b loop							// loop
