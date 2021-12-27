	.file	"debugger.c"
	.text
	.comm	status,4,4
	.globl	PT_OPTIONS
	.section	.rodata
	.align 4
	.type	PT_OPTIONS, @object
	.size	PT_OPTIONS, 4
PT_OPTIONS:
	.long	83
.LC0:
	.string	"s"
.LC1:
	.string	"c"
.LC2:
	.string	"sys"
.LC3:
	.string	"k"
.LC4:
	.string	"lr"
	.text
	.globl	resolve_request
	.type	resolve_request, @function
resolve_request:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	leaq	.LC0(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L2
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	ptrace_singlestep@PLT
	jmp	.L7
.L2:
	movq	-8(%rbp), %rax
	leaq	.LC1(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L4
	movq	-16(%rbp), %rax
	leaq	status(%rip), %rsi
	movq	%rax, %rdi
	call	ptrace_continue@PLT
	jmp	.L7
.L4:
	movq	-8(%rbp), %rax
	leaq	.LC2(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L5
	movq	-16(%rbp), %rax
	leaq	status(%rip), %rsi
	movq	%rax, %rdi
	call	ptrace_syscall@PLT
	jmp	.L7
.L5:
	movq	-8(%rbp), %rax
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L6
	movq	-16(%rbp), %rax
	leaq	status(%rip), %rsi
	movq	%rax, %rdi
	call	ptrace_kill@PLT
	jmp	.L7
.L6:
	movq	-8(%rbp), %rax
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L7
	movq	-16(%rbp), %rax
	leaq	status(%rip), %rsi
	movq	%rax, %rdi
	call	get_registers@PLT
.L7:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	resolve_request, .-resolve_request
	.section	.rodata
.LC5:
	.string	"debug> "
.LC6:
	.string	"%s"
.LC7:
	.string	"Exited with status %d\n"
.LC8:
	.string	"Terminated"
.LC9:
	.string	"Inside syscall"
.LC10:
	.string	"Received signal number %d\n"
	.text
	.globl	loop
	.type	loop, @function
loop:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$544, %rsp
	movq	%rdi, -536(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$8, %edx
	leaq	status(%rip), %rsi
	movl	$-1, %edi
	call	waitpid@PLT
	movl	$83, %edx
	movq	-536(%rbp), %rax
	movl	(%rax), %eax
	movl	%edx, %ecx
	movl	$0, %edx
	movl	%eax, %esi
	movl	$16896, %edi
	movl	$0, %eax
	call	ptrace@PLT
.L16:
	leaq	.LC5(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	leaq	-512(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movq	stdin(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	movq	-536(%rbp), %rdx
	leaq	-512(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	resolve_request
	movl	status(%rip), %eax
	andl	$127, %eax
	testl	%eax, %eax
	jne	.L9
	movl	status(%rip), %eax
	sarl	$8, %eax
	andl	$255, %eax
	movl	%eax, -516(%rbp)
	movl	-516(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC7(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-516(%rbp), %eax
	movl	%eax, %edi
	call	exit@PLT
.L9:
	movl	status(%rip), %eax
	andl	$127, %eax
	addl	$1, %eax
	sarb	%al
	testb	%al, %al
	jle	.L10
	movl	status(%rip), %eax
	andl	$127, %eax
	movl	%eax, -520(%rbp)
	leaq	.LC8(%rip), %rdi
	call	puts@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	nop
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L17
	jmp	.L18
.L10:
	movl	status(%rip), %eax
	movzbl	%al, %eax
	cmpl	$127, %eax
	jne	.L16
	movl	status(%rip), %eax
	sarl	$8, %eax
	andl	$255, %eax
	movl	%eax, -524(%rbp)
	cmpl	$133, -524(%rbp)
	jne	.L13
	leaq	.LC9(%rip), %rdi
	call	puts@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	jmp	.L15
.L13:
	movl	-524(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC10(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
.L15:
	jmp	.L16
.L18:
	call	__stack_chk_fail@PLT
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	loop, .-loop
	.globl	main
	.type	main, @function
main:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movl	-36(%rbp), %eax
	subl	$2, %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -16(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L20
.L21:
	movl	-32(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	addl	$1, -32(%rbp)
.L20:
	movl	-32(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L21
	call	fork@PLT
	movl	%eax, -28(%rbp)
	cmpl	$0, -28(%rbp)
	jne	.L22
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	ptrace@PLT
	movl	$19, %edi
	call	raise@PLT
	movq	-48(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	-24(%rbp), %rcx
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	execve@PLT
	jmp	.L23
.L22:
	movl	$16, %edi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	-28(%rbp), %edx
	movl	%edx, (%rax)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	loop
.L23:
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
