.data
	.include "sprites/background.data" 	# LABEL: BACKGROUND 
	.include "sprites/default-pin.data"	# LABEL: PIN
.text
	.eqv N_PINS, s1
	.eqv WON, s2
	.eqv CURRENT_ROW, s3
	.eqv CURRENT_COL, s4
	.eqv ATTEMPTS, s5
	.eqv N_ATTEMPTS, s6
	
	li N_PINS, 5
	li WON, 0
	li CURRENT_ROW, 2
	li CURRENT_COL, 7
	li ATTEMPTS, 10
	
	li a0, 0						# Row 
	li a1, 0						# Col
	la a3, BACKGROUND					# Background
	
	PRINT_BACKGROUND:
		li t0, 15
		beq a0, t0, END_PRINT_BACKGROUND
		
		jal PRINT_BLOCK
		
		addi a1, a1, 1
		li t0, 20
		beq a1, t0, NEXT_BACKGROUND_LINE
		j PRINT_BACKGROUND
		
		NEXT_BACKGROUND_LINE:
		li a1, 0
		addi a0, a0, 1
		j PRINT_BACKGROUND
		
	END_PRINT_BACKGROUND:
	
	mv a0, CURRENT_ROW
	mv a1, CURRENT_COL
	la a3, PIN
	li a4, 0
	li a5, 0
	PRINT_HOLES:
		beq a5, ATTEMPTS, END_PRINT_HOLE
		
		jal PRINT_BLOCK
		
		addi a1, a1, 1
		addi a4, a4, 1
		beq a4, N_PINS, NEXT_HOLE_LINE
		j PRINT_HOLES
		
		NEXT_HOLE_LINE:
		li a4, 0
		mv a1, CURRENT_COL
		addi a0, a0, 1
		addi a5, a5, 1
		j PRINT_HOLES
		
	END_PRINT_HOLE:
	
	# End Program
	li a7, 10
	ecall
	
PRINT_BLOCK:	# (a0 = Row, a1 = Col, a3 = Sprite Addr) => Don't Modifie a0,a1,a3
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
	add t0, t0, t1						# Block Initial Position
	
	mv t1, a3 						# Color Addr
	addi t1, t1, 8						
	
	li t2, 0						# Current Row
	li t3, 0						# Current Col
	li t4, 16						# Block Size
	
	PRINT_PIXEL:
		bge t2, t4, END_PRINT_PIXEL
		
		slli t5, t2, 6
		li t6, 5
		mul t5, t6, t5					# Select Pixel Row (320*PIXEL_ROW)
		add t5, t5, t3					# Select Pixel Col
		add t5, t5, t0					# VGA Addr.
		
		lb t6, 0(t1)					# Load Sprite Color
		sb t6, 0(t5)					# Print Color on Screen
		addi t3, t3, 1					# Increment Col
		addi t1, t1, 1					# Next Color
		
		li t5, 16
		blt t3, t5, PRINT_PIXEL				# if current_col != PRINT_PIXEL
		
		li t3, 0					# Reset Col
		addi t2, t2, 1					# Next Line
		
		j PRINT_PIXEL
		
	END_PRINT_PIXEL:
		ret
