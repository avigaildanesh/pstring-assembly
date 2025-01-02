# 213372063 Avigail Danesh
.section .rodata

 format_print_invalid:   .string     "invalid input!\n"

.text
.globl	pstrlen 
.type	pstrlen, @function
pstrlen: 
	
	pushq	 %rbp
    	movq %rsp, %rbp
	
	# move 1 byte to rax for the length
	movzbq	 (%rdi), %rax
	
	movq	 %rbp, %rsp
	popq	 %rbp
	ret
	


.globl	replaceChar	
.type	replaceChar, @function
replaceChar:
	pushq	 %rbp
    	movq	 %rsp, %rbp

	# &rdi-pstring, rsi- old char, rdx- new char

	call	 pstrlen
	# in rax we have the length

	xorq	 %r8, %r8 
	# r8 is the counter
	addq	 $1, %rdi
	while:
	cmpq	 %r8, %rax
	je		 exitOfLoop
	# movw one char to r9
	movzbq	 (%r8,%rdi,1), %r9

	# compare r9 to the old char, if equal keep looping,
	# else, replacr char
	cmpq	 %r9, %rsi
	jne		 turnBack
	movb	 %dl, (%r8,%rdi,1)
	
	turnBack:
	incq	 %r8
	jmp		 while
	
	exitOfLoop:
	# sub rdi to get only the string.
	subq	 $1, %rdi
	movq	 %rdi, %rax
	movq	 %rbp, %rsp
	popq	 %rbp
	ret
	
	
.globl	pstrijcpy	
.type	pstrijcpy, @function
#&rdi-pstring1, &rsi- pstring2, rdx- i, rcx- j
pstrijcpy:
# keep the variables in stack. its need to keep after isvalid function
	pushq	 %rbp
    	movq	 %rsp, %rbp
	pushq	 %rdi
	pushq 	 %rsi
	pushq	 %rdx
	pushq	 %rcx
	call	 isValid
	popq	 %rcx
	popq	 %rdx
	popq	 %rsi
	popq	 %rdi
	cmpq	 $-2, %rax 
	
	# if rax is -2 the given numbers is not valid so go to end.
	je Done
	

	while2:
	cmpq	 %rdx, %rcx		 #rdx is i, rcx is j
	js 		 Done

	#first is dst, sec is src
	# replace chars
	movb	 1(%rsi, %rdx, 1), %r13b
	movb	 %r13b, 1(%rdi, %rdx, 1)
	incq	 %rdx
	jmp		 while2

	Done:
	movq	 %rdi, %rax
	movq	 %rbp, %rsp
	popq	 %rbp
	ret

	

.type	isValid, @function
isValid:	
	
	# &rdi-pstring1, &rsi- pstring2, rdx- i, rcx- j
	pushq	 %rbp
    	movq	 %rsp, %rbp
	
	call	 pstrlen
	
	# in rax the len of p1
	# r13 len ptr1
	movq	 %rax, %r13
	# r12 ptr1
	movq	 %rdi, %r12
	movq	 %rsi, %rdi
	call	 pstrlen
	#rax len ptr2
	#rdi, ptr2 
	
	# the case that i bigger j
	cmpb	 %dl, %cl
	jb		 inValid
	
	#  the case that j bigger len
	cmpb	 %cl, %r13b
	jbe		 inValid
	cmpb	 %cl, %al
	jbe		 inValid
	
	# the end of the function
	xorq	 %rax, %rax
	movq	 %rbp, %rsp
	popq	 %rbp
	ret
	
	inValid:

	#print inValid part
	andq	 $~0xF, %rsp
	movq	 $format_print_invalid, %rdi
	xorq	 %rax, %rax
	call	 printf
	
	#the return value is -2 if isnot valid
	movq	 $-2, %rax 
	
	movq	 %rbp, %rsp
	popq	 %rbp
	ret
	

.globl	swapCase	
.type	swapCase, @function
#rdi-pstring1
swapCase:
	pushq	 %rbp
    	movq	 %rsp, %rbp

	call	 pstrlen

	# in rax we have the length
	movq	 %rax, %rsi
	xorq	 %r12, %r12
	while3:
	cmpq	 %r12, %rsi
	# jump neg is js
	js		 Done

	# check if the char in lower char, in ascii is 65 till 90
	movb	 1(%rdi, %r12,1), %r10b
	cmpb	 $65, %r10b
	setae	 %al
	cmpb	 $90, %r10b
	setbe	 %r13b
	testb	 %al, %r13b

	#if equal we need to replace the char to upper char.
	jne		 Upper
	cmpb	 $97, %r10b
	setae	 %al
	cmpb	 $122, %r10b
	setbe	 %r13b
	testb	 %al, %r13b

	#if equal we need to replace the char to lower char.
	jne lower

	else:
	incq	 %r12
	jmp		 while3

	Upper:

	# 20 is hexo or our char will replace it to upper char
	movb	 1(%rdi, %r12,1), %r8b
	orb		 $0x20, %r8b
	movb	 %r8b, 1(%rdi, %r12,1)
	jmp		 else

	lower:
	# DF is hexo and our char will replace it to lower char
	movb	 1(%rdi, %r12,1), %r8b
	andb	 $0xDF, %r8b
	movb	 %r8b, 1(%rdi, %r12,1)
	jmp		 else

	Done2:
	movq	 %rdi, %rax
	movq	 %rbp, %rsp
	popq	 %rbp
	ret

.globl	pstrijcmp	
.type	pstrijcmp, @function
#rdi-pstring1
pstrijcmp:

#&rdi-pstring1, &rsi- pstring2, rdx- i, rcx- j

# keep the variables in stack. its need to keep after isvalid function
	pushq	 %rbp
    	movq	 %rsp, %rbp
	pushq	 %rdi
	pushq	 %rsi
	pushq	 %rdx
	pushq	 %rcx
	call	 isValid
	popq	 %rcx
	popq	 %rdx
	popq	 %rsi
	popq	 %rdi
	cmpq	 $-2, %rax 
	
	je Done3

	while4:
	# &rdi-pstring1, &rsi- pstring2, rdx- i, rcx- j

	# compare i and j
	cmpq	 %rdx, %rcx

	# jump neg
	js		 L3
	# compare chars
	movb	 1(%rsi, %rdx, 1), %r13b
	movb	 1(%rdi, %rdx, 1), %r14b
	cmpb	 %r13b, %r14b

	#if r13b bigger than L1, else L2
	ja L1
	jb L2
	
	incq	 %rdx
	jmp		 while4 

	# r13>r14 ret 1
	L1:
	movq	 $1, %rax
	jmp		 Done3

	# r13<r14 ret -1
	L2:
	movq	 $-1, %rax
	jmp		 Done3

	# if they are equal
	L3:
	xorq	 %rax, %rax
	
	# end of function
	Done3:
	movq	 %rbp, %rsp
	popq	 %rbp
	ret


