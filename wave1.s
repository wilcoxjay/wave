;;; (c) 2010 james r. wilcox
	.equ	warm,1000
	mov	$warm,r0
	trap	$SysOverlay
	mov	$0,r1		;the virtual warm pc
loop:	mov	warm(r1),r2	;grab the next warm instruction
	cmp	$0x6800000,r2	;hex of 32bit number representing swi #0
	je	done
	add	$1,r1		;increment warmpc
	jmp	loop
done:	mov	r1,r0
	trap	$SysPutNum
	mov	$10,r0
	trap	$SysPutChar
	trap	$SysHalt