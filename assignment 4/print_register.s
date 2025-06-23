.macro print_register

initial:
	b end

csd_print_macro:

	ldr r0, =uart_TX_RX_FIFO0
	ldr r1, =uart_Channel_sts_reg0

	bl print_line 			// print '-------------------'


	// enter
	mov	r3, #0xD			// line feed
	str	r3, [r0]
	mov	r3, #0XA			// carriage return
	str	r3, [r0]


	// r0
	mov r2, #0
	bl print_regnum

	add r7, sp, #12			// r0의 위치 -> sp + 12(r0 - r15 - cpsr - returnpc)
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r1
	mov r2, #1
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r2
	mov r2, #2
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		//','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r3
	mov r2, #3
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #0xA		// line feed
	strb	r3, [r0]
	mov 	r3, #0XD		// carriage return
	strb	r3, [r0]


	// r4
	mov r2, #4
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r5
	mov r2, #5
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r6
	mov r2, #6
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r7
	mov r2, #7
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value


	// enter
	mov	r3, #0xD
	str	r3, [r0]
	mov	r3, #0XA
	str	r3, [r0]


	// r8
	mov r2, #8
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r9
	mov r2, #9
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r10
	mov r2, #10
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r11
	mov r2, #11
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value


	// enter
	mov	r3, #0xD
	str	r3, [r0]
	mov	r3, #0XA
	str	r3, [r0]


	// r12
	mov r2, #12
	bl print_regnum

	add r7, r7, #4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r13
	mov r2, #13
	bl print_regnum

	add r7, r7, #8			// stmfd로 r13을 가장 먼저 저장 -> 맨 위에 r13이 있음. r13 아래는 r14(lr)
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r14
	mov r2, #14
	bl print_regnum

	add r7, r7, #-4			// lr은 13 아래, 따라서 -4
	mov r8, r7
	bl print_value

	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// r15
	mov r2, #15
	bl print_regnum

	add r7, sp, #0x8		// sp에서 +8 위치에 r15가 저장되어 있음
	mov r8, r7
	bl print_value


	// enter
	mov	r3, #0xD
	str	r3, [r0]
	mov	r3, #0XA
	str	r3, [r0]


	// "cpsr= "
	mov 	r3, #99
	strb	r3, [r0]

	mov 	r3, #112
	strb	r3, [r0]

	mov 	r3, #115
	strb	r3, [r0]

	mov 	r3, #114
	strb	r3, [r0]

	mov 	r3, #61
	strb	r3, [r0]

	mov 	r3, #32
	strb	r3, [r0]


	// nzcv signal
	bl print_NZCV
	mov 	r3, #44
	strb	r3, [r0]		// ','
	mov 	r3, #32
	strb	r3, [r0]		// space


	// if signal
	bl print_IF

	mov r3, #44
	str r3, [r0]			// ','
	mov r3, #32
	str r3, [r0]			// space


	// JT signal
	bl print_JT


	//" mode, "
	mov 	r3, #32
	str	r3, [r0]

	mov 	r3, #109
	str	r3, [r0]

	mov 	r3, #111
	str	r3, [r0]

	mov 	r3, #100
	str	r3, [r0]

	mov 	r3, #101
	str	r3, [r0]

	mov 	r3, #44
	str	r3, [r0]

	mov 	r3, #32
	str	r3, [r0]

	bl print_mode


	// "( =0x"
	mov 	r3, #32
	str	r3, [r0]			// space

	mov 	r3, #40
	str	r3, [r0]			// '('

	mov 	r3, #32
	str	r3, [r0]			// space

	mov 	r3, #61
	str	r3, [r0]			// '='

	mov 	r3, #48
	str	r3, [r0]			// '0'

	mov 	r3, #120
	str	r3, [r0]			// 'x'

	add r7, sp, #0x04
	mov r8, r7
	bl print_value			// cpsr


	// ')'
	mov	r3, #41
	str	r3, [r0]


	// enter
	mov	r3, #0xD
	str	r3, [r0]
	mov	r3, #0XA
	str	r3, [r0]

	bl print_line

	// enter
	mov	r3, #0xD
	str	r3, [r0]
	mov	r3, #0XA
	str	r3, [r0]

	// move to csd_debug
	ldmfd sp!, {pc}



