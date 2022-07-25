.eqv N 30

.data
Vetor:  
	.word   9
        .word   2
        .word   5
        .word   1
        .word   8
        .word   2
        .word   4
        .word   3
        .word   6
        .word   7
        .word   10
        .word   2
        .word   32
        .word   54
        .word   2
        .word   12
        .word   6
        .word   3
        .word   1
        .word   78
        .word   54
        .word   23
        .word   1
        .word   54
        .word   2
        .word   65
        .word   3
        .word   6
        .word   55
        .word   31

.text	
MAIN:	la a0,Vetor
	li a1,N
	jal SHOW

	la a0,Vetor
	li a1,N
	jal SORT

	la a0,Vetor
	li a1,N
	jal SHOW

	li a7,10
	ecall


# 7
SWAP:	slli t1,a1,2
	add t1,a0,t1
	lw t0,0(t1)
	lw t2,4(t1)
	sw t2,0(t1)
	sw t0,4(t1)
	ret

SORT:	addi sp,sp,-20 # 9
	sw ra,16(sp)
	sw s3,12(sp)
	sw s2,8(sp)
	sw s1,4(sp)
	sw s0,0(sp)
	mv s2,a0	# endereço do vetor
	mv s3,a1	# tamanho maximo
	mv s0,zero	# contador

for1:	bge s0,s3,exit1	# i >= N -> n+1
	addi s1,s0,-1	# j = i-1 -> n
	
for2:	blt s1,zero,exit2 # j < 0 ? exit2 : continua 1,2

	slli t1,s1,2 # t1 = j * 4
	add t2,s2,t1 # t2 = endereço + j*4
	lw t3,0(t2)  # t3 <- (t2)
	lw t4,4(t2)  # t4 <- 4(t2)
	bge t4,t3,exit2 # t4 >= t3 ? exit2 : continua
	mv a0,s2 # a0 = endereço
	mv a1,s1 # a1 = tamanho
	jal SWAP # Nunca Ocorre
	addi s1,s1,-1 # j = j-1
	j for2
	# 2 instruções -> n vezes
exit2:	addi s0,s0,1 
	j for1
	
	# 6 instruções
exit1: 	lw s0,0(sp)
	lw s1,4(sp)
	lw s2,8(sp)
	lw s3,12(sp)
	lw ra,16(sp)
	addi sp,sp,20
	ret

SHOW:	mv t0,a0
	mv t1,a1
	mv t2,zero

loop1: 	beq t2,t1,fim1
	li a7,1
	lw a0,0(t0)
	ecall
	li a7,11
	li a0,9
	ecall
	addi t0,t0,4
	addi t2,t2,1
	j loop1

fim1:	li a7,11
	li a0,10
	ecall
	ret

	
	
	
