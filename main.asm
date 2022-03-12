.data
	
.text
	li a0, 1		# Row 
	li a1, 1		# Col
	li a3, 0xFF		# Color
	jal PRINT_BLOCK
	
	# End Program
	li a7, 10
	ecall
	
PRINT_BLOCK:	# (a0 = Row, a1 = Col, a3 = Color)
	#slti t0, a0, 0
	#li t1, 15
	#slt t1, t1, t0
	#or t0, t0, t1
	#bnez t0, END_PRINT_PIXEL
	
	#slti t0, a1, 0
	#li t1, 15
	#slt t1, t1, t0
	#or t0, t0, t1
	#bnez t0, END_PRINT_PIXEL
	
	PRINT_BLOCK_MAIN:
	# Initial Position = 0xFF000000 + (col + 320.row) << 4 [Blocks Has 16*16]
	
	# 320.row = 2^6.5.row
	mv t0, a0
	slli t0, t0, 6
	li t1, 5
	mul t0, t0, t1
	
	# (col + 320.row) << 4
	add t0, t0, a1
	slli t0, t0, 4
	
	# 0xFF000000 + (col + 320.row) << 4
	li t1, 0xFF000000
	add t0, t0, t1
	
	mv t1, a3 						# Color
	li t2, 0						# Current Row
	li t3, 0						# Current Col
	li t4, 16						# Block Size
	
	.eqv ADDR_PIXEL_BASE t0
	.eqv PIXEL_COLOR t1
	.eqv PIXEL_ROW t2
	.eqv PIXEL_COL t3
	.eqv NUM_ROWS t4
	
	PRINT_PIXEL:
		bge PIXEL_ROW, NUM_ROWS, END_PRINT_PIXEL
		
		slli t5, PIXEL_ROW, 6
		li t6, 5
		mul t5, t6, t5					# Select Pixel Row (320*PIXEL_ROW)
		add t5, t5, t3					# Select Pixel Col
		add t5, t5, ADDR_PIXEL_BASE			# VGA Addr.
		
		sb PIXEL_COLOR, 0(t5)				# Print Color on Screen
		addi PIXEL_COL, PIXEL_COL, 1			# Increment Col
		
		li t5, 16
		blt PIXEL_COL, t5, PRINT_PIXEL			# if current_col != PRINT_PIXEL
		
		li PIXEL_COL, 0					# Reset Col
		addi PIXEL_ROW, PIXEL_ROW, 1			# Next Line
		
		j PRINT_PIXEL
		
	END_PRINT_PIXEL:
		ret