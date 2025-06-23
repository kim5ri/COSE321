.global csd_MMUTable_lv2
.section .csd_mmu_tbl_lv2,"a"

csd_MMUTable_lv2:
.set 	PAGE, 0x400000
.word	PAGE + 0x2
.set 	PAGE, PAGE + 0x1000
.word	PAGE + 0x2
.set 	PAGE, PAGE + 0x1000
.word	PAGE + 0x2


.global  csd_MMUTable
.section .csd_mmu_tbl,"a"

csd_MMUTable:
.set 	SECT, 0
.word	SECT + 0x15de6		/* S=b1 TEX=b101 AP=b11, Domain=b1111, C=b0, B=b1 */
.set	SECT, SECT + 0x100000
.word	SECT + 0x15de6		/* S=b1 TEX=b101 AP=b11, Domain=b1111, C=b0, B=b1 */
.set	SECT, 0x400000
.word 	csd_MMUTable_lv2 + 0x1e1



.rept (0x200 - 6)
.word SECT + 0x15de6
.endr

.end
