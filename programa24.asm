#Programa le um valor real para x e um valor n, e calcula a aproximação de cos(x)
.data
	msg_entX: .asciiz "Entre com um valor real: "
	msg_entN: .asciiz "\nEntre com um valor inteiro N: "
	msg_exit: .asciiz "Aproximacao de cos x: "
	
	.align 3
	r: .float 1
	
.text

	jal Leitura					#Salta pro label de leitura dos valores
	move $s1, $s0					#Move pra s1 o valor do N
	move $a0, $s1					#Move pra a0 o valor de s1
	jal loop					#Salta pro loop
	
	Finaliza:
		li $a0, 10				#Carrega a0, codigo ascii pro \n
		li $v0, 11				#Codigo de impressao de caractere e imprime o que esta em a0
		syscall
		
		la $a0, msg_exit			#a0 recebe msg de saida
		li $v0, 4				#codigo de impressao de string e apresenta msg de saida na tela
		syscall
		mov.s $f12, $f8				#move pra f12 o resultado da aproximacao calculada
		li $v0, 2				#codigo de impressao de float e imprime o conteudo de f12
		syscall
		
		li $v0, 10				#Codigo de finalizacao do programa e finaliza
		syscall

	Leitura:
		la $a0, msg_entX			#Carrega em a0 o endereco da msg de entrada
		li $v0, 4				#Codigo de impressao de string e imprime
		syscall
		li $v0, 6				#Codigo de leitura de float e le o valor e armazena em f0
		syscall
		mov.s $f2, $f0				#f2 recebe conteudo de f0

		la $a0, msg_entN			#Carrega em a0 o endereco da msg de entrada de N
		li $v0, 4				#Codigo de impressao de string e imprime
		syscall
		li $v0, 5				#Codigo de leitura de inteiro e le o valor N
		syscall
		move $s0, $v0				#s0 recebe o valor lido de N

		li $a0, 10				#Carrega a0, codigo ascii pro \n
		li $v0, 11				#Codigo de impressao de caractere e imprime o que esta em a0
		syscall

		jr $ra					#Retorna para main

	loop:
		move $s7, $a0				#s7 recebe o valor de a0 (N)
		move $s6, $s7				#s6 recebe o valor de s7 (N)
		mov.s $f4, $f2				#f4 recebe o valor de f2 (X)
		subi $s1, $s1, 1			#N-1
		subi $s6, $s6, 1			#N-1
		subi $s7, $s7, 1			#N-1

		loopL:
			move $s7, $s1			#s7 recebe o valor de s1 (N-1)
			mov.s $f4, $f2			#f4 recebe o valor de f2
			sub $sp,$sp,4			#Libera espaco na pilha
			sw $ra, 0($sp)			#Armazena $ra na pilha

			sll $s6, $s6, 1			#Deslocamento do s6

			jal potencia			#Salta pro label potencia
			
			move $a0, $s6			#a0 recebe o s6 (N atual)
			jal fatorial			#Salta pro label do fatorial
			
			move $s5, $v0			#s5 recebe o valor de v0 ( 2k )
			mtc1 $s5, $f6			#f6 recebe s5
			cvt.s.w $f6, $f6		#Converte de word pra precisao simples
			div.s $f4, $f4, $f6		#f4 recebe o resultado da divisao (x^n) / fatorial
			move $s6, $s1			#s6 recebe s1 
			div $s6, $s6, 2			#s6 recebe a divisao de s6/2
			mfhi $t5			#t5 recebe o resto da divisao
			bnez $t5, menos			#se t5 for diferente de 0 vai pro menos

			add.s $f8, $f8, $f4
			j Recursividade

		menos:
			sub.s $f8, $f8, $f4		#subtrai o valor calculado atual do somatorio total
		
		Recursividade:
			subi $s1, $s1, 1		#s1 recebe -1 (N - 1)
			move $s6, $s1			#s6 recebe o conteudo de s1
			bgtz $s6, loopL			#Se s6 for maior que 0 salta pro loopL
			l.s $f14, r			#Carrega em f14 o float 1
			add.s $f8, $f8, $f14		#Soma o resultado calculado com 1

			j Finaliza			#Salta pro label de finalizacao

	fatorial:
      		li $t9, 1				#t9 recebe 1
      		sub $sp,$sp,8   			#Ajusta a pilha para 2 items
      		sw $ra, 4($sp)   			#Guarda endere�o de retorno
      		sw $a0, 0($sp)   			#Guarda argumento n

      		bgt $a0, $t9, L1   			#Se n >= 1, vai fazer outra chamada

      		li $v0,1      				#Se n�o for devolve 1
      		add $sp,$sp,8   			#Liberta o espa�o da pilha
      		jr $ra      				#Retorna

		L1:   sub $a0,$a0,1   			#Nova chamada: (n - 1)
      		jal fatorial     	 		#Chama novamente o label fatorial

      		lw $a0, 0($sp)   			#Recupera o argumento passado
      		lw $ra, 4($sp)   			#Recupera o endere�o de retorno
      		add $sp,$sp,8   			#Liberta o espa�o da pilha

		mul $v0,$a0,$v0   			#Calcula n * fatorial (n - 1)
      		jr $ra            			#Retorna com o resultado
      
	potencia:
		mov.s $f30,$f4				#f30 recebe o valor de f4 (X)
		li $t0,1				#Carrega t0 com 1
		
		while:  
			beq $t0,$s6,fim  		#se i = N sai do loop
			mul.s $f30,$f30,$f4		# f30 recebe o valor da potenciacao atual * x
			add $t0,$t0,1  			# i++
			j while				#Salta pro laco novamente

		fim:
			mov.s $f4, $f30			#f4 recebe o resultado da potencia
			jr $ra				#Retorna