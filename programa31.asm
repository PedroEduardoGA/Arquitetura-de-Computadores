#Programa le 2 valores inteiros n e p e calcula o arranjo
.data
	msg_entN: .asciiz "Entre com o valor de (n): "
	msg_entP: .asciiz "\nEntre com um valor (p): "
	msg_exit: .asciiz "\nArranjo =  "
	
.text
	main:
		la $a0, msg_entN					#Carrega em a0 o endereco da msg de entrada de n
		li $v0, 4							#Codigo de impressao de string e imprime
		syscall
		li $v0, 5							#Codigo de leitura de inteiro, le o valor e armazena em v0
		syscall
		move $s0, $v0						#s0 recebe valor lido

		la $a0, msg_entP					#Carrega em a0 o endereco da msg de entrada de P
		li $v0, 4							#Codigo de impressao de string e imprime
		syscall
		li $v0, 5							#Codigo de leitura de inteiro, le o valor e armazena em v0
		syscall					
		move $s1, $v0 						#s1 recebe valor lido
		
		move $a0, $s0						#move pra a0 o n
		jal Fatorial						#salta pro label de calculo de fatorial
		move $s7, $v0						#armazena em s7 o fatorial de n
		
		sub $a0, $s0, $s1					#a0 recebe n - p
		jal Fatorial						#salta pro label de calculo de fatorial
		move $s6, $v0						#armazena em s6 o fatorial de (n-p)
		
		la $a0, msg_exit					#a0 recebe mensagem de saida
		li $v0, 4							#codigo de impressao de string
		syscall				
		jal Arranjo							#salta pro label pra calcular o arranjo
		move $a0, $v0						#a0 recebe o resultado
		li $v0, 1							#codigo de impressao de float e imprime o conteudo de f12
		syscall
		
		li $v0, 10							#codigo de finalizacao do programa e finaliza o mesmo
		syscall
		
	Fatorial:
      		li $t9, 1						#t9 recebe 1 que sera usado de controlador
      		li $t0, 1						# fatorial = 1
      		
      		ble $a0, $t9, Return			#se o argumento for menor ou igual a 1 retorna
      		move $t0, $a0					#fatorial($t0) recebe valor inicial de n
      		move $t8, $a0					#t8 recebe valor inicial de n
      		
      		Loop:
      			beq $t8, $t9, Return		#se n atual for igual a 1 retorna
      			sub $t8, $t8, 1				# n - 1
      			mul $t0, $t0, $t8			# t0 = fat * n-1
				j Loop						#salta pro loop novamente
			
      		Return:
      			move $v0, $t0				#move pra v0 o valor retornado da funcao
      			jr $ra      				#Retorna
      	
      	Arranjo:
      		div $v0, $s7, $s6				#v0 recebe o quociente da divisao n! / n-p!
			jr $ra							#retorna pra main
