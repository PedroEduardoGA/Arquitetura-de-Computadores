#Progrma le um vetor de N posições e apresenta um vetor secundário que é primeiro vetor invertido
.data
	msg_entN: .asciiz "\nInsira o valor de N:"
	msg_ent: .asciiz "\nInsira o valor da Posicao["
	fecha: .asciiz "]: "
	msg_erro: .asciiz "Erro! O valor tem que ser maior que 0!\n"
	saida1: .asciiz "\nPrimeiro Vetor:\n "
	saida2: .asciiz "\n\nSegundo Vetor:\n "

.text
	Leitura_N:
		la $a0, msg_entN			#Carrega em a0 o endereco da msg de entrada de n
		li $v0, 4				#Codigo de impressao de string e imprime
		syscall
		li $v0, 5				#Codigo de leitura de inteiro, le o valor e armazena em v0
		syscall
		ble $v0, $zero, Erro        		#Caso o valor digitado de $v0 for menor ou igual ao inteiro "0", vai para Erro
		move $s0, $v0				#s0 recebe valor lido
		
		mul $a0, $s0, 4         		#$a0 recebe o valor lido de N por 4(Espaco ocupado por 1 Byte)
        li $v0, 9               		#Codigo SysCall de alocacao dinamica
        syscall                 		
        move $a3, $v0           		#a3 recebe endereco base do primeiro vetor
        	
        li $v0, 9               		#Codigo SysCall de alocacao dinamica
        syscall   
        move $a2, $v0           		#a2 recebe endereco base do segundo vetor
        	
        jal Leitura				#Salta pro label de leitura do vetor original
        jal Inverte_Vetor			#Salta pro procedimento de inversao dos vetores
        	
        la $a0, saida1				#Carrega em a0 a msg de saida
        li $v0, 4				#codigo para impressao de string
        syscall
        move $a0, $a3				#move pra a0 o endereco base do primeiro vetor
        jal Escrita				#salta pro label de escrita do vetor
        	
        la $a0, saida2				#Carrega em a0 a msg de saida
        li $v0, 4				#codigo para impressao de string
        syscall
        move $a0, $a2				#move pra a0 o endereco base do segundo vetor
        jal Escrita				#salta pro label de escrita do vetor
		
		li $v0, 10				#codigo de finalizacao do programa
		syscall
		
	Leitura:
		li $t0, 0				#inicializa i = 0
		
		Loop:
			bge $t0, $s0, Retorno		#se i for >= N retorna
			mul $t1, $t0, 4			#t1 recebe i * 4(bytes)
			add $t9, $a3, $t1		#t9 recebe = endereco base + posicao calculada
			
			la $a0, msg_ent			#carrega msg de entrada em a0
			li $v0, 4			#codigo de impressao de string e imprime o conteudo de a0
			syscall
			move $a0, $t0			#a0 recebe i atual
			li $v0, 1			#codigo de impressao de inteiro
			syscall	
			la $a0, fecha			#carrega "]: " em a0
			li $v0, 4			#codigo de impressao de string e imprime o conteudo de a0
			syscall
			
			li $v0, 5			#codigo de leitura de inteiro e armazena o mesmo em v0
			syscall	
			sw $v0, ($t9)			#armazena valor lido na posicao do vetor atual
			
			addi $t0, $t0, 1		#i++
			j Loop 
		
	Inverte_Vetor:
		li $t0, 0				#inicializa i = 0
		move $t2, $s0				#t2 recebe tamanho do vetor
		addi $t2, $t2, -1			#inicializa j com tamanho do vetor -1
		
		Loop_Perc:
			bge $t0, $s0, Retorno		#se i for >= N retorna
			mul $t1, $t0, 4			#t1 recebe i * 4(bytes)
			add $t9, $a3, $t1		#t9 recebe = endereco base + posicao calculada
			
			lw $t3, ($t9)			#carrega valor da posicao atual em t3
			mul $t1, $t2, 4			#t1 recebe j * 4(bytes)
			add $t9, $a2, $t1		#t9 recebe = endereco base 2o vetor + posicao calculada
			
			sw $t3, ($t9)			#armazena o valor atual no segundo vetor
			addi $t2, $t2, -1		#j--
			addi $t0, $t0, 1		#i++
			j Loop_Perc
	
	Escrita:
        li $t0, 0                   		#Inicializa $t0 com 0 que sera o contador (i)
        move $a1, $a0               		#Armazena em $a1 o endereco base do vetor
        
        	Laco_Escrita:
        		bge $t0, $s0, Retorno		#se i for >= N retorna
        		mul $t1, $t0, 4			#t1 recebe i * 4(bytes)
				add $t9, $a1, $t1		#t9 recebe = endereco base + posicao calculada
            	lw $a0, ($t9)               	#Carrega em $a0 o valor da posicao (i) do vetor
            		
            	li $v0, 1                   	#Codigo syscall para escrita de inteiros        
            	syscall                    	 #Chamada de sistema para escrita do inteiro
            	li $a0, 32                  	#Codigo SysCall de ASCII para escrever espaco
            	li $v0, 11                  	#Codigo SysCall para imprimir caracteres
            	syscall                     	#Chamada de sistema para impressao do espaco
            	add $t0, $t0, 1             	#i++
            	j Laco_Escrita

	Erro:
        li $v0, 4            			#Chamada de sistema para escrever strings      
        la $a0, msg_erro     			#Carrega em $a0 a variavel "msg_erro"
        syscall             	 		#Imprime a mensagem que esta em $a0
        j Leitura_N       	 		#Salta para o label de Leitura_N
        
	Retorno: jr $ra