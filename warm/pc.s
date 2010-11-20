;;; nasty use of pc
	mvns	r0,#0
	stm	sp,#0x8000
	ldm	sp,#1
	swi	#SysPutNum
	mov	r0,#10
	swi	#SysPutChar
	swi	#SysHalt