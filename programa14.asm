#Programa que lê duas strings e cria uma terceira intercalando os caracteres  da primeira e da segunda
.data
	ent1: .asciiz "Insira a string 1: "				#Ent1 recebe a mensagem de entrada da primeira string
	ent2: .asciiz "Insira a string 2: "				#Ent2 recebe a mensagem de entrada da segunda string
	str1: .space 100								#Define um espaço de 100 bytes para string 1
	str2: .space 100								#Define um espaço de 100 bytes para string 2
	str3: .space 200								#Define um espaço de 200 bytes para string 3
	
.text
	main:
		la $a0, ent1				#a0 recebe o endereco da mensagem ent1
		la $a1, str1				#a1 recebe o espaco maximo da string 1
		jal Leitura					#Salto com link pro label Leitura
		
		la $a0, ent2				#a0 recebe o endereco da mensagem ent2
		la $a1, str2				#a1 recebe o espaco maximo da string 2
		jal Leitura					#Salto com link pro label Leitura
		
		la $a0, str1				#Carrega em a0 o endereco da string 1
		la $a1, str2				#Carrega em a1 o endereco da string 2
		la $a2, str3				#Carrega em a2 o endereco da string 3
		
		li $t8, 0					#Inicializa t8 com 0
		li $t9, 200					#Inicializa t9 com 200	
		li $t7, 30					#t7 recebe 30 para ser comparado com os caracteres
		move $t0, $a0				#Posicao 0 da str1 é movida para t0
		move $t1, $a1				#Posicao 0 da str2 é movida para t1
		move $t2, $a2				#Posicao 0 da str3 é movida para t2
		
        jal Intercala				#Salta para o label Intercala
		move $v0, $a2				#v0 recebe o endereco da string 3 resultante
		move $a0, $v0				#a0 recebe o valor de v0
		li $v0, 4					#Codigo sycall para imprimir string
		syscall						#Chamada de sistema que imprime o conteudo de a0
		
		li $v0,10					#Codigo de finalizacao da aplicação
		syscall						#Chama de sistema que finaliza o programa
		
	Leitura:
		li $v0, 4					#Codigo sycall para imprimir string
		syscall						#Chamada de sistema que imprime o conteudo de a0
		move $a0, $a1				#a0 recebe o conteudo de $a1
		li $a1, 100					#a1 recebe o valor 100 que é o espaço definido para string
		li $v0, 8					#Codigo syscall para leitura de uma string
		syscall						#Chamada de sistema que vai ler a string
		
		jr $ra						#Retorna para linha em que o label foi chamado
		
	Intercala:
		
		beq $t8, $t9, EncerraLoop	#Se t8 for igual a t9(Tamanho maximo da string 3) salta para o label de encerramento do loop

		lb $s0, ($t0)				#Carrega em s0 os bytes de t0
		lb $s1, ($t1)				#Carrega em s1 os bytes de t1

		ble $s0, $t7, Str1Vazia		#Se o conteudo do registrador s0 é menor ou igual ao t7 a string 1 nao contem mais caracteres
		ble $s1, $t7, Str2Vazia		#Se o conteudo do registrador s1 é menor ou igual ao t7 a string 2 nao contem mais caracteres

		sb $s0, ($t2)				#Armazena em t2 os bytes de s0
        addi $t2, $t2, 1			#Incrementa t2 em +1 avança pro proximo byte
		sb $s1, ($t2)				#Armazena em t2 os bytes de s1
		
		addi $t0, $t0, 1			#Incrementa t0 em +1 avança pro proximo byte
		addi $t1, $t1, 1			#Incrementa t1 em +1 avança pro proximo byte
		addi $t2, $t2, 1			#Incrementa t2 em +1 avança pro proximo byte
		addi $t8, $t8, 1			#Incrementa t8 em +1, quando este for igual a 200 que é o tamanho maximo da string saira do looping
        j Intercala					#Salta para o label de intercalamento novamente
		
		EncerraLoop:
			jr $ra					#Retorna para a linha em que foi chamado o label "Intercala"

	Str1Vazia:
		beq $t8, $t9, EncerraLoop	#Se t8 for igual a t9(Tamanho maximo da string 3) salta para o label de encerramento do loop
		ble $s1, $t7, EncerraLoop	#Se o conteudo de s1 é menor ou igual ao t7 a string 2 nao contem mais caracteres

		sb $s1, ($t2)				#Armazena em t2 os bytes de s1
		addi $t1, $t1, 1			#Incrementa t1 em +1 avança pro proximo byte
		lb $s1, ($t1)				#Carrega em s1 os bytes de t1

		addi $t2, $t2, 1			#Incrementa t2 em +1 avança pro proximo byte
		addi $t8, $t8, 1			#Incrementa t8 em +1, quando este for igual a 200 que é o tamanho maximo da string saira do looping
        j Str1Vazia					#Salta para o label de intercalamento novamente

	Str2Vazia:
		beq $t8, $t9, EncerraLoop	#Se t8 for igual a t9(Tamanho maximo da string 3) salta para o label de encerramento do loop
		ble $s0, $t7, EncerraLoop	#Se o conteudo de s0 é menor ou igual ao t7 a string 1 nao contem mais caracteres

		sb $s0, ($t2)				#Armazena em t2 os bytes de s0
		addi $t0, $t0, 1			#Incrementa t0 em +1 avança pro proximo byte
		lb $s0, ($t0)				#Carrega em s0 os bytes de t0

		addi $t2, $t2, 1			#Incrementa t2 em +1 avança pro proximo byte
		addi $t8, $t8, 1			#Incrementa t8 em +1, quando este for igual a 200 que é o tamanho maximo da string saira do looping
        j Str2Vazia					#Salta para o label de intercalamento novamente