print_line:
	ldr r3, =0x2d
	mov r4, #50

print_line_loop:
	ldr r9, [r1]
	and r9, r9, #0x8
	cmp r9, #0x8
	bne print_line_loop


	str r3, [r0]
	subs r4, r4, #1
	bne print_line_loop

	mov pc, lr



print_regnum:

	ldr r3, =0x72
	str r3, [r0]			//'r'

	cmp r2, #0
	ldreq r3, =0x30			//'0'
	streq r3, [r0]

	cmp r2, #1
	ldreq r3, =0x31			//'1'
	streq r3, [r0]

	cmp r2, #2
	ldreq r3, =0x32			//'2'
	streq r3, [r0]

	cmp r2, #3
	ldreq r3, =0x33			//'3'
	streq r3, [r0]

	cmp r2, #4
	ldreq r3, =0x34			//'4'
	streq r3, [r0]

	cmp r2, #5
	ldreq r3, =0x35			//'5'
	streq r3, [r0]

	cmp r2, #6
	ldreq r3, =0x36			//'6'
	streq r3, [r0]

	cmp r2, #7
	ldreq r3, =0x37			//'7'
	streq r3, [r0]

	cmp r2, #8
	ldreq r3, =0x38			//'8'
	streq r3, [r0]

	cmp r2, #9
	ldreq r3, =0x39			//'9'
	streq r3, [r0]

	cmp r2, #10
	ldreq r3, =0x31			//'1'
	streq r3, [r0]
	ldreq r3, =0x30			//'0'
	streq r3, [r0]

	cmp r2, #11
	ldreq r3, =0x31			//'1'
	streq r3, [r0]
	ldreq r3, =0x31			//'1'
	streq r3, [r0]

	cmp r2, #12
	ldreq r3, =0x31			//'1'
	streq r3, [r0]
	ldreq r3, =0x32			//'2'
	streq r3, [r0]

	cmp r2, #13
	ldreq r3, =0x31			//'1'
	streq r3, [r0]
	ldreq r3, =0x33			//'3'
	streq r3, [r0]

	cmp r2, #14
	ldreq r3, =0x31			//'1'
	streq r3, [r0]
	ldreq r3, =0x34			//'4'
	streq r3, [r0]

	cmp r2, #15
	ldreq r3, =0x31			//'1'
	streq r3, [r0]
	ldreq r3, =0x35			//'5'
	streq r3, [r0]

	// " =0x"

	ldr r3, =0x20			//' '
	str r3, [r0]

	ldr r3, =0x3d			//'='
	str r3, [r0]

	ldr r3, =0x30			//'0'
	str r3, [r0]

	ldr r3, =0x78			//'x'
	str r3, [r0]


	mov pc, lr



print_value:

	mov r4, #0x0
	ldr r10, [r8]

