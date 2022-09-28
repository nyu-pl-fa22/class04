// Result of `gcc -S -O3 test.c (fully optimized)
        
	.file	"test.c"
	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:
.LFB0:
	.cfi_startproc
	leal	(%rdi,%rdi), %eax  // Directly compute return value from 1st argument of foo
	ret
	.cfi_endproc
.LFE0:
	.size	foo, .-foo
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	xorl	%eax, %eax        // Directly assign 0 to %eax. Call to foo has been eliminated (dead code)
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Debian 11.3.0-3) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
