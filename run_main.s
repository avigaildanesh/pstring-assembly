# 213372063 Avigail Danesh
.section .rodata
format_scanf_for_int:   .string     " %d"
format_scanf_for_str:  .string     " %s"

.text
.globl run_main
.type run_main, @function
run_main:

    pushq	 %rbp
    movq	 %rsp, %rbp
	# 256*2, 3*8 

    subq	 $560, %rsp
	andq	 $~0xF, %rsp


	# scan from the user the first length
	movq	 $format_scanf_for_int, %rdi
	xorq	 %rax, %rax   
    leaq	 -560(%rbp), %rsi
    call	 scanf

	movzbq	 -560(%rbp), %rax
	movq	 $0, -255(%rbp, %rax, 1)
	movb	 %al, -256(%rbp)


	#scan from the user the first string
	movq	 $format_scanf_for_str, %rdi
	xorq	 %rax, %rax   
    leaq	 -255(%rbp), %rsi
    call	 scanf
	
	#scan from the user the sec length
	movq	 $format_scanf_for_int, %rdi
	leaq	 -560(%rbp), %rsi
	xorq	 %rax, %rax   
    call	 scanf
	movzbq	 -560(%rbp), %rax
	movq	 $0, -511(%rbp, %rax, 1)
	movb	 %al, -512(%rbp)
	

	#scan from the user the sec string
	movq	 $format_scanf_for_str, %rdi
	leaq	 -511(%rbp), %rsi
	xorq	 %rax, %rax   
    call	 scanf
	
	#scan the number of function
	movq	 $format_scanf_for_int, %rdi
	leaq	 -560(%rbp), %rsi
	xorq	 %rax, %rax  
    call	 scanf
	

	movzbq	 -560(%rbp), %rdi
	leaq	 -256(%rbp), %rsi
	leaq	 -512(%rbp), %rdx
	call	 run_func

	xorq	 %rax, %rax
	movq	 %rbp, %rsp
	popq	 %rbp
	ret
 
