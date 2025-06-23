.macro debug_register
   stmfd sp!, {sp}			// register data r13 (top position)
   stmfd sp!, {r0-r12, lr} 	// register data r0~r12, r14 (r13 아래 r14, 그 밑에 r12~r0)

   sub r0, pc, #0x10
   stmfd sp!, {r0}			// r15 (r0 밑에)

   mrs r0, cpsr 			// CPSR data 불러와서 저장 (r15 아래)
   stmfd sp!, {r0}

   stmfd sp!, {pc}			// 현재 pc 저장(복귀용)
   b csd_print_macro

   ldmfd sp!, {r0}
   msr cpsr, r0 			//cpsr에 기존 cpsr 값 저장

   add sp, sp, #4
   ldmfd sp!, {r0-r12}

   ldmfd sp!, {lr}
   add sp, sp, #4

.endm
