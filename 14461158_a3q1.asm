# Student Name: Francis Lawlor
# Student Number: 14461158

		.data
Pixels:		.space 262144					# Allocate space for array to store words corresponding to pixel colours
		.text						
		.globl	main
		
main:
    		jal	ClearScreen				# Change pixels to white
    		li	$v0, 10
    		syscall

ClearScreen:
		la	$t0, Pixels				# Load address of array in which pixel colours are stored
		li	$t1, 0					# Set counter to 0
		li	$t2, 65536				# Store maximum value for counter
		addi	$t3, $zero, 0xFFFFFF			# Store hexadecimal value for white in register $t3
		
loop:
		sw	$t3, 0($t0)				# Store word corresponding to white colour in Pixels array
		
		addi	$t0, $t0, 4				# Increment to next elemen in Pixels array
    		addi	$t1, $t1, 1				# Increment counter
    		
    		bne	$t1, $t2, loop				# While counter is less than 65536 continue to loop
    		jr	$ra					# End subroutine
		
