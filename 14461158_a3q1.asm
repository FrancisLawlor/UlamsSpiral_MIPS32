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
		addi	$s7, $zero, 1000			# Store maximum value, 1000 (used for guard)
		
StoreZero:	sb	$s3, ($s0)				# Store zero at current byte in $s0
		addi	$s0, $s0, 1				# Move to next byte
		addi	$s5, $s5, 1				# Increment counter
		bne	$s5, $s7, StoreZero			# Loop until counter reaches maximum value
		
		jr	$ra					# End subroutine
		
CalculatePrimes:
		# Setup before Sieve
		addi	$s5, $zero, 2				# Store minimum value, 2 (used as counter for outer loop)
		addi	$s7, $zero, 65025			# Store max value, 65025 (used for guard in outer loop)
		addi	$t0, $zero, 1				# Store number 1 for (used to mark composite numbers in Primes, and in branching condition)
		la	$s0, Primes				# Load address corresponding to Primes
		add	$s0, $s0, 2				# Move to third byte, in keeping with algorithm

OuterLoop:	beq	$s5, $s7, CalculatePrimes		# If counter reaches 65025, jump to Output

		lb	$t6, 0($s0)				# Load current byte from Primes for branching condition	
		beq	$t6, $t0, Increment			# If current byte contains 1 then jump to Increment
		
		addi	$t3, $zero, 2				# Store minimum value, 2 (used as counter for inner loop)
		
InnerLoop:	
		# Setup before multiplication (repeated addition)
		addi	$t2, $zero, 0				# Initialise counter to 0 (used to track number of additions)
		addi	$t8, $zero, 0				# Store 0 in register (used to store total during repeated addition)
		
Multiply:	add	$t8, $t8, $t3				# Add current value of inner loop counter to current total from repeated addition
		addi	$t2, $t2, 1				# Increment counter (used to track number of additions)
		bne	$t2, $s5, Multiply			# Check if the counter used to track number of additions is equal to outer loop counter
		
		bge	$t8, $s7, Increment			# If multiple of counters is greater than or equal to max value, jump to Increment
		
		la	$t7, Primes				# Load address for Primes
		add	$t7, $t7, $t8				# Add product of counters from inner loop and outer loop as offset from beginning of Primes
		sb	$t0, ($t7)				# Save 1 to position in Primes corresponding to calculated offset
		addi	$t3, $t3, 1				# Increment inner loop counter
		j	InnerLoop
		
Increment:	addi	$s0, $s0, 1				# Move to next byte in Primes
		addi	$s5, $s5, 1				# Increment outer loop counter
		j	OuterLoop
		
		jr	$ra					# End subroutine
		
