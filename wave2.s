;;; A basic wave.
;;; (c) 2010 zina and james
	.equ	warm,0x100000
zero:	jmp	main		;will be replaced by 'b add' equiv
	jmp	opadc
	jmp	opsub
	jmp	opcmp
	jmp	opeor
	jmp	oporr
	jmp	opand
	jmp	optst
	jmp	opmul
	jmp	opmla
	jmp	opdiv
	jmp	opmov
	jmp	opmvn
	jmp	opswi
	jmp	opldm
	jmp	opstm
	jmp	opldr
	jmp	opstr
	jmp	opldp
	jmp	opstp
	jmp	opadr
	call	error
	call	error
	call	error
	jmp	opbfor
	jmp	opbback
	jmp	opblfor
	jmp	opblback
	call	error
	call	error
	call	error
	call	error

	.origin	0x4000000	;well beyond the warm virtual space
realzero:			;the instruction we want to have at mem loc 0
	;; want this to be 'jmp opadd' but need absolute addr

	;; error handling
error:	mov	$13,r0		;the only error code in this program
	trap	$SysPutNum
	mov	$10,r0		;\n
	trap	$SysPutChar
	pop	r0		;report where the error is from (+1)
	trap	$SysPutNum
	trap	$SysHalt

	;; r14	virtual warm pc
	;; r15	an untouched copy of the current instruction
main:	lea	realzero,r0	;put the instruction we want in mem loc 0
	mov	(r0),r1
	lea	zero,r0
	mov	r1,(r0)		
	
	mov	$warm,r0	;load the warm program
	trap	$SysOverlay	
	mov	$0,r14		;the virtual warm pc
decodeloop:
	mov	warm(r14),r15	;grab the next warm instruction
	mov	r15,r2
	shr	$23,r2		;op code bits in low 5
	and	$31,r2		;clear non opcode buts
	je	done
	add	$1,r14		;increment warmpc
	jmp	decodeloop
exit:	;mov	r1,r0
	;trap	$SysPutNum
	;mov	$10,r0
	;trap	$SysPutChar
	trap	$SysHalt

opadd:	
opadc:
opsub:
opcmp:
opeor:
oporr:
opand:
optst:
opmul:
opmla:
opdiv:
opmov:
opmvn:
opswi:
opldm:
opstm:
opldr:
opstr:
opldp:
opstp:
opadr:
opbfor:	
opbback:	
opblfor:	
opblback:
opbfor:	
opbback:	
opblfor:	
opblback:	