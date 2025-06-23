.macro debug_register
   stmfd sp!, {sp}			// register data r13 (top position)
   stmfd sp!, {r0-r12, lr} 	// register data r0~r12, r14 (r13 �Ʒ� r14, �� �ؿ� r12~r0)

   sub r0, pc, #0x10
   stmfd sp!, {r0}			// r15 (r0 �ؿ�)

   mrs r0, cpsr 			// CPSR data �ҷ��ͼ� ���� (r15 �Ʒ�)
   stmfd sp!, {r0}

   stmfd sp!, {pc}			// ���� pc ����(���Ϳ�)
   b csd_print_macro

   ldmfd sp!, {r0}
   msr cpsr, r0 			//cpsr�� ���� cpsr �� ����

   add sp, sp, #4
   ldmfd sp!, {r0-r12}

   ldmfd sp!, {lr}
   add sp, sp, #4

.endm
