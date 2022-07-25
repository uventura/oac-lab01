.data
	.include "sprites/background.data" 	# LABEL: BACKGROUND 
	.include "sprites/HOLE.data"		# LABEL: HOLE

	.include "sprites/whiteBorder.data"
	.include "sprites/blackBorder.data"
	.include "sprites/PIN3.data"
	.include "sprites/PIN4.data"
	.include "sprites/PIN5.data"
	.include "sprites/PIN6.data"
	.include "sprites/PIN7.data"
	.include "sprites/PIN8.data"
	.include "sprites/PIN9.data"
	.include "sprites/PIN10.data"
	.include "sprites/PIN11.data"
	.include "sprites/PIN12.data"
	.include "sprites/persona.data"
	
	CURRENTS_PIN: 	.string "##########"
	CORRECT_ANSWER: .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
.text
MAIN:
	.eqv N_PINS, s1
	.eqv WON, s2
	.eqv BASE_COLUMN, s3
	.eqv CURRENT_ROW, s4
	.eqv CURRENT_COL, s5
	.eqv CHARACTER_COL, s6
	.eqv PIN_SELECTED, s7
	
	li N_PINS, 5
	li WON, 0
	li CURRENT_ROW, 2
	li CURRENT_COL, 7
	li BASE_COLUMN, 7
	li CHARACTER_COL, 7
	li PIN_SELECTED, 0

	NEW_LEVEL:
	jal START_LEVEL
	jal GENERATE_ORDER
	
	KEYBOARD:
		li t0, 0xFF200000
		lw t1, 0(t0)
		andi t1, t1, 0x00000001
		
		# Change Pin
		beqz t1, KEYBOARD
		jal KEY_PRESSED
		j KEYBOARD
	END_KEYBOARD:
	
	# End Program
	li a7, 10
	ecall

GENERATE_ORDER:
	li t0, 0
	la t1, CORRECT_ANSWER
	mv a1, N_PINS
	
	LOOP_GENERATION:
		beq t0, N_PINS, END_LOOP_GENERATION
		
		li a7, 42
		ecall
		
		sb a0, 0(t1)
		addi t1, t1, 1
		addi t0, t0, 1
		j LOOP_GENERATION
		
	END_LOOP_GENERATION:
	ret
	
KEY_PRESSED:
	li t0, 0xFF200004
	lb t0, 0(t0)
	
	la t3, CURRENTS_PIN
	la a4, CURRENTS_PIN
	
	li t1, 'w'
	beq t0, t1, PRESS_W
	
	li t1, 's'
	beq t0, t1, PRESS_S
	
	li t1, 'a'
	beq t0, t1, PRESS_A
	
	li t1, 'd'
	beq t0, t1, PRESS_D
	
	li t1, 'p'
	beq t0, t1, END_GUESS
	
	ret
	
END_GUESS:
	j CORRECT_ANSWER_ANALYSIS

PRESS_W:
	addi PIN_SELECTED, PIN_SELECTED, 1
	bgt PIN_SELECTED, N_PINS, RESET_PRESS_W
	
	addi sp, sp, -4
	sw ra, 0(sp)
	
	jal CHANGE_PIN
	
	lw ra, 0(sp)
	addi sp, sp, 4
	
	ret
	
RESET_PRESS_W:
	li PIN_SELECTED, 0
	j PRESS_W
	
PRESS_S:
	addi PIN_SELECTED, PIN_SELECTED, -1
	beqz PIN_SELECTED, RESET_PRESS_S
	
	addi sp, sp, -4
	sw ra, 0(sp)
	
	jal CHANGE_PIN
	
	lw ra, 0(sp)
	addi sp, sp, 4
	
	ret
RESET_PRESS_S:
	mv PIN_SELECTED, N_PINS
	addi PIN_SELECTED, PIN_SELECTED, 1
	j PRESS_S
	
PRESS_A:
	addi CURRENT_COL, CURRENT_COL, -1
	blt CURRENT_COL, BASE_COLUMN, RESET_PRESS_A
	
	j RELOAD_CHARACTER
	
	ret
	
