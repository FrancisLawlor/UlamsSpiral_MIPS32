# Student Name: Francis Lawlor
# Student Number: 14461158

		.data
Pixels:		.space 262144					# Allocate space for array to store words corresponding to pixel colours
Primes:		.space 65025					# Allocate space for array to store prime numbers

		.text						
		.globl	main
		
main:
    		jal	ClearScreen				# Change pixels to white
    		jal	ClearMemory				# Clear memory in Primes array
    		jal	CalculatePrimes				# Calculate Primes
    		jal	DisplaySpiral				# Display Spiral
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
    		
ClearMemory:
		la	$s0, Primes				# Load address to populate memory with zeroes
		add	$s0, $s0, 2				# First two bytes are not populated, as per algorithm
		addi	$s3, $zero, 0				# Store zero for use in storing zeros in FindPrime
		addi	$s5, $zero, 2				# Store minimum value, 2 (used as counter)
		addi	$s7, $zero, 65025			# Store maximum value, 1000 (used for guard)
		
StoreZero:	sb	$s3, ($s0)				# Store zero at current byte in $s0
		addi	$s0, $s0, 1				# Move to next byte
		addi	$s5, $s5, 1				# Increment counter
		bne	$s5, $s7, StoreZero			# Loop until counter reaches maximum value
		
		jr	$ra					# End subroutine
		
CalculatePrimes:
		la	$s0, Primes				# set data pointer
		li      $s1, 2                  		# set the current base
		li      $s2, 1                 	 		# strikeout constant
		li      $s3, 65026              			# set end of array + 1
		li      $s4, 32769                		# set last base + 1
loopBase:	add	$s5, $s1, $s1				# copy 2*base to the current value
loopSweep:	add	$t0, $s0, $s5				# calculate the address of the current byte
		sb      $s2, 0($t0)				# strike out the current byte
		add	$s5, $s5, $s1				# increase the current value by the current base
		blt	$s5, $s3, loopSweep			# repeat until current value > limit
		addi	$s1, $s1, +1				# next base
		blt	$s1, $s4, loopBase			# repeat until base > limit/2
		
		jr	$ra					# End subroutine
		
DisplaySpiral:
		la	$t0, Pixels
		addi	$t0, $t0, 131580			# Curr = 131580
		addi	$t1, $zero, +1				# x = 1
		add	$t2, $zero, 256				# Width
		addi	$t4, $zero, 500				# Store hexadecimal value for white in register $t3
		addi	$t5, $zero, 0				# Counter for iterating through Primes
		la	$t6, Primes				# Load address for Primes array
		#sw	$t3, 0($t0)				# Store word corresponding to white colour in Pixels array
Outerloop:	

		# Setup for LoopRight
		addi	$t3, $zero, 0
LoopRight:
		## Do stuff
		add	$t6, $t6, $t5
		lb	$t7, 0($t6)
		bne	$t7, 0, skip1
		sw	$t4, 0($t0)
		
skip1:		addi	$t0, $t0, 4				# Move right.
		addi	$t3, $t3, 1
		addi	$t6, $t6, 1				# Increment Primes array
		bne	$t3, $t1, LoopRight

		# Setup for LoopUp
		addi	$t3, $zero, 0
LoopUp:
		## Do stuff
		add	$t6, $t6, $t5				# Move to next byte in Primes
		lb	$t7, 0($t6)				# Load current byte from Primes
		bne	$t7, 0, skip2				# If current byte is not equal to 0
		sw	$t4, 0($t0)				# Save word in current element of grid
				
skip2:		addi	$t0, $t0, -1024				# Move up.
		addi	$t3, $t3, 1
		addi	$t6, $t6, 1				# Increment Primes array
		bne	$t3, $t1, LoopUp

		# Setup for LoopLeft
		addi	$t1, $t1, 1				# x++
		addi	$t3, $zero, 0
		
		beq	$t1, 256, FinishSpiral
LoopLeft:
		## Do stuff
		add	$t6, $t6, $t5				# Move to next byte in Primes
		lb	$t7, 0($t6)				# Load current byte from Primes
		bne	$t7, 0, skip3				# If current byte is not equal to 0
		sw	$t4, 0($t0)				# Save word in current element of grid

		#sw	$t4, 0($t0)
		
skip3:		addi	$t0, $t0, -4				# Move left.
		addi	$t3, $t3, 1
		addi	$t6, $t6, 1				# Increment Primes array
		bne	$t3, $t1, LoopLeft
		
		# Setup for LoopDown
		addi	$t3, $zero, 0
LoopDown:

		## Do stuff
		add	$t6, $t6, $t5				# Move to next byte in Primes
		lb	$t7, 0($t6)				# Load current byte from Primes
		bne	$t7, 0, skip4				# If current byte is not equal to 0
		sw	$t4, 0($t0)	
		
skip4:		addi	$t0, $t0, 1024				# Move left.
		addi	$t3, $t3, 1
		addi	$t6, $t6, 1				# Increment Primes array
		bne	$t3, $t1, LoopDown
		
		addi	$t1, $t1, 1
		bne	$t1, $t2, Outerloop

		addi	$t3, $zero, 0
FinishSpiral:	

		## Do stuff
		sw	$t4, 0($t0)
		
		addi	$t0, $t0, -4				# Move left.
		addi	$t3, $t3, 1
		bne	$t3, $t1, FinishSpiral
		
		jr	$ra