print_value_loop:
	ldr r9, [r1]
	and r9, r9, #0x8
	cmp r9, #0x8
	bne print_value_loop

	and r3, r10, #0xf0000000
	lsr r5, r3, #28

	cmp r5, #0x0			// '0'
	ldreq r3, =0x30
	streq r3, [r0]

	cmp r5, #0x1			// '1'
	ldreq r3, =0x31
	streq r3, [r0]

	cmp r5, #0x2			// '2'
	ldreq r3, =0x32
	streq r3, [r0]

	cmp r5, #0x3			// '3'
	ldreq r3, =0x33
	streq r3, [r0]

	cmp r5, #0x4			// '4'
	ldreq r3, =0x34
	streq r3, [r0]

	cmp r5, #0x5			// '5'
	ldreq r3, =0x35
	streq r3, [r0]

	cmp r5, #0x6			// '6'
	ldreq r3, =0x36
	streq r3, [r0]

	cmp r5, #0x7			// '7'
	ldreq r3, =0x37
	streq r3, [r0]

	cmp r5, #0x8			// '8'
	ldreq r3, =0x38
	streq r3, [r0]

	cmp r5, #0x9			// '9'
	ldreq r3, =0x39
	streq r3, [r0]

	cmp r5, #0xA			// 'A'
	ldreq r3, =0x41
	streq r3, [r0]

	cmp r5, #0xB			// 'B'
	ldreq r3, =0x42
	streq r3, [r0]

	cmp r5, #0xC			// 'C'
	ldreq r3, =0x43
	streq r3, [r0]

	cmp r5, #0xD			// 'D'
	ldreq r3, =0x44
	streq r3, [r0]

	cmp r5, #0xE			// 'E'
	ldreq r3, =0x45
	streq r3, [r0]

	cmp r5, #0xF			// 'F'
	ldreq r3, =0x46
	streq r3, [r0]

	lsl r10, r10, #4
	add r4, r4, #4

	cmp r4, #16
	moveq r3, #0x5F			// '_'
	streq r3, [r0]

	cmp r4, #32
	moveq pc, lr

	b print_value_loop



print_NZCV:
	add r7, sp, #0x4;
	ldr r8, [r7]
	mov r8, r8, LSR#28

	// n
	and r3, r8, #0x8
	cmp r3, #0x8
	movne r3, #0x6D
	moveq r3, #0x4E
	str r3, [r0]

	// z
	and r3, r8, #0x4
	cmp r3, #0x4
	movne r3, #0x7A
	moveq r3, #0x5A
	str r3, [r0]

	// c
	and r3, r8, #0x2
	cmp r3, #0x2
	movne r3, #0x63
	moveq r3, #0x43
		str r3, [r0]

	// v
	and r3, r8, #0x1
	cmp r3, #0x1
	movne r3, #0x76
	moveq r3, #0x56
	str r3, [r0]

	mov pc, lr

print_IF:
	add r7, sp, #0x4;
	ldr r8, [r7]
	mov r8, r8, LSR#6		// check mask bit

	and r3, r8, #0b10		// check I or i
	moveq r3, #73
	movne r3, #105
	str r3, [r0]

	and r3, r8, #0b1 		// check F or f
	moveq r3, #70
	movne r3, #102
	str r3, [r0]

	mov pc, lr

print_JT:
	add r7, sp, #0x4;
	ldr r8, [r7]

	mov r5, r8, lsr#24		// j
	and r5, r5, #1
	lsl r5, r5, #1
	mov r6, r8, lsr #5		// t
	and r6, r6, #1			// r6 = 'j'+'t'
	orr r6, r6, r5

	cmp r6, #0b11			// ThumbEE
	beq JT_ThumbEE

	cmp r6, #0b10			// Jazelle
	beq JT_Jazelle

	cmp r6, #0b01			// Thumb
	beq JT_Thumb

	cmp r6, #0b00			// ARM
	beq JT_ARM

JT_ThumbEE:
	mov	r3, #84
	str	r3, [r0]

	mov	r3, #104
	str	r3, [r0]

	mov	r3, #117
	str	r3, [r0]

	mov	r3, #109
	str	r3, [r0]

	mov	r3, #98
	str	r3, [r0]

	mov	r3, #69
	str	r3, [r0]

	mov	r3, #69
	str	r3, [r0]

	mov	pc, lr

JT_Jazelle:
	mov	r3, #74
	str	r3, [r0]

	mov	r3, #97
	str	r3, [r0]

	mov	r3, #122
	str	r3, [r0]

	mov	r3, #101
	str	r3, [r0]

	mov	r3, #108
	str	r3, [r0]

	mov	r3, #108
	str	r3, [r0]

	mov	r3, #101
	str	r3, [r0]

	mov	pc, lr

