# 213372063 Avigail Danesh


# rdi- option int, rsi- p1, rdx-p2
.section .rodata
format_print_for_length:   .string     "first pstring length: %d, second pstring length: %d\n"
format_scanf_for_char:      .string      " %c"
format_print_for_replace: 	.string		"old char: %c, new char: %c, first string: %s, second string: %s\n"
format_scanf_for_int:      .string      " %d"
format_print_for_pstrijcpy: .string 	"length: %d, string: %s\n"
format_swap: 	.string 	"length: %d, string: %s\nlength: %d, string: %s"
format_cmp:	 .string 	"compare result: %d\n"
format_print_invalid:   .string    "invalid option!\n"

.align 8
# the cases of the Switch case- jump table, we have the option
.Switch:
    .quad   .L31
	.quad   .L3233
	.quad   .L3233
	.quad   .L34 #invalid
	.quad   .L35
	.quad   .L36
	.quad   .L37
.section .text

 .globl run_func
 .type run_func, @function
 run_func:
 #rdi-int option, rsi- p1, rdx-p2
	pushq   %rbp
    movq    %rsp, %rbp  		#  current bottom
    leaq    -31(%rdi), %rdi		# algin option
    cmpq    $6, %rdi			# check if the option is valid
    ja      .L34				# default case
    jmp     *.Switch(, %rdi, 8) # go to jump table [option]
	
.L31:

	# getting 2 lengths
	movq	 %rsi, %rdi
	call pstrlen
	movq	 %rax, %rsi
	movq	 %rdx, %rdi
	call pstrlen
	
	#len1 rsi, len2 rax
	# print format
	movq	 $format_print_for_length, %rdi
	movq	 %rax, %rdx
	xorq	 %rax, %rax
	andq	 $~0xF, %rsp
	call	 printf
	
	jmp DONE


.L3233:
    # rdi-int option, rsi- p1, rdx-p2
    pushq	 %rdx
    pushq	 %rsi
    subq	 $2, %rsp                  
	movq	 $format_scanf_for_char, %rdi         
	leaq	 -18(%rbp), %rsi
    andq	 $~0xF, %rsp
    xorq	 %rax, %rax  
	call	 scanf
    movq	 $format_scanf_for_char, %rdi 
	leaq	 -17(%rbp), %rsi
    xorq	 %rax, %rax                  
	call	 scanf

	# new is in rax, old in r12
    movq	 -16(%rbp), %rdi # pstring
	movzbq	 -18(%rbp), %rsi # old char
	movzbq	 -17(%rbp), %rdx # new char
	call	 replaceChar
	# in rax we have p1 after change
	movq	 %rax, %r10

	# old- r12, new-rdx, p1-r10, p2-r9
	movq	 -8(%rbp), %rdi # p2
	movzbq	 -18(%rbp), %rsi
    movzbq	 -17(%rbp), %rdx # new char
	call	 replaceChar
	# p2 is in rax

	# old- -18(%rbp), new- -17(%rbp), p1-r10, p2-rax
	leaq	 1(%r10), %r10
	leaq	 1(%rax), %rax
	movq	 $format_print_for_replace, %rdi
	movzbq	 -18(%rbp), %rsi
	movzbq	 -17(%rbp), %rdx
	movq	 %r10, %rcx
	movq	 %rax, %r8
	xorq	 %rax, %rax
	andq	 $~0xF, %rsp
	call	 printf
	jmp		 DONE


.L35:
	# rdi-int option, rsi- p1, rdx-p2
	pushq	 %rdx
    pushq	 %rsi
    subq	 $16, %rsp                  
	movq	 $format_scanf_for_int, %rdi         
	leaq	 -32(%rbp), %rsi
    andq	 $~0xF, %rsp
    xorq	 %rax, %rax  
	call	 scanf
    movq	 $format_scanf_for_int, %rdi 
	leaq	 -24(%rbp), %rsi
    xorq	 %rax, %rax                  
	call	 scanf
	popq	 %rsi
	popq	 %rdx


    movq	 -16(%rbp), %rdi # pstring 1
    movq	 -8(%rbp), %rsi # pstring 2
	movq	 -32(%rbp), %rdx # i
	movq	 -24(%rbp), %rcx #j
	call	 pstrijcpy
 
	movq	 %rax, %r10
	movq	 %r10, %rdi
	call	 pstrlen
	leaq	 1(%r10), %r10
	#in r10 we got the pt1, in rax- lenp1, p2 in -8(%rbp)
	movq	 $format_print_for_pstrijcpy, %rdi
	movq	 %rax, %rsi
	movq	 %r10, %rdx
	xorq	 %rax, %rax
	andq	 $~0xF, %rsp
	call	 printf


	movq	 -8(%rbp), %rdi
	call	 pstrlen
	movq	 %rax, %r14
	#len2-r14 , p2--8(%rbp)

	xorq %r10, %r10
	movq 	 -8(%rbp), %r10
	leaq	 1(%r10), %r10

	movq	 $format_print_for_pstrijcpy, %rdi
	movq	 %r14, %rsi
	movq	 %r10, %rdx
	xorq	 %rax, %rax
	andq	 $~0xF, %rsp
	call	 printf

	jmp DONE

.L36:
	# rdi-int option, rsi- p1, rdx-p2
	# Pstring* swapCase(Pstring* pstr)

	pushq	 %rdx
	movq	 %rsi, %rdi
	call	 swapCase
	popq	 %rdx
	pushq	 %rax

	# in rax we have p1 after change

	movq	 %rdx, %rdi
	call	 swapCase
	pushq	 %rax
	
	# len1-r13, p1-rax
	popq	 %r8
	#r8 there is p1 after change, 

	popq	 %rdx
	movq	 %rdx, %rdi
	call	 pstrlen 
	movq	 $format_swap, %rdi
	movq	 %rax, %rsi
	incq	 %rdx
	movzbq	 (%r8), %rcx
	incq	 %r8
	xorq	 %rax, %rax
	andq	 $~0xF, %rsp
	call	 printf

	jmp DONE

.L37:
	
	pushq	 %rdx
    pushq	 %rsi
    subq	 $16, %rsp                  
	movq	 $format_scanf_for_int, %rdi         
	leaq	 -32(%rbp), %rsi
    andq	 $~0xF, %rsp
    xorq	 %rax, %rax  
	call	 scanf
    movq	 $format_scanf_for_int, %rdi 
	leaq	 -24(%rbp), %rsi
    xorq	 %rax, %rax                  
	call	 scanf
	popq	 %rsi
	popq	 %rdx


    movq	 -16(%rbp), %rdi # pstring 1
    movq	 -8(%rbp), %rsi # pstring 2
	movq	 -32(%rbp), %rdx # i
	movq	 -24(%rbp), %rcx #j

	call	 pstrijcmp
 
	#in rax- compare result
	
	movq	 $format_cmp, %rdi
	movq	 %rax, %rsi
	xorq	 %rax, %rax
	andq	 $~0xF, %rsp
	call	 printf

	jmp DONE

.L34:
	andq	 $~0xF, %rsp
	movq	 $format_print_invalid, %rdi
	xorq	 %rax, %rax
	call	 printf


DONE:
	movq	 %rbp, %rsp
	popq	 %rbp
	ret

