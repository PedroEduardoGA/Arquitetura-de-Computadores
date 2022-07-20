#Programa le uma string de um valor e informa se o valor é palindromo ou não
.data
	ent1: .asciiz "Insira o valor: "											#Ent1 recebe a mensagem de entrada da primeira string
	Palindromo: .asciiz "\nO valor digitado eh palindromo!"						#msg caso o valor seja palindromo
	Nao_Palindromo: .asciiz "\nO valor digitado nao eh palindromo!"				#Ent1 recebe a mensagem de entrada da primeira string
	msg_aviso: .asciiz "\nO valor digitado tem que ter mais que 9 caracteres!"
	str1: .space 400															#Define um espaço de 100 bytes para string 1

.text
	main:
		la $a0, ent1				#a0 recebe o endereco da mensagem ent1
		la $a1, str1				#a1 recebe o espaco maximo da string 1
		jal Leitura				#Salto com link pro label Leitura
		
		la $a0, str1				#Carrega em a0 o endereco da string 1
		jal ContaCaracteres			#salta pro label para realizar a contagem de caracteres da string
		
		move $s0, $v0				#armazena em s0 a quantidade de caracteres
		li $t9, 10				#carrega t9 com 10
		blt $s0, $t9, Aviso			#caso o valor tenha menos que 10 caracteres salta pro aviso
		li $t9, 2				#carrega t9 com 2
		div $s0, $t9				#divide o tamanho por 2
		mfhi $t9				#recebe o resto da divisao
		mflo $s1				#s1 recebe o quociente da divisao tamanho / 2
		
		la $a0, str1				#Carrega em a0 o endereco da string 1
		beqz $t9, Verificacao 			#se o resto nao for 0, o valor tem uma quantidade impar de caracteres portanto nao � possivel ser palindromo
		
	Saida:	
		la $a0, Nao_Palindromo			#Carrega a string caso valor nao seja palindromo
		li $v0, 4				#codigo imprimir string e imprime o conteudo de a0
		syscall
	
	Finaliza:	
		li $v0,10				#Codigo de finalizacao da aplicação
		syscall					#Chama de sistema que finaliza o programa
		
	Leitura:
		li $v0, 4				#Codigo sycall para imprimir string
		syscall					#Chamada de sistema que imprime o conteudo de a0
		move $a0, $a1				#a0 recebe o conteudo de $a1
		li $a1, 100				#a1 recebe o valor 100 que eh o espaco definido para string
		li $v0, 8				#Codigo syscall para leitura de uma string
		syscall					#Chamada de sistema que vai ler a string
		
		jr $ra					#Retorna para linha em que o label foi chamado
		
						
	ContaCaracteres:
		move $t5, $a0				#t5 recebe endereco string[0]
		li $t1, 0				#t1 = 0 (i)
		
		Loop:	
			add $t0, $t5, $t1		#t0 recebe endereco String[0] + contador
			beq $t9, 10, end		#se t9 for igual ao 10(decimal caractere nova linha) salta pro fim da contagem
			lb $t9, ($t0)			#t9 recebe o caractere[i]
			
			addi $t1, $t1, 1		#incrementa o contador
			j Loop
			
		end: 
			addi $t1, $t1, -1		#desconsidera o \n
			move $v0, $t1			#move pra t0 a quantidade de caracteres calculada e retorna
			jr $ra
			
	Verificacao:
		move $t5, $a0				#t5 recebe endereco string[0]
		move $t1, $t5				#t1 recebe endereco string[0]
		li $t2, 0				#t2 recebe 0 (i)
		move $t3, $s0				#t3 recebe tamanho da string (j)
		addi $t3, $t3, -1			#t3--
		
		Loop_Verify:
			beq $t2, $s1, Resultado		#se o indice i for igual a metade do tamanho da string salta pro resultado
			add $t0, $t5, $t2		#soma endereco string[0] + indice i
			add $t1, $t5, $t3		#soma endereco string[0] + indice j
			lb $t8, ($t0)			#t8 recebe string[i]
			lb $t9, ($t1)			#t9 recebe string[j]
			
			bne $t8, $t9, Saida		#se o conteudo das 2 posicoes nao for igual nao � palindromo
			addi $t3, $t3, -1		#t3--
			addi $t2, $t2, 1		#t2++
			j Loop_Verify			#Salta pro loop novamente
			
		Resultado:
			la $a0, Palindromo		#Carrega a string caso valor seja palindromo
			li $v0, 4			#Codigo imprimir string e imprime a string
			syscall
			j Finaliza			#salta pro label de finalizacao

	Aviso:
		la $a0, msg_aviso			#carrega msg de aviso em a0
		li $v0, 4				#codigo de string e imprime ela
		syscall
		j Finaliza				#salta pra finalizacao
