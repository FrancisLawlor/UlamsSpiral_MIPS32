		.data
Pixels:		.space 262144					# Allocate space for array to store words corresponding to pixel colours
Primes:		.space 65025					# Allocate space for array to store prime numbers

		.text						
		.globl	main
		
main:
		la	$a0, Pixels				# Load address of Pixels array to be passed to ClearScreen subroutine
    		jal	ClearScreen				# Change pixels to white
    		la	$a0, Primes				# Load address of Primes array to be passed to ClearMemory subroutine
    		jal	ClearMemory				# Clear memory in Primes array
    		la	$a0, Primes				# Load address of Primes array to be passed to CalculatePrimes subroutine
    		jal	CalculatePrimes				# Calculate Primes
    		la	$a0, Pixels				# Load address of Pixels array to be passed to DisplaySpiral subroutine
    		la	$a1, Primes				# Load address of Primes array to be passed to DisplaySpiral subroutine
    		jal	DisplaySpiral				# Display Spiral
    		
    		li	$v0, 10
    		syscall

ClearScreen:
		li	$t1, 0					# Set counter to 0
		li	$t2, 65536				# Store maximum value for counter
		addi	$t3, $zero, 0xFFFFFF			# Store hexadecimal value for white in register $t3
		
loop:
		sw	$t3, 0($a0)				# Store word corresponding to white colour in Pixels array
		
		addi	$a0, $a0, 4				# Increment to next elemen in Pixels array
    		addi	$t1, $t1, 1				# Increment counter
    		
    		bne	$t1, $t2, loop				# While counter is less than 65536 continue to loop
    		
    		jr	$ra					# End subroutine
    		
ClearMemory:
		add	$a0, $a0, 2				# First two bytes are not populated, as per algorithm
		addi	$s3, $zero, 0				# Store zero for use in storing zeros in FindPrime
		addi	$s5, $zero, 2				# Store minimum value, 2 (used as counter)
		addi	$s7, $zero, 65025			# Store maximum value, 1000 (used for guard)
		
StoreZero:	sb	$s3, ($a0)				# Store zero at current byte in $s0
		addi	$a0, $a0, 1				# Move to next byte
		addi	$s5, $s5, 1				# Increment counter
		bne	$s5, $s7, StoreZero			# Loop until counter reaches maximum value
		
		jr	$ra					# End subroutine
		
CalculatePrimes:
		li      $s1, 2                  		# Set the current base
		li      $s2, 1                 	 		# Strikeout constant
		li      $s3, 65026              		# Set end of array + 1
		li      $s4, 32769                		# Set last base + 1
LoopBase:	add	$s5, $s1, $s1				# Copy 2*base to the current value
LoopSweep:	add	$t0, $a0, $s5				# Calculate the address of the current byte
		sb      $s2, 0($t0)				# Strike out the current byte
		add	$s5, $s5, $s1				# Increase the current value by the current base
		blt	$s5, $s3, LoopSweep			# Repeat until current value > limit
		addi	$s1, $s1, +1				# Next base
		blt	$s1, $s4, LoopBase			# Repeat until base > limit/2
		
		jr	$ra					# End subroutine
		
DisplaySpiral:
		addi	$a0, $a0, 131580			# Set initial word for our spiral
		addi	$t1, $zero, 1				# Initialise to 1 the variable which keeps track of how many moves are possible in each direction.
		add	$t2, $zero, 256				# Store width for use in OuterLoop
		addi	$t4, $zero, 500				# Store colour other than white for marking primes.
		addi	$t5, $zero, 0				# Counter for iterating through Primes

OuterLoop:	
		bne	$t5, 0, LoopRightSetup			# If Primes counter is not equal to 0, jump straight to first loop
		addi	$t5, $t5, 2				# Set Primes counter to 2
		addi	$a0, $a0, 4				# Move right in grid
		addi	$a0, $a0, -1024				# Move up in grid
		j	Start					# Jump past first two loops to avoid output for 0 and 1

LoopRightSetup:		
		# Setup for LoopRight
		addi	$t3, $zero, 0				# Initialise LoopRight counter to 0
		
LoopRight:
		addi	$t5, $t5, 1				# Increment Primes counter
		lb	$t7, 0($a1)				# Load current byte from Primes
		bne	$t7, 0, skip1				# If current byte is not 0 then skip the storing step
		sw	$t4, 0($a0)				# Store different colour in current word of grid
		
skip1:		addi	$a0, $a0, 4				# Move right in grid
		addi	$t3, $t3, 1				# Increment LoopRight counter
		addi	$a1, $a1, 1				# Move to next element in Primes
		bne	$t3, $t1, LoopRight			# Reiterate while $t3 is less than $t1

		beq	$t5, 65025, FinishSpiral		# 65025 should be reached by the counter before the final upward maneuver
		
		# Setup for LoopUp
		addi	$t3, $zero, 0				# Initialise LoopUp counter to 0
LoopUp:
		addi	$t5, $t5, 1				# Increment Primes counter
		lb	$t7, 0($a1)				# Load current byte from Primes
		bne	$t7, 0, skip2				# If current byte is not 0 then skip the storing step
		sw	$t4, 0($a0)				# Store different colour in current word of grid
				
skip2:		addi	$a0, $a0, -1024				# Move up in grid
		addi	$t3, $t3, 1				# Increment LoopUp counter
		addi	$a1, $a1, 1				# Move to next element in Primes
		bne	$t3, $t1, LoopUp			# Reiterate while $t3 is less than $t1

Start:								# Start label refers to beginning of traversal of grid after skipping 0 and 1
		addi	$t1, $t1, 1				# Increment number of iterations for traversal loops as number of positions changes each time direction changes twice
		
		# Setup for LoopLeft
		addi	$t3, $zero, 0				# Initialise LoopLeft counter to 0
		
LoopLeft:
		addi	$t5, $t5, 1				# Increment Primes counter
		lb	$t7, 0($a1)				# Load current byte from Primes
		bne	$t7, 0, skip3				# If current byte is not 0 then skip the storing step
		sw	$t4, 0($a0)				# Store different colour in current word of grid
		
skip3:		addi	$a0, $a0, -4				# Move left in grid
		addi	$t3, $t3, 1				# Increment LoopLeft counter
		addi	$a1, $a1, 1				# Move to next element in Primes
		bne	$t3, $t1, LoopLeft			# Reiterate while $t3 is less than $t1
		
		# Setup for LoopDown
		addi	$t3, $zero, 0				# Initialise LoopDown counter to 0
LoopDown:
		addi	$t5, $t5, 1				# Increment Primes counter.
		lb	$t7, 0($a1)				# Load current byte from Primes
		bne	$t7, 0, skip4				# If current byte is not 0 then skip the storing step
		sw	$t4, 0($a0)				# Store different colour in current word of grid
		
skip4:		addi	$a0, $a0, 1024				# Move down in grid
		addi	$t3, $t3, 1				# Increment LoopDown counter
		addi	$a1, $a1, 1				# Move to next element in Primes
		bne	$t3, $t1, LoopDown			# Reiterate while $t3 is less than $t1
		
		addi	$t1, $t1, 1				# Increment OuterLoop counter
		bne	$t1, $t2, OuterLoop			# Reiterate OuterLoop while $t1 is less than $t2
		
FinishSpiral:	

		jr	$ra					# End subroutine