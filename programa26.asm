#Programa le uma string que representa um cpf no formato xxxyyyzzz-XX e informa se é um CPF valido ou não
.data
Cpf: .space 32
msg_ent: .asciiz "Informe o CPF: "
Sai0: .asciiz "CPF valido."
Sai1: .asciiz "CPF invalido."

.text
main:
    la $a0, msg_ent 			# Carrega o endereco da string
    li $v0, 4 				# Codigo de impressao de string
    syscall 				# Imprime a string
    la $a0, Cpf 			# Endereco da string lida
    li $a1, 32 				# Tamanho maximo da string
    li $v0, 8 				# Codigo de leitura de string
    syscall 				# Le a string
    jal validacao
    li $v0, 10 				# Codigo de saida do programa
    syscall 				# Sai do programa
    
validacao:
    li $t0, 0 				# i = 0
    move $t1, $a0 			# end = &string[0]
    li $t8, 10 				# dez = 10
    li $t9, 11 				# onze = 11
	
	Loop:
    	lb $t4, ($t1) 			# caractere = string[i]
    
	if1:
    	bge $t0, 9, if2 		# if (i >= 9) goto if2
    	subi $t5, $t4, '0' 		# t5 eh = caractere - '0' (converte char para int)
    	sub $t6, $t8, $t0 		# t6 = 10 - i
    	mul $t7, $t5, $t6 		# t7 recebe a multiplicacao do digito[i]*t6
    	add $t2, $t2, $t7 		# adiciona em t2 o somatorio das multiplicacoes
    	addi $t6, $t6, 1 		# mult++
    	mul $t7, $t5, $t6 		# t7 recebe a multiplicacao do digito[i]*t6
    	add $t3, $t3, $t7 		# adiciona em t3 o segundo somatorio das multiplicacoes
    	j validacao_prox
	
	if2:
    	bne $t0, 9, if3 		# if (i != 9) goto if3
    	bne $t4, '-', validacao_falsa	#se o 10o digito (posicao 9) nao eh traco entrada invalida
    	j validacao_prox
    
	if3:
		bne $t0, 10, if4 		# if (i != 10) goto if4
    	div $t2, $t9 			# somatorio1 / onze
    	mfhi $t5 			# t5 recebe o resto
    	
    	if3_1:
        	bge $t5, 2, if3_2 		# if (resto >= 2) goto if3_2
        	li $s0, '0' 			# digito1 = '0'
        	j if3_3
    
    	if3_2:
        	sub $s0, $t9, $t5 		# s0 recebe o valor de 11 - resto
        	sll $t5, $s0, 1 		# d1 * 2
        	add $t3, $t3, $t5 		# soma2 += digito calculado * 2
        	addi $s0, $s0, '0' 		# s0 recebe o digito (converte int para char)
    	
    	if3_3:
        	bne $s0, $t4, validacao_falsa 	# se o digito calculado eh diferente do digitado vai pra saida falsa
        	j validacao_prox

	if4:
    	bne $t0, 11, if5 		# if (i != 11) goto if5
    	div $t3, $t9 			# somatorio 2 / onze
    	mfhi $t5 			# t5 recebe o resto
    
    	if4_1:
        	bge $t5, 2, if4_2 		# if (resto >= 2) goto if4_2
        	li $s1, '0' 			# digito2 = '0'
        	j if4_3
        
    	if4_2:
        	sub $s1, $t9, $t5 		# digito2 = 11 - resto
        	addi $s1, $s1, '0' 		# s1 recebe o digito convertido pra caractere
        
    	if4_3:
        	bne $s1, $t4, validacao_falsa 	# se o digito calculado eh diferente do digitado vai pra saida falsa
        	j validacao_prox
	
	if5:
    	bne $t4, '\n', validacao_falsa 	# if (string[i] != '\n') goto validacao_falsa
    	j validacao_verdadeira
    
	validacao_prox:
    	addi $t0, $t0, 1 		# contabilidade dos caracteres (i++)
    	addi $t1, $t1, 1 		# endereco avanca um byte
    	bnez $t4, Loop
    
	validacao_falsa:
    	la $a0, Sai1 			# Carrega o endereco da string
    	li $v0, 4 			# Codigo de impressao de string
    	syscall 			# Imprime a string
    	jr $ra 				# Retorna para a main
    
	validacao_verdadeira:
		la $a0, Sai0 			# Carrega o endereco da string
    	li $v0, 4 			# Codigo de impressao de string
    	syscall 			# Imprime a string
    	jr $ra 				# Retorna para a main