RESET_PRESS_A:
	add t0, N_PINS, BASE_COLUMN
	mv CURRENT_COL, t0
	j PRESS_A
	
PRESS_D:
	addi CURRENT_COL, CURRENT_COL, 1
	add t0, N_PINS, BASE_COLUMN
	beq CURRENT_COL, t0, RESET_PRESS_D
	
	j RELOAD_CHARACTER
	
	ret
	
RESET_PRESS_D:
	mv CURRENT_COL, BASE_COLUMN
	addi CURRENT_COL, CURRENT_COL, -1
	j PRESS_D

RELOAD_CHARACTER:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	li a0, 1
	mv a1, CHARACTER_COL
	la a3, BACKGROUND
	jal PRINT_BLOCK
	
	mv a1, CURRENT_COL
	la a3, persona
	jal PRINT_BLOCK
	
	mv CHARACTER_COL, CURRENT_COL
	
	lw ra, 0(sp)
	addi sp, sp, 4
	
	ret
	
CHANGE_PIN:
	mv a0, CURRENT_ROW
	mv a1, CURRENT_COL
	
	addi sp, sp, -4
	sw ra, 0(sp)
	
	#CURRENTS_PIN
	la t1, CURRENTS_PIN
	mv t0, CURRENT_COL
	sub t0, t0, BASE_COLUMN
	add t1, t1, t0
	
	li t0, 1
	beq PIN_SELECTED, t0, PIN_1

	li t0, 2
	beq PIN_SELECTED, t0, PIN_2
	
	li t0, 3
	beq PIN_SELECTED, t0, PIN_3
	
	li t0, 4
	beq PIN_SELECTED, t0, PIN_4
	
	li t0, 5
	beq PIN_SELECTED, t0, PIN_5
	
	li t0, 6
	beq PIN_SELECTED, t0, PIN_6
	
	li t0, 7
	beq PIN_SELECTED, t0, PIN_7
	
	li t0, 8
	beq PIN_SELECTED, t0, PIN_8
	
	li t0, 9
	beq PIN_SELECTED, t0, PIN_9
	
	li t0, 10
	beq PIN_SELECTED, t0, PIN_10
	
END_CHANGE_PIN:
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
PIN_1:	
	li t2, 'a'
	sb t2, 0(t1)
	la a3, PIN3
	j CHANGE_PIN_COLOR
PIN_2:
	li t2, 'b'
	sb t2, 0(t1)
	la a3, PIN4
	j CHANGE_PIN_COLOR
PIN_3:
	li t2, 'c'
	sb t2, 0(t1)
	la a3, PIN5
	j CHANGE_PIN_COLOR
PIN_4:
	li t2, 'd'
	sb t2, 0(t1)
	la a3, PIN6
	j CHANGE_PIN_COLOR
PIN_5:
	li t2, 'e'
	sb t2, 0(t1)
	la a3, PIN7
	j CHANGE_PIN_COLOR
PIN_6:
	li t2, 'f'
	sb t2, 0(t1)
	la a3, PIN8
	j CHANGE_PIN_COLOR
PIN_7:
	li t2, 'g'
	sb t2, 0(t1)
	la a3, PIN9
	j CHANGE_PIN_COLOR
PIN_8:
	li t2, 'h'
	sb t2, 0(t1)
	la a3, PIN10
	j CHANGE_PIN_COLOR
PIN_9:
	li t2, 'i'
	sb t2, 0(t1)
	la a3, PIN11
	j CHANGE_PIN_COLOR
PIN_10:
	li t2, 'j'
	sb t2, 0(t1)
	la a3, PIN12

CHANGE_PIN_COLOR:
	jal PRINT_BLOCK
	j END_CHANGE_PIN

