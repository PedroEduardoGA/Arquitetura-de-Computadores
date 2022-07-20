#Programa le um valor n e escreve em um arquivo .txt os primos gemeos de 1 até n
.data
msg_entrada: .asciiz "Informe n: "
Espaco: .asciiz " - "
Virgula: .asciiz ", "
Arquivo: .asciiz "gemeos.txt"
Buffer: .asciiz " "
Buffer2: .space 20
Erro: .asciiz "Arquivo nao encontrado!\n"

.text
main:
	la $a0, Arquivo 						# Carrega o nome do arquivo
    li $a1, 1 								# Modo escrita
    jal abertura 							# Abre o arquivo
    move $s0, $v0 							# Guarda o file descriptor
    la $a0, msg_entrada 					# Carrega o endereco da string
    li $v0, 4 								# Codigo de impressao de string
    syscall 								# Imprime a string
    li $v0, 5 								# Codigo de leitura de inteiro
    syscall 								# Le o inteiro
    blt $v0, 3, Exit					# if (n < 3) goto Exit
    move $s7, $v0							#s7 recebe o valor lido de n

	li $s1, 3								#carrega s1 com 3 e s2 com 5 que sao os primeiros primos gemeos
	li $s2, 5

	Loop:
		bgt $s2, $s7, Exit

		move $t1, $s1
		jal Primo
		move $t1, $s2
		jal Primo

		jal EscreveInt
		j Incrementa

		Primo:
			li $t8, 2
	
        ForPrimo:	 
        	div  $t1, $t8		            #Divive o valor de $t1 pelo contador $t8(i)
			mfhi $t9		                #$t9 recebe o resto da divis�o acima
	
	        beq, $t9, $zero, Incrementa		#Se o resto da divis�o($t9) for zero o valor n�o � primo
	
	        add $t8, $t8, 1 	            #Incrementa o contador $t8(i) em +1
	        blt $t8, $t1, ForPrimo	        #Se o valor do contador � menor que o valor que esta sendo verificado executa o loop novamente

	        j Eh_Primo                      #Salta para o label que retorna em $v1 o valor 1 que representa que o valor � primo

        	Incrementa:						#incrementa os 2 valores que estao sendo usados para verificacao de primo gemeo
	        	addi $s1, $s1, 2
				addi $s2, $s2, 2
				j Loop
	
        	Eh_Primo: jr $ra
	        		
Exit:
    move $a0, $s0 							# File descriptor
    li $v0, 16 								# Codigo de fechar o arquivo
    syscall 								# Fecha o arquivo
    li $v0, 10 								# Codigo de saida do programa
    syscall 								# Sai do programa
    
abertura:
    li $v0, 13 								# Codigo de leitura de arquivo
    syscall 								# Tenta abrir arquivo
    bgez $v0, a 							# if (file_descriptor >= 0) goto a
    la $a0, Erro 							# else erro: carrega o endereco da string
    li $v0, 4 								# Codigo de impressao de string
    syscall 								# Imprime o erro
    li $v0, 10 								# Codigo de saida do programa
    syscall 								# Finaliza o programa
a:  jr $ra 									# Retorna 

EscreveInt:
	move $a3, $ra							#Salva o ra em a3

	move $a0, $s1							#a0 recebe o valor que sera convertido
	la $a1, Buffer2
	li $v0, 0								#zera v0 e t2(i) que serao contadores
	li $t2, 0				
	jal intToString	

	move $a0, $s0							#file descriptor
	la $a1, Buffer2
	move $a2, $v0							#Quantidade de caracteres para escrita
	li $v0, 15								#codigo para escrita em arquivo
	syscall									#escreve o inteiro que esta em s1 no arquivo
	la $a1, Espaco
	li $a2, 3
	li $v0, 15								#codigo para escrita em arquivo
	syscall									#escreve o " - " no arquivo

	move $a0, $s2							#a0 recebe o valor que sera convertido
	la $a1, Buffer2
	li $v0, 0								#zera v0 e t2(i) que serao contadores
	li $t2, 0				
	jal intToString	

	move $a0, $s0							#file descriptor
	la $a1, Buffer2
	move $a2, $v0							#Quantidade de caracteres para escrita
	li $v0, 15								#codigo para escrita em arquivo
	syscall									#escreve o inteiro que esta em s1 no arquivo
	la $a1, Virgula
	li $a2, 2
	li $v0, 15								#codigo para escrita em arquivo
	syscall									#escreve o ", " no arquivo
	jr $a3									#Retorna para onde foi chamado

intToString:
	div $a0, $a0, 10						#n = n/10
	mfhi $t3								# t3 = resto
	subi $sp, $sp, 4
	sw $t3, ($sp)							#armazena o resto na pilha
	addi $v0, $v0, 1						# caracteres++

	bnez $a0, intToString					#se n for diferente de 0 salta pro intString novamente
	Laco:
		lw $t3, ($sp)						#recupera o resto da pilha e libera espaco da mesma
		addi $sp, $sp, 4

		add $t3, $t3, 48					#converte unidade para caractere
		sb $t3, ($a1)						#armazena t3 no buffer2
		addi $a1, $a1, 1					#incrementa endereco do buffer
		addi $t2, $t2, 1					#i++
		bne $t2, $v0, Laco					#se i for diferente do numero de caracteres salta pro laco novamente
		sb $zero, ($a1)						#armazena zero no buffer de saida
		jr $ra