	lea	s1,r0
	call 	print
	trap	$SysHalt

	.origin 500
s1:	.string	"Hello, Duane.\n"

	
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