JT_Thumb:
	mov r3, #84
	str r3, [r0]

	mov	r3, #104
	str r3, [r0]

	mov r3, #117
	str	r3, [r0]

	mov	r3, #109
	str	r3, [r0]

	mov	r3, #98
	str	r3, [r0]

	mov	pc, lr

JT_ARM:
	mov r3, #65
	str	r3, [r0]

	mov	r3, #82
	str	r3, [r0]

	mov	r3, #77
	str	r3, [r0]

	mov	pc, lr

print_mode:	//default content "current mode = "
	mov	r3, #99
	str	r3, [r0]

	mov	r3, #117
	str	r3, [r0]

	mov	r3, #114
	str	r3, [r0]

	mov	r3, #114
	str	r3, [r0]

	mov	r3, #101
	str	r3, [r0]

	mov	r3, #110
	str	r3, [r0]

	mov	r3, #116
	str	r3, [r0]

	mov	r3, #32
	str	r3, [r0]

	mov	r3, #109
	str	r3, [r0]

	mov	r3, #111
	str	r3, [r0]

	mov	r3, #100
	str	r3, [r0]

	mov	r3, #101
	str	r3, [r0]

	mov	r3, #32
	str	r3, [r0]

	mov	r3, #61
	str	r3, [r0]

	// CPSR 확인 -> 각각의 모드와 비교 후 branch
	add r7, sp, #0x4;
	ldr r8, [r7]
	and r4, r8, #0xF

	cmp r4, #0x0
	beq User_mode

	cmp r4, #0x1
	beq FIQ_mode

	cmp r4, #0x2
	beq IRQ_mode

	cmp r4, #0x3
	beq Supervisor_mode

	cmp r4, #0x6
	beq Monitor_mode

	cmp r4, #0x7
	beq Abort_mode

	cmp r4, #0xA
	beq Hyp_mode

	cmp r4, #0xB
	beq Undefined_mode

	cmp r4, #0xF
	beq System_mode

User_mode:
	mov r3, #117			//'u'
	str	r3, [r0]

	mov r3, #115			//'s'
	str	r3, [r0]

	mov r3, #114			//'r'
	str	r3, [r0]

	mov pc, lr

FIQ_mode:
	mov r3, #102			//'f'
	str	r3, [r0]

	mov r3, #105			//'i'
	str	r3, [r0]

	mov r3, #113			//'q'
	str	r3, [r0]

	mov pc, lr

IRQ_mode:
	mov r3, #105			//'i'
	str	r3, [r0]

	mov r3, #114			//'r'
	str	r3, [r0]

	mov r3, #113			//'q'
	str	r3, [r0]

	mov pc, lr

Supervisor_mode:
	mov r3, #115			//'s'
	str	r3, [r0]

	mov r3, #118			//'v'
	str	r3, [r0]

	mov r3, #99				//'c'
	str	r3, [r0]

	mov pc, lr

Monitor_mode:
	mov r3, #109			//'m'
	str	r3, [r0]

	mov r3, #111			//'o'
	str	r3, [r0]

	mov r3, #110			//'n'
	str	r3, [r0]

	mov pc, lr

Abort_mode:
	mov r3, #97				//'a'
	str	r3, [r0]

	mov r3, #98				//'b'
	str	r3, [r0]

	mov r3, #116			//'t'
	str	r3, [r0]

	mov pc, lr

Hyp_mode:
	mov r3, #104			//'h'
	str	r3, [r0]

	mov r3, #121			//'y'
	str	r3, [r0]

	mov r3, #112			//'p'
	str	r3, [r0]

	mov pc, lr

Undefined_mode:
	mov r3, #117			//'u'
	str	r3, [r0]

	mov r3, #110			//'n'
	str	r3, [r0]

	mov r3, #100			//'d'
	str	r3, [r0]

	mov pc, lr

System_mode:
	mov r3, #115			//'s'
	str	r3, [r0]

	mov r3, #121			//'y'
	str	r3, [r0]

	mov r3, #115			//'s'
	str	r3, [r0]

	mov pc, lr

end:

.endm
