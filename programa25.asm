#Programa le a quantidade de alunos e as 3 notas de cada um e calcula a média da turma, do aluno e a quantidade de alunos aprovados e reprovados
.data
numeroAlunos: .asciiz "Insira o numero de alunos: "
mediaAluno: .asciiz "M�dia do aluno "
alunosAprovados: .asciiz "Numero de alunos aprovados (media >= 6,0): "
alunosReprovados: .asciiz "Numero de alunos reprovados (media < 6,0): "
mediaSala: .asciiz "Media da sala: "
msg1: .asciiz "Insira a nota "
msg2: .asciiz " do aluno "
msg3: .asciiz ": "
quebraDeLinha: .asciiz "\n"
espaco: .asciiz " "
zero: .float 0.0
tres: .float 3.0
seis: .float 6.0

.text

main: 
	li $a2, 3			# $a2 = 3
	lwc1 $f7, tres			# carrega em $f7 = 3.0
	
	la $a0, numeroAlunos		# carrega o endere�o da string
	li $v0, 4			# c�digo de impress�o de string
	syscall				# imprime a string
	
	li $v0, 5			# leitura do numero de alunos
	syscall				# leitura do valor (retorna em $v0)
	
	move $a1, $v0			# $a1 recebe o valor lido
	mtc1 $a1, $f13			# $f13 = (float) $a1
  	cvt.s.w $f13, $f13		#converte f13 pra precisao simples do valor de f13
	
	mul $t0, $a1, $a2		# $t0 recebe a quantidade de alunos x 3(notas de cada aluno)
	mul $a0, $t0, 4			# $a0 = tamanho da matriz * 4
	li $v0, 9			# c�digo de aloca��o dinamica
	syscall				# aloca tamanho * 4 bytes (endere�o em $v0)
	
	li $t0, 0			# $t0 = 0
	la $a0, ($v0)			# $a0 aponta para $v0 (local onde a matriz esta alocada)
	
	jal leitura			# leitura ()
	move $a0, $v0			# move o endere�o da matriz para argumento $a0
	
	li $t5, 0			# contador de alunos reprovados
	li $t6, 0			# contador de alunos aprovados
	
	jal percorreLinhas		# percorreLinhas (), funcao que faz as verificacoes na matriz
	
	jal Resultados			#salta pra resultados
	
	li $v0, 10			# c�digo para finalizar o programa
	syscall				# finaliza o programa

	indice:	
		mul $v0, $t0, $a2	# i * numeroColunas
		add $v0, $v0, $t1	# (i * numeroColunas) + j
		sll $v0, $v0, 2		# [(i * numeroColunas) + j] * 4 (inteiro)
		add $v0, $v0, $a3	# soma o endere�o base de matriz
		jr $ra			# retorna para o caller

	leitura:
		subi $sp, $sp, 4	# espa�o para 1 item na pilha
		sw $ra, ($sp)		# salva o retorno para a main
		move $a3, $a0		# aux = endere�o base de matriz
	
		l:	
		la $a0, msg1		# carrega o endere�o da string
		li $v0, 4		# c�digo de impress�o de string
		syscall			# imprime a string
	
		move $a0, $t1		# valor de j para impressao
		addi $a0, $a0, 1	# $a0++
		li $v0, 1		# c�digo de impressao de inteiro
		syscall			# imprime j	
	
		la $a0, msg2		# carrega o endere�o da string
		li $v0, 4		# c�digo de impress�o de string
		syscall			# imprime a string
	
		move $a0, $t0		# valor de i para impressao
		addi $a0, $a0, 1	# $a0++
		li $v0, 1		# c�digo de impressao de inteiro
		syscall			# imprime i
	
		la $a0, msg3		# carrega o endere�o da string
		li $v0, 4		# c�digo de impress�o de string
		syscall			# imprime a string
	
		li $v0, 6		# codigo de leitura de float
		syscall			# leitura do valor (retorna em $v0)
	
		mov.s $f2, $f0		# move pra f2 com precisao simples o valor de f0
	
		jal indice		# calcula o endere�o de matriz[i][j]
	
		s.s $f2, ($v0)		# armazena o valor de f2 na posicao calculada
	
		addi $t1, $t1, 1	# j++
		blt $t1, $a2, l		# if (j < numeroColunas1) goto 1
		li $t1, 0		# j = 0
	
		addi $t0, $t0, 1	# i++
		blt $t0, $a1, l		# if (i < numeroLinhas) goto 1
		li $t0, 0		# i = 0
	
		lw $ra, ($sp)		# recupera o retorno para a main
		addi $sp, $sp, 4	# libera o espa�o na pilha
		move $v0, $a3		# endere�o da matriz para retorno
	
		jr $ra

	percorreLinhas:
		subi $sp, $sp, 4	# espa�o para 1 item na pilha
		sw $ra, ($sp)		# salva o retorno para a main
		move $a3, $a0		# a3 = endere�o base de matriz
		li $s0, 0		# media turma
		li $s1, 0		# numero reprovados
		li $s2, 0		# numero aprovados
		li $t4, 0		# variavel intermediaria: media aluno
		lwc1 $f8, zero		# $f8 = 0.0
	
		la $a0, quebraDeLinha	# carrega o endere�o da string
		li $v0, 4		# c�digo de impress�o de string
		syscall			# imprime a string
	
	pL:	jal indice		# calcula o endere�o de matriz[i][j]
	
	l.s $f0, ($v0)			# $f0 = valor de matriz[i][j]
	add.s $f3, $f3, $f0		# soma da nota do aluno $f3 = $f3 + $f0
	
	addi, $t1, $t1, 1		# i++
	blt $t1, $a2, pL		# if (i < numeroLinhas) goto pL
	