CORRECT_ANSWER_ANALYSIS:
	la t0, CURRENTS_PIN
	li t1, 0
	MADE_ALL_GUESSES:
		beq t1, N_PINS, END_MADE_ALL_GUESSES
		li t3, '#'
		lb t2, 0(t0)
		beq t2, t3, INVALID_GUESS
		addi t0, t0, 1
		addi t1, t1, 1
		j MADE_ALL_GUESSES
	END_MADE_ALL_GUESSES:
	
	addi sp, sp, -4
	sw ra, 0(sp)
	
	li t0, 0
	la t1, CURRENTS_PIN
	la t2, CORRECT_ANSWER
	mv a0, CURRENT_ROW
	
	li a4, 0
	
	CORRECTION:
		beq t0, N_PINS, END_CORRECTION
		mv a1, BASE_COLUMN
		add a1, a1, t0
		
		lb t3, 0(t1)
		li t4, 'a'
		sub t3, t3, t4
		lb t4, 0(t2)
		
		beq t3, t4, BLACK_PIN
		la t5, CORRECT_ANSWER
		li t4, 0
		CORRECTION_2:
			beq t4, N_PINS, END_CORRECTION_2
			lb t6, 0(t5)
			beq t6, t3, WHITE_PIN
			addi t4, t4, 1
			addi t5, t5, 1
			j CORRECTION_2
		END_CORRECTION_2:
		j JUMP_CORRECTION
		
		BLACK_PIN:
			addi a4, a4, 1
			la a3, blackBorder	
			j CORRECTION_BLOCK
		WHITE_PIN:
			la a3, whiteBorder
		CORRECTION_BLOCK:
			addi sp, sp, -12
			sw t0, 0(sp)
			sw t1, 4(sp)
			sw t2, 8(sp)
			mv a0, CURRENT_ROW
			jal PRINT_BLOCK
			lw t0, 0(sp)
			lw t1, 4(sp)
			lw t2, 8(sp)
			addi sp, sp, 12
		JUMP_CORRECTION:	
		addi t0, t0, 1
		addi t1, t1, 1
		addi t2, t2, 1
		j CORRECTION
	END_CORRECTION:
	
	la t0, CURRENTS_PIN
	li t1, 0
	CLEAR_ANSWER:
		beq t1, N_PINS, END_CLEAR_ANSWER
		li t2, '#'
		sb t2, 0(t0)
		addi t0, t0, 1
		addi t1, t1, 1
		j CLEAR_ANSWER
	END_CLEAR_ANSWER:
	
	beq a4, N_PINS, WON_GAME
	
	mv CURRENT_COL, BASE_COLUMN
	addi CURRENT_ROW, CURRENT_ROW, 1
	
	li t0, 10
	beq CURRENT_ROW, t0, GAME_OVER
	
	lw ra, 0(sp)
	addi sp, sp, 4

INVALID_GUESS:
	ret

WON_GAME:
	li CURRENT_ROW, 2
	addi BASE_COLUMN, BASE_COLUMN, -1
	mv CURRENT_COL, BASE_COLUMN
	li PIN_SELECTED, 0
	addi N_PINS, N_PINS, 1
	
	li t0, 11
	beq N_PINS, t0, GAME_OVER
	
	j NEW_LEVEL

GAME_OVER:
	j MAIN
	
START_LEVEL:
	addi sp, sp, -4
	sw ra, 0(sp)
	
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
	
PRINT_HOLES:
	
	mv a0, CURRENT_ROW
	mv a1, CURRENT_COL
	la a3, HOLE
	li a4, 0
	li a5, 0
	
	LOOP_PRINT_HOLES:
		li t0, 10			# Number Attempts
		beq a5, t0, END_PRINT_HOLE
		
		jal PRINT_BLOCK
		
		addi a1, a1, 1
		addi a4, a4, 1
		beq a4, N_PINS, NEXT_HOLE_LINE
		j LOOP_PRINT_HOLES
		
		NEXT_HOLE_LINE:
		li a4, 0
		mv a1, CURRENT_COL
		addi a0, a0, 1
		addi a5, a5, 1
		j LOOP_PRINT_HOLES
		
	END_PRINT_HOLE:
	
PRINT_CHARACTER:
	li a0, 1
	mv a1, BASE_COLUMN
	mv CHARACTER_COL, BASE_COLUMN
	la a3, persona
	jal PRINT_BLOCK
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
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
