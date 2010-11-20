main:	mov	$-1,r0
	trap	$SysPutNum
	mov	$10,r0
	trap	$SysPutChar
	mov	$-1,r0
	cmp	$0,r0
	call	printcc
	mov	$10,r0
	trap	$SysPutChar
	
	lea	s3,r0		;print description -1+-1
	call	print
	mov	$-1,r3
	add	$-1,r3
	call	printcc
	mov	$10,r0
	trap	$SysPutChar
	
	lea	s4,r0		;describe MAX_INT+MAX_INT
	call	print
	mov	$0x7fffffff,r0
	add	$0x7fffffff,r0
	call	printcc
	mov	$10,r0
	trap	$SysPutChar
	

	trap	$SysHalt

;;; prints current condition codes
printcc:
	mov	ccr,r0
	push	r0
	;; print out the intro
	lea	s1,r0
	call	print
	;;print the bits of ccr from msb to lsb
	pop	r1
	mov	r1,r0
	shr	$3,r0
	and	$1,r0
	trap	$SysPutNum	;bit 0
	mov	r1,r0
	shr	$2,r0
	and	$1,r0
	trap	$SysPutNum	;bit 1
	mov	r1,r0
	shr	$1,r0
	and	$1,r0
	trap	$SysPutNum	;bit 2
	mov	r1,r0
	and	$1,r0
	trap	$SysPutNum	;bit 3
	
	mov	$10,r0
	trap	$SysPutChar	;\n

	push	r1
	;; print the second section heading
	lea	s2,r0
	call	print
	pop	r1
	;; print N
	mov	$'n,r0
	trap	$SysPutChar
	mov	$32,r0
	trap	$SysPutChar
	mov	r1,ccr
	jl	neg
pos:	mov	$0,r0
	jmp	printn
neg:	mov	$1,r0
printn:	trap	$SysPutNum
	;; \n
	mov	$10,r0
	trap	$SysPutChar
	;; print Z
	mov	$'z,r0
	trap	$SysPutChar
	mov	$32,r0
	trap	$SysPutChar
	je	zero
ne:	mov	$0,r0
	jmp	printz
zero:	mov	$1,r0
printz:	trap	$SysPutNum
	;; \n
	mov	$10,r0
	trap	$SysPutChar
	ret

;;; data
	.origin	500
s1:	.string "Condition Codes NZCV (MSb to LSb):\n"
s2:	.string "Extracted Individual Codes:\n"
s3:	.string "Testing (-1)+(-1):\n"
s4:	.string	"Testing 0x7fffffff+0x7fffffff\n"
	
;;; subroutines
	.origin 1000
;;; takes char* in r0, prints until end of C-string
;;; no automatic trailing newline
;;; print(char *s) {
;;;    while (*s) {
;;;        fputc(*s, stdout);
;;;        s++;
;;;    }
;;; }
print:	mov	r0,r1		;safe keeping
loop:	mov	(r1),r0		;while(*c) {
	cmp	$0,r0		;"
	je	done		;"
	trap	$SysPutChar	;fputc(*s, stdout);
	add	$1,r1
	jmp	loop
done:	ret