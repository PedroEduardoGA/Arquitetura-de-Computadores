#Programa le um arquivo de tamanho N e informa quantas vezes aparece cada elemento do vetor
.data
	entradaN: .asciiz "Insira o numero de posicoes do vetor: "
	msg_pos: .asciiz "Insira valor da posicao["
	fecha_Colchete: .asciiz "]: "
	saida: .asciiz "O valor "
	saida1: .asciiz " aparece "
	saida2: .asciiz " vez(es)!\n"

.text

	li $s7, 0xFFFFFFF			#s7 recebe valor null

	main:
		la $a0, entradaN		#carrega msg de entrada do N em a0
		li $v0, 4			#C�digo de impress�o de string
		syscall
	
		li $v0, 5			#C�digo de leitura de inteiro
		syscall
		move $s0, $v0			#Salva em $s0 o valor lido
		
		move $a0, $s0			#Passa o tamanho do vetor para o argumento $a0
		mul $a0, $a0, 4			#Multiplica o tamanho do vetor por 4 bits
		li $v0, 9			#C�digo de aloca��o din�mica
		syscall
		move $s1, $v0 			#Salva o endere�o base do vetor retornado da fun��o alloc em $s1
	
		move $a0, $s1			#Passa o endere�o base do vetor para o argumento $a0
		move $a1, $s0			#Passa o tamanho do vetor para o argumento $a1
		jal Leitura
	
		move $a0, $s1			#Passa o endereco base do vetor para o parametro
		move $a1, $s0			#Passa o tamanho do vetor para o parametro
		jal frequency
	
		li $v0, 10			#Codigo de finalizacao e finaliza programa
		syscall

	Leitura:
		move $t0, $a0			#Salva o endere�o base do vetor em $t0
		move $t1, $t0			#Salva o endere�o base do vetor em $t1 ($t1 ser� incrementado)
		li $t2, 0			#$t2 recebe 0 (contador de verifica��o)
		move $t3, $a1			#Salva o tamanho do vetor em $t3
	
		Laco:	
			la $a0, msg_pos		#Carrega msg de leitura da posicao
			li $v0, 4		#C�digo de impress�o de string
			syscall
	
			move $a0, $t2		#a0 recebe contador
			li $v0, 1		#C�digo de impress�o de inteiro
			syscall
	
			la $a0, fecha_Colchete	#a0 recebe colchete
			li $v0 4		#C�digo de impress�o de string
			syscall
	
			li $v0, 5		#C�digo de leitura de inteiro
			syscall
	
			sw $v0, ($t1)		#Salva o valor lido no endere�o armazenado em $t1
			addi $t1, $t1, 4	#Incrementa o endere�o do vetor
			addi $t2, $t2, 1	#Incrementa o contador
	
			blt $t2, $t3, Laco	#Pula para l se o contador for menor que o tamanho do vetor
	
			jr $ra
	
	frequency:
		move $t0, $a0			#$t0 recebe o endereco base do vetor
		move $t1, $t0			##t1 recebe o endereco base do vetor (sera incrementado)
		move $t2, $a1			#$t2 recebe o tamanho do vetor
		li $t3, 0			#Reseta o contador
	
		Loop:	
			mul $t1, $t3, 4		#t1 recebe multiplicacao do indice
			add $t1, $t1, $t0	#Endereco da posicao I do vetor
			lw $t4, ($t1)		#Armazena em $t4 o valor armazenado na posicao $t1
			beq $t4, $s7, inc_1	#Pula caso o valor seja igual ao define null
	
			li $t5, 0		#Reseta o contador de frequencia
			move $t6, $t0		#Passa o endereco base do vetor para &t6 (outro registrador para percorrer o vetor)
			li $t7, 0		#Reseta o segundo contador
	
		Loop2:	
			mul $t6, $t7, 4		#t6 recebe multiplicacao do segundo contador por 4
			add $t6, $t6, $t0	#t6 recebe soma do endereco base + posicao calculada
			lw $t8, ($t6)		#Armazena em $t8 o valor do segundo vetor percorrido
	
			bne $t4 $t8, inc_2	#se o valor que esta sendo analisando nao eh igual ao valor atual avanca o segundo ponteiro
			addi $t5, $t5, 1	#Incrementa o contador de frequencia
			sw $s7, ($t6)		#Seta o valor do vetor como null para nao encontra-lo novamente
	
		inc_2:	
			addi $t7, $t7, 1	#Incrementa o contador
			blt $t7, $t2, Loop2	#se contador 2 eh menor do que contador 1 salta pro loop2
	
			la $a0, saida		#carrega msg de saida em a0
			li $v0, 4		#codigo pra imprimir string e imprime o conteudo de a0
			syscall
	
			move $a0, $t4		#a0 recebe valor que esta sendo analisa
			li $v0, 1		#codigo imprimir inteiro e imprime o valor
			syscall
	
			la $a0, saida1		#carrega msg de saida em a0
			li $v0, 4		#codigo pra imprimir string e imprime o conteudo de a0
			syscall
	
			move $a0, $t5		#a0 recebe valor da contador de frequencia
			li $v0, 1		#codigo imprimir inteiro e imprime o valor
			syscall
	
			la $a0, saida2		#carrega msg de saida em a0
			li $v0, 4		#codigo pra imprimir string e imprime o conteudo de a0
			syscall
	
		inc_1:	
			addi $t3, $t3, 1	#Incrementa o contador
			blt $t3, $t2, Loop	#Faz o loop enquanto o contador for menor que o tamanho maximo do vetor
	
			jr $ra	