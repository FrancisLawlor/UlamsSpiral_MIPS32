
		.data
Pixels:		.space 262144
		.text						
		.globl	main
		
main:
		la	$t0, Pixels
		li	$t1, 0
		li	$t2, 65536
		
loop:
		sw	$t1, 0($t0)
		
		addi	$t0, $t0, 4
    		addi	$t1, $t1, 1
    		
    		bne $t1, $t2, loop 
    		
    		li	$v0, 10
    		syscall