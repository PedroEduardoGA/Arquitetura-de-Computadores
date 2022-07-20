#Programa le um valor K e um N e mostra o resultado de K^n
.data
	msg_entK: .asciiz "\nInsira o valor de K:"
	msg_entN: .asciiz "\nInsira o valor de n:"
	saida: .asciiz "\nResultado de K elevado a n: "
	msg_erro: .asciiz "Erro! O valor tem que ser positivo!"

.text
	Main:
		jal Leitura_K				#Salta pro label de leitura do valor de K
		jal Leitura_N				#Salta pro label de leitura do valor de N
		
		la $a0, saida				#Carrega em a0 a msg de saida
		li $v0, 4				#codigo de impressao de string
		syscall
		jal Potencia				#Salta pro label que calcula a potencia K^n
		li $v0, 1				#codigo de impressao de inteiro
		syscall
		
		li $v0, 10				#Codigo de finalizacao do programa
		syscall
		
	Leitura_K:
		la $a0, msg_entK			#Carrega em a0 o endereco da msg de entrada de n
		li $v0, 4				#Codigo de impressao de string e imprime
		syscall
		li $v0, 5				#Codigo de leitura de inteiro, le o valor e armazena em v0
		syscall
		move $s0, $v0				#s0 recebe valor de k lido
		j Retorno	
	
	Leitura_N:
		la $a0, msg_entN			#Carrega em a0 o endereco da msg de entrada de n
		li $v0, 4				#Codigo de impressao de string e imprime
		syscall
		li $v0, 5				#Codigo de leitura de inteiro, le o valor e armazena em v0
		syscall
		blt $v0, $zero, Erro        		#Caso o valor digitado de $v0 for menor ou igual ao inteiro "0", vai para Erro
		move $s1, $v0				#s0 recebe valor de n lido
		j Retorno
	
	Potencia:
		li $t0, 1				#t0 recebe 1 (i)
		li $a0, 1				#a0 valor de retorno recebe 1
		beqz $s1, Retorno			#se o valor de n for igual 0 retorna para main
		
		move $a0, $s0				#a0 recebe valor de K		
		Loop_Pow:
		beq $t0, $s1, Retorno		#enquanto i != n executa loop
		mul $a0, $a0, $s0		#a0 = potencia * K
		addi $t0, $t0, 1		#i++
		j Loop_Pow
		
	Retorno: jr $ra
	
	Erro:
        li $v0, 4            			#Chamada de sistema para escrever strings      
        la $a0, msg_erro     			#Carrega em $a0 a variavel "msg_erro"
        syscall             	 		#Imprime a mensagem que esta em $a0
        j Leitura_N