continueLinhas:
	div.s $f4, $f3, $f7	# $f4 = $f3/$f7
	mov.s $f12, $f4		# move pra f12 o valor de f4
	add.s $f8, $f8, $f4	# f8 = $f8 + $f4
	
	lwc1 $f9, seis		# $f9 = 6.0
	
	jal definirSituacao	# definirSituacao ()
	
	la $a0, mediaAluno	# carrega o endere�o da string
	li $v0, 4		# c�digo de impress�o de string
	syscall			# imprime a string
	
	move $a0, $t0		# $a0 = $t0
	addi $a0, $a0, 1	# $a0++
	li $v0, 1		# c�digo de impressao de inteiro
	syscall			# imprime i
	
	la $a0, msg3		# carrega o endere�o da string
	li $v0, 4		# c�digo de impress�o de string
	syscall			# imprime a string
	
	li $v0, 2		# c�digo de impressao de float
	syscall			# imprime i
				
	la $a0, espaco		# carrega o endere�o da string
	li $v0, 4		# c�digo de impressao de string
	syscall			# imprime a string
	
	la $a0, quebraDeLinha	# carrega o endere�o da string
	li $v0, 4		# c�digo de impress�o de string
	syscall			# imprime a string
	
	lwc1 $f3, zero		# $f3 = 0.0
	li $t1, 0 		# i = 0
	
	addi $t0, $t0, 1	# j++
	
	blt $t0, $a1, pL	# if (j < numeroColunas) goto pL
	
	li $t0, 0		# j = 0
	
	lw $ra, ($sp)		# recupera o endere�o de retorno pra main
	addi $sp, $sp, 4	# libera espa�o na pilha
	move $v0, $a3		# endere�o base da matriz para retorno
	
	jr $ra 			#retorna para a main
	
definirSituacao:
	c.lt.s $f4, $f9		# comparacao de precisao simples, se $f4 < t9
	bc1t reprovado		# branch if FP condition flag true, vai pra reprovado
	c.lt.s $f4, $f9		# else
	bc1f aprovado		# branch if FP condition flag false, vai pra aprovado

	jr $ra
	
aprovado:
	addi $t6, $t6, 1	# alunosAprovados++
	jr $ra

reprovado:
	addi $t5, $t5, 1	# alunosReprovados++
	jr $ra
	
Resultados:
	div.s $f8, $f8, $f13	# $f8 = $f8/$f13
	la $a0, mediaSala 	# carrega o endere�o da string
	li $v0, 4		# c�digo de impress�o de string
	syscall			# imprime a string
	
	mov.s $f12, $f8		# $f12 = $f8
	li $v0, 2		# c�digo de impressao de float
	syscall			# imprime i
	
	la $a0, quebraDeLinha	# carrega o endere�o da string
	li $v0, 4		# c�digo de impress�o de string
	syscall			# imrprime a string
	
	la $a0, alunosReprovados# carrega o endere�o da string
	li $v0, 4		# c�digo de impress�o de string
	syscall			# imprime a string
	
	move $a0, $t5		# $a0 = $t5
	li $v0, 1		# c�digo de impressao de inteiro
	syscall			# imprime i
	
	la $a0, quebraDeLinha	# carrega o endere�o da string
	li $v0, 4		# c�digo de impress�o de string
	syscall			# imprime a string
	
	la $a0, alunosAprovados	# carrega o endere�o da string
	li $v0, 4		# c�digo de impress�o de string
	syscall	
				
	move $a0, $t6		# $a0 = $t6
	li $v0, 1		# c�digo de impressao de inteiro
	syscall			# imprime i
	
	jr $ra