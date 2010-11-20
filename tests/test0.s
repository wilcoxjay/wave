;;; a program exercising swi instructions
	swi	#SysGetNum
;	mov	r1,r0
;	swi	#SysGetNum
;	add	r0,r0,r1
	swi	#SysPutNum
	mov	r0,#10
	swi	#SysPutChar
	swi	#SysHalt