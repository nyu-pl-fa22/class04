/*
Result of `gcc -S test.c` (no compiler optimizations)

Notes on the x86-64 architecture:

- All registers are 64 bits wide

- Register %rax is used to store the return value of a function if the size of the return value does not exceed 64 bits. %rax is caller saved

- Register %rdi is used to store the 1st argument of a function if the size of the argument does not exceed 64 bits. %rdi is caller saved

- Register %rbp is the frame pointer (callee saved)

- Register %rsp is the stack pointer

- Register %eax refers to the lower 32 bits of the %rax register. Similar for %edi/%rdi. The size of type int in C is 32 bits.

- The stack grows down in memory. That is, subtracting a positive constant c from the stack pointer corresponds to allocating c bytes of stack memory.

- The stack pointer can sometimes lag behind.

*/
        

        .file	"test.c"
	.text
	.globl	foo
	.type	foo, @function
foo:
.LFB0:
	.cfi_startproc
	pushq	%rbp            // push frame pointer of caller onto stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp      // update frame pointer to current stack pointer
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp) // copy parameter i (in %edi) to local variable on the stack
	movl	-20(%rbp), %eax // copy i to %eax 
	addl	%eax, %eax      // %eax = i + i
	movl	%eax, -4(%rbp)  // copy %eax to stack location storing j
	movl	-4(%rbp), %eax  // copy j back to %eax to prepare return value
	popq	%rbp            // restore caller's frame pointer
	.cfi_def_cfa 7, 8
	ret                     // return to caller by popping return address from stack into program counter register
	.cfi_endproc
.LFE0:
	.size	foo, .-foo
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushq	%rbp            // push frame pointer of caller onto stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp      // update frame pointer to current stack pointer
	.cfi_def_cfa_register 6
	subq	$16, %rsp       // decrease stack pointer to store local k and return address for call to foo
	movl	$42, -4(%rbp)   // initialize k (k is stored at address (%rbp - 4) on the stack)
	movl	-4(%rbp), %eax  // copy k to %eax register
	movl	%eax, %edi      // also copy k to %edi register, which is used to pass k to foo
	call	foo             // push return address on stack and jump to foo
	movl	%eax, -4(%rbp)  // return value of foo is in %eax, copy it to k
	movl	$0, %eax        // set return value of main
	leave
	.cfi_def_cfa 7, 8
	ret                     // return to caller by popping return address from stack into program counter register
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Debian 11.3.0-3) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
