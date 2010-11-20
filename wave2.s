;;; A basic wave.
;;; (c) 2010 zina and james
	;; locations
	.equ	warm,0x1000000	;WARM virtual memory
	.equ	decode,0x4000000 ;decoding
	.equ	execute,0x5000000 ;executing
	.equ	warmreg,0x6000000 ;warm virtual register file
	.equ	rhs,0x7000000	  ;decode the rhs operand
zero:	jmp	main		;will be replaced by 'jmp opadd' equiv
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

	.origin	decode		;well beyond the warm virtual space
realzero:			;the instruction we want to have at mem loc 0
	mov	$execute,rip
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
main:
	;;put the instruction we want in mem loc 0
	lea	realzero,r0	;location of first word of instruction
	lea	zero,r1		;destination, memloc 0
	mov	(r0),(r1)	;move first word 
	add	$1,r0		;location of second word
	add	$1,r1		;destination, memloc 1
	mov	(r0),(r1)	;move second word
	
	mov	$warm,r0	;load the warm program
	trap	$SysOverlay	
	mov	$0,r14		;the virtual warm pc
decodeloop:
	mov	warm(r14),r15	;grab the next warm instruction
	mov	r15,r2
	shr	$23,r2		;op code bits in low 5
	and	$31,r2		;clear non opcode bits
	shl	$1,r2		;multiply by two for intel
	mov	r2,rip
decodenext:
	add	$1,r14		;increment warmpc
	jmp	decodeloop
exit:	;mov	r1,r0
	;trap	$SysPutNum
	;mov	$10,r0
	;trap	$SysPutChar
	trap	$SysHalt
	
;;; put the result from r1 into the warm register denoted dst by instruction
;;; in r15.
putdest:
	mov	r15,r0
	shr	$19,r0		;low bit of dst register is 19
	and	$0xf,r0	;4 bit result
	mov	r1,warmreg(r0)	;value of that register
	ret
;;; get the source register and put it in r0
getsrc:
	mov	r15,r0
	shr	$15,r0		;low bit of src is 15
	and	$0xf,r0	;4 bit result
	mov	warmreg(r0),r0	;value of that register
	ret

	.origin	execute
opadd:	call	getrhs
	mov	r0,r1
	call	getsrc
	add	r0,r1
	call	putdest
	jmp	decodenext
	trap	$SysHalt
opadc:
	trap	$SysHalt
opsub:
	trap	$SysHalt
opcmp:
	trap	$SysHalt
opeor:
	trap	$SysHalt
oporr:
	trap	$SysHalt
opand:
	trap	$SysHalt
optst:
	trap	$SysHalt
opmul:
	trap	$SysHalt
opmla:
	trap	$SysHalt
opdiv:
	trap	$SysHalt
opmov:	call	getrhs
	mov	r0,r1
	call	putdest
	jmp	decodenext
	trap	$SysHalt
opmvn:
	trap	$SysHalt
opswi:	call	getrhs
	shl	$1,r0		;for intel
	add	r0,rip
	jmp	swi0
	jmp	swi1
	jmp	swi2
	jmp	swi3
	jmp	swi4
swi0:	trap	$0
	mov	r0,warmreg
	jmp	decodenext
swi1:	trap	$1
	mov	r0,warmreg
	jmp	decodenext
swi2:	trap	$2
	mov	r0,warmreg
	jmp	decodenext
swi3:	mov	warmreg,r0
	trap	$3
	jmp	decodenext
swi4:	mov	warmreg,r0
	trap	$4
	jmp	decodenext
	
	trap	$SysHalt
opldm:
	trap	$SysHalt
opstm:
	trap	$SysHalt
opldr:
	trap	$SysHalt
opstr:
	trap	$SysHalt
opldp:
	trap	$SysHalt
opstp:
	trap	$SysHalt
opadr:
	trap	$SysHalt
opbfor:
	trap	$SysHalt
opbback:
	trap	$SysHalt
opblfor:
	trap	$SysHalt
opblback:
	trap	$SysHalt

;;; Memory to store the registers for the arm
	.origin	warmreg
wr0:	.data 0
wr1:	.data 0
wr2:	.data 0
wr3:	.data 0
wr4:	.data 0
wr5:	.data 0
wr6:	.data 0
wr7:	.data 0
wr8:	.data 0
wr9:	.data 0
wr10:	.data 0
wr11:	.data 0
wr12:	.data 0
wr13:	.data 0
wr14:	.data 0
wr15:	.data 0
	call	error
;;; get the rhs and put it in r0
;;; overwrites r1,r2
getrhs:
	mov	r15,r0
	shr	$12,r0		;low bit of rhs is 12
	and	$0x7f,r0	;clear all but low 3 bits
	shl	$1,r0		;multiply by 2 for intel
	add	$rhs,r0		;prepare for jmp to rhs
	mov	r0,rip
rhsret:	
	ret
	
	
	call	error

	
	.origin	rhs
	jmp	rhsdiv		;direct immediate value
	jmp	rhsdiv
	jmp	rhsdiv
	jmp	rhsdiv
	jmp	rhssi		;shift by immediate
	jmp	rhssr		;shift by register
	jmp	rhsrp		;register product
	call 	error
;;; direct immediate value
rhsdiv:
	mov	r15,r0		;will be value
	mov	r15,r1		;will be exponent
	and	$0x1ff,r0	;clear all but low 9
	shr	$9,r1		;exponent low bit is 9
	and	$0x1f,r1	;exponent clear all but low 5
	shl	r1,r0		;r0<<r1
	jmp	rhsret
;;; shifted by immediate
rhssi:	mov	r15,r0
	mov	r15,r1		;copy for shift count
	and	$0x3f,r1	;shift count has 6 bits
	shr	$6,r0		;src reg 2 has low bit 6
	and	$0xf,r0	;clear all but low 4 bits
	mov	warmreg(r0),r0
	call	shiftr0
	jmp	rhsret
;;; shifted by register
rhssr:	mov	r15,r0		;src reg 2
	mov	r15,r1		;sh reg
	shr	$6,r0		;src reg 2 has low bit 6
	and	$0xf,r0		;src reg has 4 bits
	and	$0xf,r1		;sh reg has 4 bits
	mov	warmreg(r0),r0	;fetch warm registers
	mov	warmreg(r1),r1
	call	shiftr0
	jmp	rhsret
;;; register product
rhsrp:	call	error
;;; shifts r0 by r1 according to shop in r15 (bits 10 and 11)
shiftr0:
	mov	r15,r2
	shr	$9,r2		;shop has low bit 10, we multiply by 2 for intel
	and	$6,r2		;clear all but bits 1 and 2
	add	r2,rip
	jmp	shiftr0lsl
	jmp	shiftr0lsr
	jmp	shiftr0asr
	jmp	shiftr0ror
	call	error
shiftr0lsl:
	shl	r1,r0
	ret
shiftr0lsr:
	shr	r1,r0
	ret
shiftr0asr:
	sar	r1,r0
	ret
shiftr0ror:
	call	error